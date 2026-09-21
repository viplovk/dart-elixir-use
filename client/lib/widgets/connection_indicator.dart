import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class ConnectionIndicator extends StatelessWidget {
  final ConnectionQuality quality;

  const ConnectionIndicator({Key? key, required this.quality}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (quality) {
      case ConnectionQuality.excellent:
        label = 'EXCELLENT';
        color = AppTheme.primaryNeon;
        break;
      case ConnectionQuality.good:
        label = 'GOOD';
        color = AppTheme.alertAmber;
        break;
      case ConnectionQuality.unstable:
        label = 'UNSTABLE';
        color = AppTheme.dangerRed;
        break;
      case ConnectionQuality.disconnected:
        label = 'OFFLINE';
        color = AppTheme.textMuted;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
