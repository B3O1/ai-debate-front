import 'package:flutter/material.dart';

class AiTypingBubble extends StatelessWidget {
  const AiTypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TypingDot(delay: 0),
            const SizedBox(width: 4),
            const _TypingDot(delay: 120),
            const SizedBox(width: 4),
            const _TypingDot(delay: 240),
            const SizedBox(width: 12),
            Text(
              'AI가 입력 중입니다...',
              style: TextStyle(
                color: const Color(0xFF7B879D).withValues(alpha: 0.95),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      onEnd: () {},
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF9DB2D3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
