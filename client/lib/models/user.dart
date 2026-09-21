enum MicrophoneState {
  unmuted,
  muted,
}

enum ConnectionQuality {
  excellent,
  good,
  unstable,
  disconnected,
}

class User {
  final String id;
  final String username;
  final String avatarSeed;
  final bool online;
  final MicrophoneState microphoneState;
  final bool isSpeaking;
  final bool isPttActive;
  final ConnectionQuality connectionQuality;
  final int joinedAt;

  User({
    required this.id,
    required this.username,
    required this.avatarSeed,
    this.online = true,
    this.microphoneState = MicrophoneState.unmuted,
    this.isSpeaking = false,
    this.isPttActive = false,
    this.connectionQuality = ConnectionQuality.excellent,
    required this.joinedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user_id'] ?? json['id'] ?? '',
      username: json['username'] ?? 'Anonymous',
      avatarSeed: json['avatar_seed'] ?? '',
      online: json['online'] ?? true,
      microphoneState: json['microphone_state'] == 'muted'
          ? MicrophoneState.muted
          : MicrophoneState.unmuted,
      isSpeaking: json['speaking'] ?? false,
      isPttActive: json['ptt_active'] ?? false,
      connectionQuality: _parseQuality(json['connection_quality']),
      joinedAt: json['joined_at'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'avatar_seed': avatarSeed,
      'online': online,
      'microphone_state':
          microphoneState == MicrophoneState.muted ? 'muted' : 'unmuted',
      'speaking': isSpeaking,
      'ptt_active': isPttActive,
      'connection_quality': connectionQuality.name,
      'joined_at': joinedAt,
    };
  }

  User copyWith({
    String? username,
    bool? online,
    MicrophoneState? microphoneState,
    bool? isSpeaking,
    bool? isPttActive,
    ConnectionQuality? connectionQuality,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      avatarSeed: avatarSeed,
      online: online ?? this.online,
      microphoneState: microphoneState ?? this.microphoneState,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isPttActive: isPttActive ?? this.isPttActive,
      connectionQuality: connectionQuality ?? this.connectionQuality,
      joinedAt: joinedAt,
    );
  }

  static ConnectionQuality _parseQuality(dynamic val) {
    if (val == 'good') return ConnectionQuality.good;
    if (val == 'unstable') return ConnectionQuality.unstable;
    if (val == 'disconnected') return ConnectionQuality.disconnected;
    return ConnectionQuality.excellent;
  }
}
