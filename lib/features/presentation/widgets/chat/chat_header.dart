import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../domain/entities/debate_style.dart';
import '../../../domain/entities/debate_session_config.dart';

class ChatHeader extends StatelessWidget {
  final DebateSessionConfig config;
  final bool compact;

  const ChatHeader({
    super.key,
    required this.config,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 760;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 16 : 20,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: isMobile && compact
          ? Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF64748B),
                  ),
                  tooltip: '뒤로가기',
                ),
                const SizedBox(width: 4),
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF2F6BFF),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        config.topic,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        config.style.modeLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF4D67),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRouter.evaluation, arguments: config);
                  },
                  icon: const Icon(
                    Icons.assessment_rounded,
                    color: Color(0xFF1F2937),
                  ),
                  tooltip: '토론 종료 및 종합 분석',
                ),
              ],
            )
          : isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF64748B),
                      ),
                      tooltip: '뒤로가기',
                    ),
                    const SizedBox(width: 2),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFF2F6BFF),
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'AI 토론',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    config.style.modeLabel,
                    style: const TextStyle(
                      color: Color(0xFFFF4D67),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  config.topic,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1F2937),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushNamed(AppRouter.evaluation, arguments: config);
                    },
                    child: const Text(
                      '토론 종료 및 종합 분석',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF64748B),
                  ),
                  tooltip: '뒤로가기',
                ),
                const SizedBox(width: 4),
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF2F6BFF),
                  child: Icon(Icons.chat_bubble_outline, color: Colors.white),
                ),
                const SizedBox(width: 14),
                const Text(
                  'AI 토론',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE8EC),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        config.style.modeLabel,
                        style: const TextStyle(
                          color: Color(0xFFFF4D67),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      config.topic,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2937),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pushNamed(AppRouter.evaluation, arguments: config);
                  },
                  child: const Text(
                    '토론 종료 및 종합 분석',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
    );
  }
}
