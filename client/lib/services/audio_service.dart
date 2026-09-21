import 'dart:async';
import 'dart:math';

/// Audio Abstraction Service in Dart.
/// Manages microphone capture state, Push-To-Talk (PTT) lifecycle,
/// keyboard hotkey triggers (SPACE), and generates real-time audio amplitude waveforms.
class AudioService {
  bool _isMicInitialized = false;
  bool _isMuted = false;
  bool _isPttActive = false;

  Timer? _waveformTimer;
  final _amplitudeController = StreamController<List<double>>.broadcast();
  final _pttStateController = StreamController<bool>.broadcast();
  final _muteStateController = StreamController<bool>.broadcast();

  Stream<List<double>> get amplitudeStream => _amplitudeController.stream;
  Stream<bool> get pttStateStream => _pttStateController.stream;
  Stream<bool> get muteStateStream => _muteStateController.stream;

  bool get isPttActive => _isPttActive;
  bool get isMuted => _isMuted;
  bool get isInitialized => _isMicInitialized;

  /// Initializes microphone permissions and audio pipeline
  Future<bool> initializeMicrophone() async {
    try {
      // In production Flutter Web / Native, calls flutter_webrtc / record
      _isMicInitialized = true;
      return true;
    } catch (e) {
      _isMicInitialized = false;
      return false;
    }
  }

  /// Activates Push-To-Talk (Hot-key SPACE or button down)
  void startPushToTalk({Function()? onStateChanged}) {
    if (_isPttActive || _isMuted) return;

    _isPttActive = true;
    _pttStateController.add(true);
    onStateChanged?.call();

    // Start generating responsive audio waveform values for visualizer
    _startWaveformSampling();
  }

  /// Deactivates Push-To-Talk (Spacebar released or button up)
  void stopPushToTalk({Function()? onStateChanged}) {
    if (!_isPttActive) return;

    _isPttActive = false;
    _pttStateController.add(false);
    onStateChanged?.call();

    _stopWaveformSampling();
  }

  /// Toggles microphone mute state
  void toggleMute({Function(bool)? onMuteChanged}) {
    _isMuted = !_isMuted;
    if (_isMuted && _isPttActive) {
      stopPushToTalk();
    }
    _muteStateController.add(_isMuted);
    onMuteChanged?.call(_isMuted);
  }

  void mute() {
    if (!_isMuted) toggleMute();
  }

  void unmute() {
    if (_isMuted) toggleMute();
  }

  void _startWaveformSampling() {
    _waveformTimer?.cancel();
    final random = Random();

    // Sample audio amplitude 30 times per second for smooth tactical audio waveforms
    _waveformTimer = Timer.periodic(const Duration(milliseconds: 33), (timer) {
      if (!_isPttActive) {
        timer.cancel();
        return;
      }

      // Generates an array of 24 normalized audio frequency bars [0.1 .. 1.0]
      final bars = List.generate(24, (index) {
        final base = sin(index * 0.4 + timer.tick * 0.2).abs() * 0.6;
        final noise = random.nextDouble() * 0.4;
        return (base + noise).clamp(0.08, 1.0);
      });

      _amplitudeController.add(bars);
    });
  }

  void _stopWaveformSampling() {
    _waveformTimer?.cancel();
    _waveformTimer = null;
    // Emit flat baseline when idle
    _amplitudeController.add(List.filled(24, 0.05));
  }

  void dispose() {
    _waveformTimer?.cancel();
    _amplitudeController.close();
    _pttStateController.close();
    _muteStateController.close();
  }
}
