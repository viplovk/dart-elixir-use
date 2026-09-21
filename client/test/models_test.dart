import 'package:flutter_test/flutter_test.dart';
import 'package:walkie_talkie_client/models/user.dart';
import 'package:walkie_talkie_client/models/room.dart';
import 'package:walkie_talkie_client/models/message.dart';

void main() {
  group('User Model Tests', () {
    test('parses User from JSON and serializes back correctly', () {
      final json = {
        'user_id': 'usr_123',
        'username': 'Ghost',
        'avatar_seed': 'avatar_ghost',
        'online': true,
        'microphone_state': 'unmuted',
        'speaking': true,
        'ptt_active': true,
        'connection_quality': 'excellent',
        'joined_at': 1700000000000,
      };

      final user = User.fromJson(json);
      expect(user.id, equals('usr_123'));
      expect(user.username, equals('Ghost'));
      expect(user.isSpeaking, isTrue);
      expect(user.isPttActive, isTrue);
      expect(user.microphoneState, equals(MicrophoneState.unmuted));
      expect(user.connectionQuality, equals(ConnectionQuality.excellent));

      final backToJson = user.toJson();
      expect(backToJson['user_id'], equals('usr_123'));
      expect(backToJson['speaking'], isTrue);
    });
  });

  group('Room Model Tests', () {
    test('calculates remaining seconds and expiration accurately', () {
      final nowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final room = Room(
        roomId: 'room_test',
        roomCode: 'ECHO-99',
        name: 'Test Channel',
        createdAt: nowSec - 100,
        expiresAt: nowSec + 500,
      );

      expect(room.isExpired, isFalse);
      expect(room.remainingSeconds, inInclusiveRange(490, 500));
      expect(room.formattedRemainingTime, matches(r'^\d{2}:\d{2}$'));
    });
  });

  group('Message Model Tests', () {
    test('handles message timestamp formatting', () {
      final msg = Message(
        id: 'msg_1',
        roomId: 'room_1',
        senderId: 'usr_1',
        senderName: 'Viper',
        encryptedPayload: 'U2FsdGVk...',
        timestamp: DateTime(2026, 1, 1, 14, 30).millisecondsSinceEpoch,
      );

      expect(msg.formattedTime, equals('14:30'));
    });
  });
}
