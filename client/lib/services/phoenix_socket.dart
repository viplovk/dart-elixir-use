import 'dart:async';
import 'package:phoenix_socket/phoenix_socket.dart';

/// Dart Service providing high-level abstraction over Phoenix Channels.
/// Connects to WalkieTalkie Phoenix backend and coordinates channel topics.
class PhoenixSocketService {
  PhoenixSocket? _socket;
  PhoenixChannel? _roomChannel;
  PhoenixChannel? _voiceChannel;

  final _roomEventsController = StreamController<Map<String, dynamic>>.broadcast();
  final _voiceEventsController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionStateController = StreamController<PhoenixSocketStatus>.broadcast();

  Stream<Map<String, dynamic>> get roomEvents => _roomEventsController.stream;
  Stream<Map<String, dynamic>> get voiceEvents => _voiceEventsController.stream;
  Stream<PhoenixSocketStatus> get connectionState => _connectionStateController.stream;

  bool get isConnected => _socket?.isConnected ?? false;

  /// Establishes WebSocket connection to Phoenix backend
  Future<void> connect({
    required String endpointUrl,
    required String userId,
    required String username,
  }) async {
    final uri = Uri.parse(endpointUrl).replace(
      queryParameters: {
        'user_id': userId,
        'username': username,
      },
    );

    _socket = PhoenixSocket(
      uri.toString(),
      socketOptions: PhoenixSocketOptions(
        heartbeatInterval: const Duration(seconds: 25),
        reconnectDelays: const [
          Duration(milliseconds: 500),
          Duration(seconds: 1),
          Duration(seconds: 2),
        ],
      ),
    );

    _socket!.openStream.listen((_) {
      _connectionStateController.add(PhoenixSocketStatus.open);
    });

    _socket!.closeStream.listen((_) {
      _connectionStateController.add(PhoenixSocketStatus.closed);
    });

    _socket!.errorStream.listen((_) {
      _connectionStateController.add(PhoenixSocketStatus.error);
    });

    await _socket!.connect();
  }

  /// Joins the text and presence channel for a specific room
  Future<Map<String, dynamic>> joinRoom(String roomId, Map<String, dynamic> userParams) async {
    if (_socket == null) throw StateError('Phoenix socket not connected');

    _roomChannel = _socket!.addChannel(
      topic: 'room:$roomId',
      parameters: userParams,
    );

    _roomChannel!.messages.listen((msg) {
      _roomEventsController.add({
        'event': msg.event.value,
        'payload': msg.payload,
      });
    });

    final response = await _roomChannel!.join().future;
    return response.isOk ? (response.response ?? {}) : throw Exception('Failed to join room channel');
  }

  /// Joins the voice channel for WebRTC signaling and PTT states
  Future<void> joinVoice(String roomId) async {
    if (_socket == null) throw StateError('Phoenix socket not connected');

    _voiceChannel = _socket!.addChannel(
      topic: 'voice:$roomId',
    );

    _voiceChannel!.messages.listen((msg) {
      _voiceEventsController.add({
        'event': msg.event.value,
        'payload': msg.payload,
      });
    });

    await _voiceChannel!.join().future;
  }

  /// Pushes an event to the room channel
  Future<PushResponse?> pushRoomEvent(String event, Map<String, dynamic> payload) {
    if (_roomChannel == null || !_roomChannel!.isJoined) return Future.value(null);
    return _roomChannel!.push(event, payload).future;
  }

  /// Pushes an event to the voice channel (PTT, SDP offer/answer, ICE)
  Future<PushResponse?> pushVoiceEvent(String event, Map<String, dynamic> payload) {
    if (_voiceChannel == null || !_voiceChannel!.isJoined) return Future.value(null);
    return _voiceChannel!.push(event, payload).future;
  }

  /// Leaves channels and closes socket
  Future<void> disconnect() async {
    if (_roomChannel != null) {
      await _roomChannel!.leave().future;
      _roomChannel = null;
    }
    if (_voiceChannel != null) {
      await _voiceChannel!.leave().future;
      _voiceChannel = null;
    }
    if (_socket != null) {
      _socket!.close();
      _socket = null;
    }
  }

  void dispose() {
    disconnect();
    _roomEventsController.close();
    _voiceEventsController.close();
    _connectionStateController.close();
  }
}

enum PhoenixSocketStatus {
  open,
  closed,
  error,
}
