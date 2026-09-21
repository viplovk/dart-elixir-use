# WalkieTalkie Phoenix Backend

High-concurrency, low-latency ephemeral audio walkie-talkie and encrypted chat backend built on **Elixir**, **Phoenix Channels**, **Phoenix Presence**, and **Membrane Framework**.

## Architecture Highlights

1. **OTP Supervision Tree**:
   - `WalkieTalkie.RoomSupervisor`: DynamicSupervisor managing isolated `Room` GenServers per active ephemeral room.
   - `WalkieTalkie.RoomRegistry`: Fast process registry for PID routing.
   - `ETS :ephemeral_rooms`: In-memory lock-free table indexing active room codes and expiration times.
   - `WalkieTalkieWeb.Presence`: CRDT-based participant tracking (speaking state, mic state, PTT active, connection quality).

2. **Phoenix Channels**:
   - `room:<room_id>`: Live encrypted chat, typing indicators, participant join/leave, room countdown.
   - `voice:<room_id>`: WebRTC signaling (SDP offer, answer, ICE candidates) and sub-10ms Push-To-Talk state propagation.

3. **Membrane Media Architecture**:
   - Designed for media routing, voice activity detection (VAD), and Selective Forwarding Unit (SFU) mode via `Membrane.Pipeline`.
   - Automatic fallback to high-performance P2P WebRTC mesh signaling in edge environments without native C media toolchains.

4. **Zero Persistent Storage**:
   - All state is ephemeral and in-memory.
   - When a room expires or is destroyed, all message buffers, voice state, and presence tables are instantly garbage collected.

## Running Locally

```bash
cd backend
mix deps.get
mix phx.server
```

Server starts on `http://localhost:4000`. WebSocket endpoint is available at `ws://localhost:4000/socket`.

## Running Tests

```bash
mix test
```
