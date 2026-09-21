import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/room.dart';
import '../models/user.dart';
import '../models/message.dart';
import 'phoenix_socket.dart';
import 'encryption_service.dart';
import 'audio_service.dart';
import 'webrtc_service.dart';

/// Central State Manager for the Walkie-Talkie client in Dart.
/// Coordinates Phoenix Channels, Presence CRDTs, Audio PTT, WebRTC voice,
/// and client-side E2EE encryption.
class RoomService extends ChangeNotifier {
  final PhoenixSocketService socketService;
  final EncryptionService encryptionService;
  final AudioService audioService;
  late final WebRtcService webrtcService;

  User? _currentUser;
  Room? _currentRoom;
  bool _isLoading = false;
  String? _errorMessage;
  Timer? _countdownTimer;
  final Set<String> _typingUsers = {};

  User? get currentUser => _currentUser;
  Room? get currentRoom => _currentRoom;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get typingUsers => _typingUsers;

  RoomService({
    required this.socketService,
    required this.encryptionService,
    required this.audioService,
  }) {
    webrtcService = WebRtcService(phoenixSocket: socketService);
    _listenToChannelEvents();
  }

  void setCurrentUser(String username) {
    final id = 'usr_${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
    _currentUser = User(
      id: id,
      username: username.isEmpty ? 'Tactical-$id' : username,
      avatarSeed: id,
      joinedAt: DateTime.now().millisecondsSinceEpoch,
    );
    notifyListeners();
  }

  /// Creates and joins an ephemeral room
  Future<bool> createRoom({
    required String name,
    int ttlSeconds = 1800,
    int maxParticipants = 16,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final roomId = 'room_${DateTime.now().millisecondsSinceEpoch}';
      final roomCode = _generateLocalCode();

      // Derive encryption key from roomCode
      await encryptionService.initializeKey(roomCode, roomId);

      _currentRoom = Room(
        roomId: roomId,
        roomCode: roomCode,
        name: name,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        expiresAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + ttlSeconds,
        maxParticipants: maxParticipants,
      );

      // Join Phoenix Channel
      await socketService.joinRoom(roomId, {
        'username': _currentUser?.username ?? 'Agent',
        'avatar_seed': _currentUser?.avatarSeed ?? '',
      });

      await socketService.joinVoice(roomId);
      await webrtcService.initializeAudio();

      _startExpirationTimer();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create ephemeral room: $e';
      _setLoading(false);
      return false;
    }
  }

  /// Joins an existing ephemeral room by code
  Future<bool> joinRoomByCode(String code) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final sanitizedCode = code.trim().toUpperCase();
      final roomId = 'room_${sanitizedCode.replaceAll('-', '_')}';

      await encryptionService.initializeKey(sanitizedCode, roomId);

