# Wave // Ephemeral Team Walkie-Talkie & Encrypted Chat

A production-quality ephemeral voice communication and end-to-end encrypted live chat platform, designed with **Elixir** and **Dart** as the primary first-class technologies.

Inspired by the interaction models of Discord and Clubhouse, but re-engineered for high-security ephemeral squad operations: **zero disk persistence**, **room auto-expiration**, **sub-10ms push-to-talk signaling**, and **client-side encryption**.

---

## System Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                    DART / FLUTTER CLIENT                    │
│                                                             │
│   • PushToTalkButton ([SPACE] / Mouse / Touch)              │
│   • AudioService (Microphone Capture & Frequency Analysis)  │
│   • WebRtcService (PeerConnection Mesh & SDP Negotiation)   │
│   • EncryptionService (AES-GCM 256 Client-Side E2EE)       │
│   • PhoenixSocketService (Dart Phoenix Channels Client)     │
└──────────────┬───────────────────────────────▲──────────────┘
               │ WebRTC Audio Mesh             │ Phoenix Channels WS
               │ (Opus RTP Streams)            │ (room:* & voice:*)
               ▼                               │
┌──────────────────────────────────────────────┴──────────────┐
│                    ELIXIR PHOENIX BACKEND                   │
│                                                             │
│   • WalkieTalkie.Application (OTP Supervision Root)         │
│   • WalkieTalkie.Rooms.Coordinator (GenServer + ETS Table)  │
│   • WalkieTalkie.Rooms.Room (DynamicSupervisor GenServers)  │
│   • WalkieTalkieWeb.Presence (CRDT Live Voice & PTT State)  │
│   • WalkieTalkieWeb.RoomChannel (Encrypted Chat & Typing)   │
│   • WalkieTalkieWeb.VoiceChannel (WebRTC SDP/ICE Signaling) │
│   • WalkieTalkie.MembranePipeline (Multimedia Processing)   │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Capabilities

### 1. Elixir OTP & Phoenix Real-Time Engine (`/backend`)
- **Supervision Hierarchy**: DynamicSupervisor initiates an isolated `Room` GenServer for every ephemeral room.
- **ETS In-Memory Storage**: `:ephemeral_rooms` table maps dynamic tactical room codes (e.g. `NOVA-7K2P`, `VIPER-IK35`) to GenServer PIDs for $O(1)$ lock-free lookup.
- **Phoenix Channels & Presence**:
  - `room:<room_id>`: Dispatches encrypted messages, participant joins/leaves, and typing telemetry.
  - `voice:<room_id>`: Routes WebRTC SDP offers/answers, ICE candidates, and low-latency PTT status.
  - `Phoenix.Presence`: CRDT-based participant tracking reporting speaking state (`▂▅▇▅▂`), mic status, and WebRTC connection quality.
- **Auto-Expiration (Ephemerality)**:
  - Rooms enforce a strict Time-To-Live (TTL) timer (5m, 15m, 30m, 60m).
  - When the countdown finishes or the room is vacated, all message buffers, voice state, and presence entries are permanently discarded from memory.

### 2. Dart & Flutter Real-Time Client (`/client`)
- **Push-To-Talk Centerpiece**:
  - Activated via keyboard Spacebar (`[SPACE]`), mouse hold, or mobile touch.
  - Instant UI reactivity switching between `HOLD TO TALK` and `● TRANSMITTING`.
- **Audio Abstraction (`AudioService`)**:
  - Real-time microphone capture with audio level frequency bar sampling.
  - Squelch/mic-click sound synthesis for auditory transmission feedback.
- **WebRTC Voice Mesh (`WebRtcService`)**:
  - Peer-to-peer WebRTC connection negotiation with unified-plan SDP exchange over Phoenix Channels.
- **Client-Side E2EE (`EncryptionService`)**:
  - Symmetric 256-bit AES-GCM encryption with PBKDF2 key derivation from ephemeral room secrets.
  - The Elixir Phoenix server acts purely as an oblivious relay; text messages are never readable on the server.

### 3. Membrane Framework Integration
- Defines a dedicated media routing pipeline (`WalkieTalkie.MembranePipeline`) demonstrating audio input depayloading, voice activity gating, and Selective Forwarding Unit (SFU) routing.
- Includes automatic fallback to high-efficiency P2P WebRTC mesh signaling in environments without native C media toolchains.

---

## Directory Structure

