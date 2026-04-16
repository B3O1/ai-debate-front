import 'package:flutter/material.dart';

class AiTypingBubble extends StatefulWidget {
  const AiTypingBubble({super.key});

  @override
  State<AiTypingBubble> createState() => _AiTypingBubbleState();
}

class _AiTypingBubbleState extends State<AiTypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _SpeakerAvatar(mobile: isMobile),
            SizedBox(width: isMobile ? 8 : 12),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F9FE),
                  borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
                  border: Border.all(color: const Color(0xFFDCE5F2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TypingDot(controller: _controller, delay: 0),
                    const SizedBox(width: 4),
                    _TypingDot(controller: _controller, delay: 0.16),
                    const SizedBox(width: 4),
                    _TypingDot(controller: _controller, delay: 0.32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _TypingDot({required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final progress = (controller.value - delay).clamp(0.0, 1.0);
        final wave = Curves.easeInOut.transform(
          (1 - ((progress * 2 - 1).abs())).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, -6 * wave),
          child: Opacity(opacity: 0.35 + (0.65 * wave), child: child),
        );
      },
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

class _SpeakerAvatar extends StatelessWidget {
  final bool mobile;

  const _SpeakerAvatar({this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobile ? 32 : 38,
      height: mobile ? 32 : 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6E3FF)),
      ),
      child: Icon(
        Icons.smart_toy_outlined,
        size: mobile ? 18 : 20,
        color: const Color(0xFF2F6BFF),
      ),
    );
  }
}
