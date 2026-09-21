import 'package:flutter_test/flutter_test.dart';
import 'package:walkie_talkie_client/services/encryption_service.dart';

void main() {
  group('EncryptionService Tests', () {
    test('encrypts and decrypts text using symmetric room key', () async {
      final service = EncryptionService();
      await service.initializeKey('ECHO-7K2P', 'room_test_123');

      const clearText = 'Tactical update: Perimeter secured.';
      final encrypted = await service.encrypt(clearText);

      expect(encrypted['ciphertext'], isNotEmpty);
      expect(encrypted['ciphertext'], isNot(equals(clearText)));
      expect(encrypted['nonce'], isNotNull);

      final decrypted = await service.decrypt(
        encrypted['ciphertext']!,
        encrypted['nonce'],
      );

      expect(decrypted, equals(clearText));
    });

    test('fails gracefully when wrong key or corrupted ciphertext', () async {
      final service1 = EncryptionService();
      await service1.initializeKey('KEY_ALPHA', 'salt_1');

      final service2 = EncryptionService();
      await service2.initializeKey('KEY_BETA', 'salt_2');

      final encrypted = await service1.encrypt('Classified communication');
      final decryptedWithWrongKey = await service2.decrypt(
        encrypted['ciphertext']!,
        encrypted['nonce'],
      );

      expect(decryptedWithWrongKey, contains('Encrypted'));
    });
  });
}
