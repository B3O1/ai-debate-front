import 'package:flutter/material.dart';

class EvaluationHeader extends StatelessWidget {
  final VoidCallback onRestart;

  const EvaluationHeader({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 760;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '토론 분석 리포트',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'AI가 분석한 당신의 토론 퍼포먼스 결과입니다.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF667085),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onRestart,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2F6BFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                '새 토론 시작',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '토론 분석 리포트',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'AI가 분석한 당신의 토론 퍼포먼스 결과입니다.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: onRestart,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2F6BFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text(
            '새 토론 시작',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
