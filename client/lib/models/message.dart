class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String senderName;
  final String encryptedPayload;
  final String? nonce;
  final int timestamp;
  final bool isSystem;
  String? decryptedText;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderName,
    required this.encryptedPayload,
    this.nonce,
    required this.timestamp,
    this.isSystem = false,
    this.decryptedText,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      roomId: json['room_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'] ?? 'Operator',
      encryptedPayload: json['encrypted_payload'] ?? '',
      nonce: json['nonce'],
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      isSystem: json['is_system'] ?? false,
      decryptedText: json['is_system'] == true ? json['encrypted_payload'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'sender_name': senderName,
      'encrypted_payload': encryptedPayload,
      'nonce': nonce,
      'timestamp': timestamp,
      'is_system': isSystem,
    };
  }

  String get formattedTime {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min';
  }
}
