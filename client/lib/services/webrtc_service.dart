import 'dart:async';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../models/user.dart';
import 'phoenix_socket.dart';

/// WebRTC Peer-to-Peer Voice Service in Dart.
/// Coordinates SDP offer/answer exchanges, ICE candidate signaling via Phoenix Channels,
/// and manages low-latency Opus audio streams between participants.
class WebRtcService {
  final PhoenixSocketService phoenixSocket;
  final Map<String, RTCPeerConnection> _peerConnections = {};
  MediaStream? _localStream;

  final _connectionQualityController =
      StreamController<ConnectionQuality>.broadcast();
  Stream<ConnectionQuality> get connectionQuality =>
      _connectionQualityController.stream;

  WebRtcService({required this.phoenixSocket});

  /// Initializes local microphone audio track
  Future<void> initializeAudio() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': {
        'echoCancellation': true,
        'noiseSuppression': true,
        'autoGainControl': true,
      },
      'video': false,
    };

    try {
      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      // Keep track disabled until Push-To-Talk is actively held
      setAudioTransmission(false);
    } catch (e) {
      // Audio permission denied or unavailable
      _connectionQualityController.add(ConnectionQuality.disconnected);
    }
  }

  /// Enables or disables live audio transmission (controlled by PTT)
  void setAudioTransmission(bool enabled) {
    if (_localStream != null) {
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = enabled;
      }
    }
  }

  /// Initiates a WebRTC call to a newly joined peer
  Future<void> createOfferForPeer(String peerId) async {
    final pc = await _createPeerConnection(peerId);
    final offer = await pc.createOffer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 0,
    });
    await pc.setLocalDescription(offer);

    // Relay SDP Offer over Phoenix Voice Channel
    await phoenixSocket.pushVoiceEvent('webrtc_offer', {
      'to_peer_id': peerId,
      'sdp': offer.sdp,
      'type': offer.type,
    });
  }

  /// Handles incoming SDP Offer from remote peer
  Future<void> handleOffer(String fromPeerId, String sdp) async {
    final pc = await _createPeerConnection(fromPeerId);
    final description = RTCSessionDescription(sdp, 'offer');
    await pc.setRemoteDescription(description);

    final answer = await pc.createAnswer({
      'offerToReceiveAudio': 1,
      'offerToReceiveVideo': 0,
    });
    await pc.setLocalDescription(answer);

    // Relay SDP Answer over Phoenix Voice Channel
    await phoenixSocket.pushVoiceEvent('webrtc_answer', {
      'to_peer_id': fromPeerId,
      'sdp': answer.sdp,
      'type': answer.type,
    });
  }

  /// Handles incoming SDP Answer from remote peer
  Future<void> handleAnswer(String fromPeerId, String sdp) async {
    final pc = _peerConnections[fromPeerId];
    if (pc != null) {
      final description = RTCSessionDescription(sdp, 'answer');
      await pc.setRemoteDescription(description);
    }
  }

  /// Handles incoming ICE candidate
  Future<void> handleIceCandidate(String fromPeerId, Map<String, dynamic> candidateMap) async {
    final pc = _peerConnections[fromPeerId];
    if (pc != null) {
      final candidate = RTCIceCandidate(
        candidateMap['candidate'],
        candidateMap['sdpMid'],
        candidateMap['sdpMLineIndex'],
      );
      await pc.addCandidate(candidate);
    }
  }

  Future<RTCPeerConnection> _createPeerConnection(String peerId) async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
        {'urls': 'stun:stun1.l.google.com:19302'},
      ],
      'sdpSemantics': 'unified-plan',
    };

    final pc = await createPeerConnection(config);
    _peerConnections[peerId] = pc;

    if (_localStream != null) {
      _localStream!.getTracks().forEach((track) {
        pc.addTrack(track, _localStream!);
      });
    }

    pc.onIceCandidate = (candidate) {
      phoenixSocket.pushVoiceEvent('webrtc_ice_candidate', {
        'to_peer_id': peerId,
        'candidate': {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        },
      });
    };

    pc.onConnectionState = (state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        _connectionQualityController.add(ConnectionQuality.excellent);
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateDisconnected) {
        _connectionQualityController.add(ConnectionQuality.unstable);
      } else if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
        _connectionQualityController.add(ConnectionQuality.disconnected);
      }
    };

    return pc;
  }

  void closePeer(String peerId) {
    _peerConnections[peerId]?.close();
    _peerConnections.remove(peerId);
  }

  void dispose() {
    _localStream?.dispose();
    for (var pc in _peerConnections.values) {
      pc.close();
    }
    _peerConnections.clear();
    _connectionQualityController.close();
  }
}
