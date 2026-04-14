import 'package:flutter/material.dart';

class StartDebateButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final bool compact;

  const StartDebateButton({
    super.key,
    required this.enabled,
    required this.onPressed,
    this.fullWidth = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : 220,
      height: compact ? 46 : 52,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2F6BFF),
          disabledBackgroundColor: const Color(0xFFB9C7E6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: TextStyle(
            fontSize: compact ? 16 : 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: const Text('토론 시작하기'),
      ),
    );
  }
}
