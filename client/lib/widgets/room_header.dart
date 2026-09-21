import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/room.dart';
import '../theme/app_theme.dart';

class RoomHeader extends StatelessWidget {
  final Room room;
  final VoidCallback onLeave;

  const RoomHeader({
    Key? key,
    required this.room,
    required this.onLeave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          // Tactical room name & code
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: room.roomCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Room code ${room.roomCode} copied'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Text(
                            room.roomCode,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryNeon,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.copy_rounded,
                              size: 11, color: AppTheme.textMuted),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              // Ephemeral Expiration indicator
              Row(
                children: [
                  const Icon(Icons.timer_outlined,
                      size: 11, color: AppTheme.alertAmber),
                  const SizedBox(width: 4),
                  Text(
                    'DISAPPEARS IN: ${room.formattedRemainingTime}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.alertAmber,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Leave room button
          OutlinedButton.icon(
            onPressed: onLeave,
            icon: const Icon(Icons.logout_rounded, size: 14, color: AppTheme.dangerRed),
            label: const Text(
              'LEAVE',
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: AppTheme.dangerRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.dangerRed, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}
