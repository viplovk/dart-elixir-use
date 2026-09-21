import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/room_service.dart';
import '../widgets/room_header.dart';
import '../widgets/push_to_talk_button.dart';
import '../widgets/waveform.dart';
import '../widgets/participant_tile.dart';
import '../widgets/message_bubble.dart';
import '../theme/app_theme.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<double> _amplitudes = List.filled(24, 0.05);

  @override
  void initState() {
    super.initState();
    final roomService = Provider.of<RoomService>(context, listen: false);
    roomService.audioService.amplitudeStream.listen((amps) {
      if (mounted) {
        setState(() {
          _amplitudes = amps;
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(RoomService roomService) {
    final text = _messageController.text;
    if (text.trim().isNotEmpty) {
      roomService.sendMessage(text);
      _messageController.clear();
      roomService.stopTyping();
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomService = Provider.of<RoomService>(context);
    final room = roomService.currentRoom;
    final currentUser = roomService.currentUser;

    if (room == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer_off_outlined,
                  size: 48, color: AppTheme.alertAmber),
              const SizedBox(height: 16),
              const Text(
                'ROOM EXPIRED OR DISCONNECTED',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Temporary room state and encrypted messages have been cleared.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryNeon,
                  foregroundColor: Colors.black,
                ),
                child: const Text('RETURN TO LOBBY'),
              ),
            ],
          ),
        ),
      );
    }

    final isTransmitting = roomService.audioService.isPttActive;
    final isMuted = roomService.audioService.isMuted;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Header with Ephemeral Countdown
            RoomHeader(
              room: room,
              onLeave: () {
                roomService.leaveRoom();
                Navigator.of(context).pop();
              },
            ),

            // Main Tactical Layout
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;

                  if (isWide) {
                    return Row(
                      children: [
                        // Left Column: Voice Centerpiece & PTT
                        Expanded(
                          flex: 5,
                          child: _buildVoiceCenter(
                              context, roomService, isTransmitting, isMuted),
                        ),
                        const VerticalDivider(
                            width: 1, color: AppTheme.border),
                        // Right Column: Participants & Live Chat
                        Expanded(
                          flex: 4,
                          child: _buildSidePanel(context, roomService),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: _buildVoiceCenter(
                              context, roomService, isTransmitting, isMuted),
                        ),
                        const Divider(height: 1, color: AppTheme.border),
                        Expanded(
                          flex: 4,
                          child: _buildSidePanel(context, roomService),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceCenter(BuildContext context, RoomService roomService,
      bool isTransmitting, bool isMuted) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: AppTheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Push-To-Talk Button
          PushToTalkButton(
            isTransmitting: isTransmitting,
            isMuted: isMuted,
            onPressStart: () => roomService.startPushToTalk(),
            onPressEnd: () => roomService.stopPushToTalk(),
          ),
          const SizedBox(height: 32),

          // Real-time Audio Waveform Visualizer
          WaveformVisualizer(
            amplitudes: _amplitudes,
            isTransmitting: isTransmitting,
          ),
          const SizedBox(height: 20),

          // Mic Mute / Audio control bar
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => roomService.toggleMute(),
                icon: Icon(
                  isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: isMuted ? AppTheme.dangerRed : AppTheme.primaryNeon,
                ),
                tooltip: isMuted ? 'Unmute Microphone' : 'Mute Microphone',
              ),
              const SizedBox(width: 12),
              Text(
                isMuted ? 'MIC MUTED' : 'MIC ACTIVE (STANDBY)',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isMuted ? AppTheme.dangerRed : AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel(BuildContext context, RoomService roomService) {
    return Container(
      color: AppTheme.surface,
      child: Column(
        children: [
          // Member Status List
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.surfaceElevated,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PARTICIPANTS',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMuted,
                  ),
                ),
                Text(
                  '${roomService.currentRoom?.participants.length ?? 1} ONLINE',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: AppTheme.primaryNeon,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 130,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 4),
              children: [
                if (roomService.currentUser != null)
                  ParticipantTile(
                    user: roomService.currentUser!,
                    isSelf: true,
                  ),
                ...?roomService.currentRoom?.participants
                    .where((u) => u.id != roomService.currentUser?.id)
                    .map((user) => ParticipantTile(user: user, isSelf: false)),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),

          // Live Encrypted Chat Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined,
                    size: 13, color: AppTheme.primaryNeon),
                SizedBox(width: 6),
                Text(
                  'EPHEMERAL ENCRYPTED CHAT (E2EE)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Chat Messages Scroll
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: roomService.currentRoom?.messages.length ?? 0,
              itemBuilder: (context, index) {
                final message = roomService.currentRoom!.messages[index];
                return MessageBubble(
                  message: message,
                  isSelf: message.senderId == roomService.currentUser?.id,
                );
              },
            ),
          ),

          // Typing indicator
          if (roomService.typingUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${roomService.typingUsers.join(', ')} typing...',
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    color: AppTheme.transmitCyan,
                  ),
                ),
              ),
            ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppTheme.surfaceElevated,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        roomService.startTyping();
                      } else {
                        roomService.stopTyping();
                      }
                    },
                    onSubmitted: (_) => _sendMessage(roomService),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Transmit encrypted message...',
                      hintStyle: TextStyle(
                          fontSize: 13, color: AppTheme.textMuted),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(roomService),
                  icon: const Icon(Icons.send_rounded,
                      size: 18, color: AppTheme.primaryNeon),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
