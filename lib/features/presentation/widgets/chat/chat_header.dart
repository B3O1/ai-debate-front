import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../domain/entities/debate_style.dart';
import '../../../domain/entities/debate_session_config.dart';

class ChatHeader extends StatelessWidget {
  final DebateSessionConfig config;

  const ChatHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: Row(
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
