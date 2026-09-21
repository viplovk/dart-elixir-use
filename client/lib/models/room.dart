import 'user.dart';
import 'message.dart';

class Room {
  final String roomId;
  final String roomCode;
  final String name;
  final int createdAt;
  final int expiresAt;
  final int maxParticipants;
  final bool voiceEnabled;
  final bool chatEnabled;
  final List<User> participants;
  final List<Message> messages;
  final String? activeSpeakerId;
  final List<String> pttHolders;

  Room({
    required this.roomId,
    required this.roomCode,
    required this.name,
    required this.createdAt,
    required this.expiresAt,
    this.maxParticipants = 16,
    this.voiceEnabled = true,
    this.chatEnabled = true,
    this.participants = const [],
    this.messages = const [],
    this.activeSpeakerId,
    this.pttHolders = const [],
  });

  int get remainingSeconds {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = expiresAt - now;
    return remaining > 0 ? remaining : 0;
  }

  bool get isExpired => remainingSeconds <= 0;

  String get formattedRemainingTime {
    final secs = remainingSeconds;
    final minutes = (secs ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    var rawParticipants = json['participants'];
    List<User> parsedUsers = [];
    if (rawParticipants is List) {
      parsedUsers = rawParticipants
          .map((u) => User.fromJson(Map<String, dynamic>.from(u)))
          .toList();
    }

    var rawMessages = json['messages'];
    List<Message> parsedMessages = [];
    if (rawMessages is List) {
      parsedMessages = rawMessages
          .map((m) => Message.fromJson(Map<String, dynamic>.from(m)))
          .toList();
    }

    final voiceState = json['voice_state'] as Map<String, dynamic>?;

    return Room(
      roomId: json['room_id'] ?? '',
      roomCode: json['room_code'] ?? '',
      name: json['name'] ?? 'Tactical Channel',
      createdAt: json['created_at'] ?? 0,
      expiresAt: json['expires_at'] ?? 0,
      maxParticipants: json['max_participants'] ?? 16,
      voiceEnabled: json['voice_enabled'] ?? true,
      chatEnabled: json['chat_enabled'] ?? true,
      participants: parsedUsers,
      messages: parsedMessages,
      activeSpeakerId: voiceState?['active_speaker'],
      pttHolders: List<String>.from(voiceState?['ptt_holders'] ?? []),
    );
  }

  Room copyWith({
    String? name,
    int? expiresAt,
    List<User>? participants,
    List<Message>? messages,
    String? activeSpeakerId,
    List<String>? pttHolders,
  }) {
    return Room(
      roomId: roomId,
      roomCode: roomCode,
      name: name ?? this.name,
      createdAt: createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      maxParticipants: maxParticipants,
      voiceEnabled: voiceEnabled,
      chatEnabled: chatEnabled,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      activeSpeakerId: activeSpeakerId ?? this.activeSpeakerId,
      pttHolders: pttHolders ?? this.pttHolders,
    );
  }
}
