import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class ParticipantTile extends StatelessWidget {
  final User user;
  final bool isSelf;

  const ParticipantTile({
    Key? key,
    required this.user,
    this.isSelf = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: user.isSpeaking
            ? AppTheme.transmitCyan.withOpacity(0.08)
            : AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: user.isSpeaking ? AppTheme.transmitCyan : AppTheme.border,
          width: user.isSpeaking ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          // Status indicator dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: user.online ? AppTheme.primaryNeon : AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          // User Avatar / Initial
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.border,
            child: Text(
              user.username.isNotEmpty ? user.username[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Name and voice state
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.username + (isSelf ? ' (You)' : ''),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (user.isSpeaking)
                  Row(
                    children: [
                      Text(
                        '🎙 Speaking ',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.transmitCyan,
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        '▂▅▇▅▂',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.transmitCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    user.isPttActive ? 'PTT Active' : 'Standby',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
              ],
            ),
          ),
          // Microphone icon
          Icon(
            user.microphoneState == MicrophoneState.muted
                ? Icons.mic_off_rounded
                : Icons.mic_rounded,
            size: 16,
            color: user.microphoneState == MicrophoneState.muted
                ? AppTheme.dangerRed
                : AppTheme.textMuted,
          ),
          const SizedBox(width: 6),
          // Connection quality icon
          _buildConnectionIcon(user.connectionQuality),
        ],
      ),
    );
  }

  Widget _buildConnectionIcon(ConnectionQuality quality) {
    Color color;
    switch (quality) {
      case ConnectionQuality.excellent:
        color = AppTheme.primaryNeon;
        break;
      case ConnectionQuality.good:
        color = AppTheme.alertAmber;
        break;
      case ConnectionQuality.unstable:
        color = AppTheme.dangerRed;
        break;
      case ConnectionQuality.disconnected:
        color = AppTheme.textMuted;
        break;
    }

    return Icon(Icons.network_wifi_rounded, size: 14, color: color);
  }
}
