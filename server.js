import express from 'express';
import http from 'http';
import path from 'path';
import { fileURLToPath } from 'url';
import { WebSocketServer, WebSocket } from 'ws';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const server = http.createServer(app);
const PORT = process.env.PORT || 3000;

app.use(express.json());

// In-Memory Ephemeral Room State (matching WalkieTalkie.Rooms OTP model)
const rooms = new Map();
const roomCodes = new Map();

function generateRoomCode() {
  const prefixes = ['NOVA', 'ECHO', 'PULSE', 'VIPER', 'DELTA', 'HAWK', 'OMEGA', 'SIGMA'];
  const prefix = prefixes[Math.floor(Math.random() * prefixes.length)];
  const suffix = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `${prefix}-${suffix}`;
}

function createRoom({ name = 'Alpha Tactical', ttlSeconds = 1800, maxParticipants = 16 }) {
  const roomId = `room_${Date.now()}_${Math.random().toString(36).substr(2, 5)}`;
  const roomCode = generateRoomCode();
  const now = Math.floor(Date.now() / 1000);
  const expiresAt = now + ttlSeconds;

  const room = {
    roomId,
    roomCode,
    name,
    createdAt: now,
    expiresAt,
    ttlSeconds,
    maxParticipants,
    voiceEnabled: true,
    chatEnabled: true,
    participants: new Map(),
    messages: [],
    voiceState: {
      activeSpeaker: null,
      pttHolders: new Set()
    }
  };

  rooms.set(roomId, room);
  roomCodes.set(roomCode, roomId);

  // Auto-cleanup timer
  setTimeout(() => {
    if (rooms.has(roomId)) {
      destroyRoom(roomId);
    }
  }, ttlSeconds * 1000);

  return serializeRoom(room);
}

function destroyRoom(roomId) {
  const room = rooms.get(roomId);
  if (room) {
    roomCodes.delete(room.roomCode);
    rooms.delete(roomId);
    broadcastToTopic(`room:${roomId}`, 'room_expired', { reason: 'TTL elapsed' });
  }
}

function serializeRoom(room) {
  const now = Math.floor(Date.now() / 1000);
  const remaining = Math.max(0, room.expiresAt - now);

  return {
    room_id: room.roomId,
    room_code: room.roomCode,
    name: room.name,
    created_at: room.createdAt,
    expires_at: room.expiresAt,
    ttl_seconds: room.ttlSeconds,
    remaining_seconds: remaining,
    max_participants: room.maxParticipants,
    participant_count: room.participants.size,
    voice_enabled: room.voiceEnabled,
    chat_enabled: room.chatEnabled,
    participants: Array.from(room.participants.values()),
    messages: room.messages.slice(-50),
    voice_state: {
      active_speaker: room.voiceState.activeSpeaker,
      ptt_holders: Array.from(room.voiceState.pttHolders)
    }
  };
}

// Seed an initial demo room for instant access
createRoom({ name: 'Alpha Tactical Base', ttlSeconds: 3600 });

// --- REST API Endpoints (Phoenix Router parity) ---

app.get('/api/health', (req, res) => {
  res.json({
    status: 'online',
    service: 'walkie_talkie_phoenix_runtime',
    architecture: 'Elixir/OTP + Dart WebRTC',
    timestamp: Date.now()
  });
});

app.get('/api/rooms', (req, res) => {
  const list = Array.from(rooms.values()).map(serializeRoom);
  res.json({ rooms: list, count: list.length });
});

app.post('/api/rooms', (req, res) => {
  const { name, ttl_seconds, max_participants } = req.body;
  const room = createRoom({
    name,
    ttlSeconds: ttl_seconds || 1800,
    maxParticipants: max_participants || 16
  });
  res.status(201).json({ success: true, room });
});

app.get('/api/rooms/code/:code', (req, res) => {
  const code = (req.params.code || '').toUpperCase().trim();
  const roomId = roomCodes.get(code);
  if (roomId && rooms.has(roomId)) {
    res.json({ success: true, room: serializeRoom(rooms.get(roomId)) });
  } else {
    res.status(404).json({ success: false, error: 'Room not found or expired' });
  }
});

app.get('/api/rooms/:id', (req, res) => {
  const room = rooms.get(req.params.id);
  if (room) {
    res.json({ success: true, room: serializeRoom(room) });
  } else {
    res.status(404).json({ success: false, error: 'Room not found' });
  }
});

app.get('/api/webrtc/config', (req, res) => {
  res.json({
    iceServers: [
      { urls: ['stun:stun.l.google.com:19302', 'stun:stun1.l.google.com:19302'] },
      { urls: ['stun:stun.cloudflare.com:3478'] }
    ]
  });
});

// --- Phoenix Channels Protocol WebSocket Server ---
const wss = new WebSocketServer({ server, path: '/socket/websocket' });

// Track client subscriptions: topic -> Set of ws clients
const topicSubscriptions = new Map();

function broadcastToTopic(topic, event, payload, excludeWs = null) {
  const subs = topicSubscriptions.get(topic);
  if (!subs) return;

  const msg = JSON.stringify([null, null, topic, event, payload]);
  for (const client of subs) {
    if (client !== excludeWs && client.readyState === WebSocket.OPEN) {
      client.send(msg);
    }
  }
}

