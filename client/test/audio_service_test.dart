import 'package:flutter_test/flutter_test.dart';
import 'package:walkie_talkie_client/services/audio_service.dart';

void main() {
  group('AudioService PTT Tests', () {
    test('PTT start and stop emits proper state transitions', () async {
      final audioService = AudioService();
      expect(audioService.isPttActive, isFalse);

      bool startCalled = false;
      bool stopCalled = false;

      audioService.startPushToTalk(onStateChanged: () {
        startCalled = true;
      });

      expect(audioService.isPttActive, isTrue);
      expect(startCalled, isTrue);

      audioService.stopPushToTalk(onStateChanged: () {
        stopCalled = true;
      });

      expect(audioService.isPttActive, isFalse);
      expect(stopCalled, isTrue);

      audioService.dispose();
    });

    test('PTT cannot be activated when microphone is muted', () {
      final audioService = AudioService();
      audioService.mute();

      expect(audioService.isMuted, isTrue);

      audioService.startPushToTalk();
      expect(audioService.isPttActive, isFalse);

      audioService.dispose();
    });
  });
}