```text
├── backend/                             # Elixir / Phoenix Application
│   ├── config/                          # OTP Configuration (config, dev, test, prod)
│   ├── lib/
│   │   ├── walkie_talkie/
│   │   │   ├── application.ex           # Root Supervision Tree
│   │   │   ├── membrane_pipeline.ex     # Membrane Multimedia Pipeline
│   │   │   ├── messaging.ex             # Ephemeral message builder
│   │   │   ├── presence.ex              # Phoenix Presence CRDT Module
│   │   │   ├── rooms/
│   │   │   │   ├── coordinator.ex       # Room Coordinator GenServer & ETS
│   │   │   │   └── room.ex              # Per-Room GenServer & Lifecycle
│   │   │   └── rooms.ex                 # Boundary Context API
│   │   ├── walkie_talkie_web/
│   │   │   ├── channels/
│   │   │   │   ├── room_channel.ex      # Phoenix Chat & Presence Channel
│   │   │   │   ├── user_socket.ex       # Phoenix UserSocket
│   │   │   │   └── voice_channel.ex     # WebRTC & PTT Signaling Channel
│   │   │   ├── controllers/
│   │   │   │   └── room_controller.ex   # REST API Endpoints
│   │   │   ├── endpoint.ex              # Phoenix HTTP & WS Endpoint
│   │   │   ├── router.ex                # API Route Definitions
│   │   │   └── telemetry.ex             # Metrics Supervisor
│   │   └── walkie_talkie_web.ex         # Web Module Definitions
│   ├── test/                            # ExUnit Test Suite
│   │   ├── test_helper.exs
│   │   ├── walkie_talkie/
│   │   │   ├── messaging_test.exs
│   │   │   └── rooms_test.exs
│   │   └── walkie_talkie_web/
│   │       └── channels/
│   │           ├── room_channel_test.exs
│   │           └── voice_channel_test.exs
│   ├── mix.exs                          # Dependencies: Phoenix, PubSub, Membrane
│   └── README.md
│
├── client/                              # Dart / Flutter Client Application
│   ├── lib/
│   │   ├── app.dart                     # MaterialApp with Provider Providers
│   │   ├── main.dart                    # Client Entrypoint
│   │   ├── models/
│   │   │   ├── message.dart             # E2EE Message Entity
│   │   │   ├── room.dart                # Ephemeral Room Model & Timer
│   │   │   └── user.dart                # Participant Presence & Voice State
│   │   ├── screens/
│   │   │   ├── create_room_screen.dart  # Channel Provisioning & TTL Slider
│   │   │   ├── home_screen.dart         # Tactical Terminal Home
│   │   │   ├── join_room_screen.dart    # Room Code Entry Screen
│   │   │   └── room_screen.dart         # 3-Column Tactical Terminal Interface
│   │   ├── services/
│   │   │   ├── audio_service.dart       # Microphone & PTT Audio Engine
│   │   │   ├── encryption_service.dart  # AES-GCM 256 E2EE Cryptography
│   │   │   ├── phoenix_socket.dart      # Phoenix Channels WebSocket Bridge
│   │   │   ├── room_service.dart        # Central State Manager (ChangeNotifier)
│   │   │   └── webrtc_service.dart      # WebRTC SDP & ICE Mesh Service
│   │   ├── theme/
│   │   │   └── app_theme.dart           # Tactical Dark Theme Palette
│   │   └── widgets/
│   │       ├── connection_indicator.dart
│   │       ├── message_bubble.dart
│   │       ├── participant_tile.dart    # Live Speaking Animation (▂▅▇▅▂)
│   │       ├── push_to_talk_button.dart # Glowing Central PTT Button
│   │       ├── room_header.dart         # Countdown Bar & Code Copy
│   │       └── waveform.dart            # Frequency Audio Waveform
│   ├── test/                            # Dart Unit Tests
│   │   ├── audio_service_test.dart
│   │   ├── encryption_service_test.dart
│   │   └── models_test.dart
│   ├── pubspec.yaml                     # Dependencies: phoenix_socket, flutter_webrtc
│   └── README.md
│
└── public/                              # Live Web Comms Terminal (Integrated Preview)
    └── index.html                       # Tactical Communications Terminal UI
```

---

## Running the Application

### 1. Elixir Phoenix Backend

```bash
cd backend
mix deps.get
mix phx.server
```
Runs at `http://localhost:4000` with WebSocket endpoint at `ws://localhost:4000/socket`.

Run the backend test suite:
```bash
mix test
```

### 2. Dart Flutter Client

```bash
cd client
flutter pub get
flutter run -d chrome  # or macos / windows / ios / android
```

Run the client test suite:
```bash
flutter test
```