      _currentRoom = Room(
        roomId: roomId,
        roomCode: sanitizedCode,
        name: 'Tactical $sanitizedCode',
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        expiresAt: (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 1800,
      );

      await socketService.joinRoom(roomId, {
        'username': _currentUser?.username ?? 'Agent',
        'avatar_seed': _currentUser?.avatarSeed ?? '',
      });

      await socketService.joinVoice(roomId);
      await webrtcService.initializeAudio();

      _startExpirationTimer();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = 'Room not found or expired';
      _setLoading(false);
      return false;
    }
  }

  /// Sends an encrypted live text message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _currentRoom == null || _currentUser == null) return;

    // Encrypt payload client-side before transmission
    final encrypted = await encryptionService.encrypt(text);

    await socketService.pushRoomEvent('send_message', {
      'encrypted_payload': encrypted['ciphertext'],
      'nonce': encrypted['nonce'],
    });

    // Optimistically add to local messages
    final message = Message(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      roomId: _currentRoom!.roomId,
      senderId: _currentUser!.id,
      senderName: _currentUser!.username,
      encryptedPayload: encrypted['ciphertext']!,
      nonce: encrypted['nonce'],
      timestamp: DateTime.now().millisecondsSinceEpoch,
      decryptedText: text,
    );

    _currentRoom = _currentRoom!.copyWith(
      messages: [message, ..._currentRoom!.messages],
    );
    notifyListeners();
  }

  /// Push-To-Talk Activated (Holding SPACE or pressing screen button)
  void startPushToTalk() {
    if (audioService.isMuted) return;
    audioService.startPushToTalk(onStateChanged: () {
      webrtcService.setAudioTransmission(true);
      socketService.pushVoiceEvent('push_to_talk_start', {});
      notifyListeners();
    });
  }

  /// Push-To-Talk Released
  void stopPushToTalk() {
    audioService.stopPushToTalk(onStateChanged: () {
      webrtcService.setAudioTransmission(false);
      socketService.pushVoiceEvent('push_to_talk_stop', {});
      notifyListeners();
    });
  }

  /// Toggle Microphone Mute
  void toggleMute() {
    audioService.toggleMute(onMuteChanged: (isMuted) {
      final event = isMuted ? 'mute' : 'unmute';
      socketService.pushVoiceEvent(event, {});
      notifyListeners();
    });
  }

  void startTyping() {
    socketService.pushRoomEvent('typing_start', {});
  }

  void stopTyping() {
    socketService.pushRoomEvent('typing_stop', {});
  }

  void leaveRoom() {
    _countdownTimer?.cancel();
    socketService.pushRoomEvent('leave_room', {});
    socketService.disconnect();
    encryptionService.clearKey();
    _currentRoom = null;
    notifyListeners();
  }

  void _listenToChannelEvents() {
    socketService.roomEvents.listen((eventData) async {
      final event = eventData['event'];
      final payload = eventData['payload'] as Map<String, dynamic>? ?? {};

      if (event == 'new_message' && _currentRoom != null) {
        final rawMsg = Message.fromJson(payload);
        if (rawMsg.senderId != _currentUser?.id) {
          rawMsg.decryptedText = await encryptionService.decrypt(
            rawMsg.encryptedPayload,
            rawMsg.nonce,
          );
          _currentRoom = _currentRoom!.copyWith(
            messages: [rawMsg, ..._currentRoom!.messages],
          );
          notifyListeners();
        }
      } else if (event == 'presence_diff' || event == 'presence_state') {
        _handlePresenceUpdate(payload);
      } else if (event == 'user_typing_start') {
        final username = payload['username'] as String?;
        if (username != null) {
          _typingUsers.add(username);
          notifyListeners();
        }
      } else if (event == 'user_typing_stop') {
        final username = payload['username'] as String?;
        if (username != null) {
          _typingUsers.remove(username);
          notifyListeners();
        }
      } else if (event == 'room_expired') {
        _errorMessage = 'Session Expired. Temporary room data has been cleared.';
        _currentRoom = null;
        notifyListeners();
      }
    });

    socketService.voiceEvents.listen((eventData) {
      final event = eventData['event'];
      final payload = eventData['payload'] as Map<String, dynamic>? ?? {};

      if (event == 'speaking_start') {
        _currentRoom = _currentRoom?.copyWith(
          activeSpeakerId: payload['user_id'],
        );
        notifyListeners();
      } else if (event == 'speaking_stop') {
        _currentRoom = _currentRoom?.copyWith(
          activeSpeakerId: null,
        );
        notifyListeners();
      }
    });
  }

  void _handlePresenceUpdate(Map<String, dynamic> payload) {
    // Updates participants list from Phoenix Presence state
    notifyListeners();
  }

  void _startExpirationTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentRoom == null) {
        timer.cancel();
        return;
      }
      if (_currentRoom!.isExpired) {
        timer.cancel();
        _errorMessage = 'Session expired. All ephemeral messages discarded.';
        _currentRoom = null;
      }
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  String _generateLocalCode() {
    final prefixes = ['NOVA', 'ECHO', 'PULSE', 'VIPER', 'DELTA', 'HAWK'];
    final prefix = (prefixes..shuffle()).first;
    final suffix = DateTime.now().millisecondsSinceEpoch.toRadixString(36).substring(4, 8).toUpperCase();
    return '$prefix-$suffix';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    webrtcService.dispose();
    audioService.dispose();
    socketService.dispose();
    super.dispose();
  }
}
