# WalkieTalkie Dart & Flutter Client

Modern tactical walkie-talkie and encrypted chat client written in **Dart** and **Flutter**.

## Architectural Highlights

- **Push-To-Talk Centerpiece**: Real-time microphone capture with multi-input support:
  - Mouse down/up
  - Touch press/release
  - Keyboard Spacebar hotkey (`[SPACE]`)
- **Phoenix Channels Integration**: Native Dart client (`phoenix_socket`) interfacing with Phoenix Channels (`room:*` and `voice:*`) and Phoenix Presence.
- **WebRTC Voice Mesh**: Low-latency voice streaming using Opus audio codecs with SDP signaling over Phoenix WebSockets.
- **Client-Side E2EE**: AES-GCM 256-bit encryption with key derivation from ephemeral room secrets. Server relay never observes cleartext chat.
- **Visual Waveform**: Responsive audio visualizer reactive to voice transmission amplitude.
- **Tactical UI/UX**: Dark glassmorphism terminal palette with monospace telemetry, participant speaking animations (`▂▅▇▅▂`), and live room expiration countdowns.

## Directory Structure

```text
client/
├── lib/
│   ├── app.dart                   # Root MaterialApp with Provider hierarchy
│   ├── main.dart                  # Flutter entrypoint
│   ├── models/
│   │   ├── connection_state.dart
│   │   ├── message.dart           # Encrypted message entity
│   │   ├── room.dart              # Ephemeral room lifecycle & countdown
│   │   └── user.dart              # Participant presence & voice profile
│   ├── screens/
│   │   ├── create_room_screen.dart# Room provisioning & TTL selection
│   │   ├── home_screen.dart       # Tactical comms terminal home
│   │   ├── join_room_screen.dart  # Code entry & channel connection
│   │   └── room_screen.dart       # 3-column tactical terminal layout
│   ├── services/
│   │   ├── audio_service.dart     # Microphone capture & PTT hotkeys
│   │   ├── encryption_service.dart# AES-GCM 256 E2EE engine
│   │   ├── phoenix_socket.dart    # Phoenix Channels WebSocket bridge
│   │   ├── room_service.dart      # Central state manager & Presence
│   │   └── webrtc_service.dart    # WebRTC SDP & ICE peer signaling
│   ├── theme/
│   │   └── app_theme.dart         # Tactical dark theme definition
│   └── widgets/
│       ├── connection_indicator.dart
│       ├── message_bubble.dart    # E2EE chat bubble
│       ├── participant_tile.dart  # Speaking indicators & status
│       ├── push_to_talk_button.dart# Glowing PTT centerpiece
│       ├── room_header.dart       # Ephemeral countdown bar
│       └── waveform.dart          # Audio-reactive frequency visualizer
└── test/
    ├── audio_service_test.dart
    ├── encryption_service_test.dart
    └── models_test.dart
```

## Running the Flutter Client

```bash
cd client
flutter pub get
flutter run -d chrome # or macos / windows / android / ios
```

## Running Client Tests

```bash
flutter test
```
