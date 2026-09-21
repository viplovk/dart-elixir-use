import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PushToTalkButton extends StatefulWidget {
  final bool isTransmitting;
  final bool isMuted;
  final VoidCallback onPressStart;
  final VoidCallback onPressEnd;

  const PushToTalkButton({
    Key? key,
    required this.isTransmitting,
    required this.isMuted,
    required this.onPressStart,
    required this.onPressEnd,
  }) : super(key: key);

  @override
  State<PushToTalkButton> createState() => _PushToTalkButtonState();
}

class _PushToTalkButtonState extends State<PushToTalkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(PushToTalkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTransmitting && !oldWidget.isTransmitting) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isTransmitting && oldWidget.isTransmitting) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isMuted
        ? AppTheme.dangerRed
        : (widget.isTransmitting ? AppTheme.transmitCyan : AppTheme.primaryNeon);

    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (event) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          if (event is RawKeyDownEvent && !widget.isTransmitting) {
            widget.onPressStart();
          } else if (event is RawKeyUpEvent && widget.isTransmitting) {
            widget.onPressEnd();
          }
        }
      },
      child: GestureDetector(
        onTapDown: (_) => widget.onPressStart(),
        onTapUp: (_) => widget.onPressEnd(),
        onTapCancel: () => widget.onPressEnd(),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final glowRadius = widget.isTransmitting
                ? 12.0 + (_pulseController.value * 16.0)
                : 0.0;

            return Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceElevated,
                border: Border.all(
                  color: activeColor,
                  width: widget.isTransmitting ? 3.5 : 2.0,
                ),
                boxShadow: widget.isTransmitting
                    ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.45),
                          blurRadius: glowRadius,
                          spreadRadius: 2.0,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.isMuted
                          ? Icons.mic_off_rounded
                          : (widget.isTransmitting
                              ? Icons.radio_button_checked_rounded
                              : Icons.mic_none_rounded),
                      size: 46,
                      color: activeColor,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isMuted
                          ? 'MUTED'
                          : (widget.isTransmitting
                              ? '● TRANSMITTING'
                              : 'HOLD TO TALK'),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: activeColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '[SPACEBAR]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 10,
                        color: AppTheme.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
