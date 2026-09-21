import 'package:flutter/material.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isSelf;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSelf,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.isSystem) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        alignment: Alignment.center,
        child: Text(
          '⚡ SYSTEM: ${message.decryptedText ?? message.encryptedPayload}',
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: AppTheme.alertAmber,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelf ? AppTheme.surfaceElevated : AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelf ? AppTheme.border : AppTheme.borderSubtle,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                message.senderName + (isSelf ? ' (You)' : ''),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelf ? AppTheme.primaryNeon : AppTheme.transmitCyan,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 11, color: AppTheme.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    message.formattedTime,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            message.decryptedText ?? '[Encrypted Payload]',
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textPrimary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