wss.on('connection', (ws, req) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const userId = url.searchParams.get('user_id') || `usr_${Math.random().toString(36).substr(2, 6)}`;
  const username = url.searchParams.get('username') || `Operator-${userId.substr(4, 4)}`;

  ws.userId = userId;
  ws.username = username;
  ws.subscribedTopics = new Set();

  ws.on('message', (data) => {
    try {
      // Phoenix Channels format: [joinRef, msgRef, topic, event, payload]
      const parsed = JSON.parse(data.toString());
      if (!Array.isArray(parsed)) return;

      const [joinRef, msgRef, topic, event, payload] = parsed;

      // Handle Phoenix Join
      if (event === 'phx_join') {
        if (!topicSubscriptions.has(topic)) {
          topicSubscriptions.set(topic, new Set());
        }
        topicSubscriptions.get(topic).add(ws);
        ws.subscribedTopics.add(topic);

        // Acknowledge join
        ws.send(JSON.stringify([joinRef, msgRef, topic, 'phx_reply', { status: 'ok', response: { status: 'connected' } }]));

        // Handle Room Topic Join
        if (topic.startsWith('room:')) {
          const roomId = topic.replace('room:', '');
          const room = rooms.get(roomId);

          if (room) {
            const user = {
              user_id: userId,
              username: payload.username || username,
              avatar_seed: payload.avatar_seed || userId,
              online: true,
              microphone_state: 'unmuted',
              speaking: false,
              ptt_active: false,
              connection_quality: 'excellent',
              joined_at: Date.now()
            };
            room.participants.set(userId, user);

            // Send presence state to joining user
            const presenceState = {};
            for (const [pId, p] of room.participants.entries()) {
              presenceState[pId] = { metas: [p] };
            }

            ws.send(JSON.stringify([null, null, topic, 'presence_state', presenceState]));
            ws.send(JSON.stringify([null, null, topic, 'room_state', serializeRoom(room)]));

            // Broadcast join notification
            broadcastToTopic(topic, 'user_joined', { user }, ws);
          }
        }
        return;
      }

      // Heartbeat
      if (topic === 'phoenix' && event === 'heartbeat') {
        ws.send(JSON.stringify([null, msgRef, 'phoenix', 'phx_reply', { status: 'ok', response: {} }]));
        return;
      }

      // Live Text Chat
      if (event === 'send_message') {
        const roomId = topic.replace('room:', '');
        const room = rooms.get(roomId);

        const newMsg = {
          id: `msg_${Date.now()}_${Math.random().toString(36).substr(2, 4)}`,
          room_id: roomId,
          sender_id: userId,
          sender_name: ws.username,
          encrypted_payload: payload.encrypted_payload || '',
          nonce: payload.nonce || null,
          timestamp: Date.now(),
          is_system: false
        };

        if (room) {
          room.messages.push(newMsg);
        }

        broadcastToTopic(topic, 'new_message', newMsg);
        ws.send(JSON.stringify([joinRef, msgRef, topic, 'phx_reply', { status: 'ok', response: { status: 'delivered' } }]));
        return;
      }

      // Typing indicators
      if (event === 'typing_start') {
        broadcastToTopic(topic, 'user_typing_start', { user_id: userId, username: ws.username }, ws);
        return;
      }
      if (event === 'typing_stop') {
        broadcastToTopic(topic, 'user_typing_stop', { user_id: userId }, ws);
        return;
      }

      // Voice Channel & Push-To-Talk events
      if (topic.startsWith('voice:')) {
        const roomId = topic.replace('voice:', '');
        const room = rooms.get(roomId);

        if (event === 'push_to_talk_start') {
          if (room) {
            room.voiceState.activeSpeaker = userId;
            room.voiceState.pttHolders.add(userId);
            const user = room.participants.get(userId);
            if (user) user.speaking = true;
          }
          broadcastToTopic(topic, 'speaking_start', { user_id: userId, timestamp: Date.now() });
          ws.send(JSON.stringify([joinRef, msgRef, topic, 'phx_reply', { status: 'ok', response: { status: 'transmitting' } }]));
          return;
        }

        if (event === 'push_to_talk_stop') {
          if (room) {
            if (room.voiceState.activeSpeaker === userId) {
              room.voiceState.activeSpeaker = null;
            }
            room.voiceState.pttHolders.delete(userId);
            const user = room.participants.get(userId);
            if (user) user.speaking = false;
          }
          broadcastToTopic(topic, 'speaking_stop', { user_id: userId, timestamp: Date.now() });
          ws.send(JSON.stringify([joinRef, msgRef, topic, 'phx_reply', { status: 'ok', response: { status: 'idle' } }]));
          return;
        }

        // WebRTC Signaling routing (offer, answer, ICE)
        if (event === 'webrtc_offer' || event === 'webrtc_answer' || event === 'webrtc_ice_candidate') {
          broadcastToTopic(topic, event, { ...payload, from_peer_id: userId }, ws);
          ws.send(JSON.stringify([joinRef, msgRef, topic, 'phx_reply', { status: 'ok', response: {} }]));
          return;
        }
      }
    } catch (e) {
      console.error('Socket message parse error:', e);
    }
  });

  ws.on('close', () => {
    for (const topic of ws.subscribedTopics) {
      const subs = topicSubscriptions.get(topic);
      if (subs) {
        subs.delete(ws);
      }

      if (topic.startsWith('room:')) {
        const roomId = topic.replace('room:', '');
        const room = rooms.get(roomId);
        if (room) {
          room.participants.delete(userId);
          broadcastToTopic(topic, 'user_left', { user_id: userId });
        }
      }
    }
  });
});

// Serve static frontend assets
const publicDir = path.join(__dirname, 'public');
app.use(express.static(publicDir));

// Fallback for SPA routing
app.use((req, res) => {
  res.sendFile(path.join(publicDir, 'index.html'));
});

server.listen(PORT, '0.0.0.0', () => {
  console.log(`Walkie-Talkie Tactical Server running on http://0.0.0.0:${PORT}`);
});
