import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveformVisualizer extends StatelessWidget {
  final List<double> amplitudes;
  final bool isTransmitting;

  const WaveformVisualizer({
    Key? key,
    required this.amplitudes,
    required this.isTransmitting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: amplitudes.map((amp) {
          final barHeight = (amp * 36).clamp(3.0, 36.0);
          final barColor = isTransmitting
              ? AppTheme.transmitCyan
              : AppTheme.textMuted.withOpacity(0.3);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 3,
            height: barHeight,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(1.5),
              boxShadow: isTransmitting
                  ? [
                      BoxShadow(
                        color: AppTheme.transmitCyan.withOpacity(0.5),
                        blurRadius: 4,
                      )
                    ]
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }
}
