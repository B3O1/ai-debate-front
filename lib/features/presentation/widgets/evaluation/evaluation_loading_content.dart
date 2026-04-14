import 'package:flutter/material.dart';

import '../../../domain/entities/debate_session_config.dart';
import 'evaluation_loading_banner.dart';
import 'evaluation_score_summary_card.dart';
import 'evaluation_skeletons.dart';
import 'evaluation_topic_summary_card.dart';

class EvaluationLoadingContent extends StatelessWidget {
  final DebateSessionConfig config;

  const EvaluationLoadingContent({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 960;

    if (isMobile) {
      return Column(
        children: [
          const EvaluationLoadingBanner(),
          const SizedBox(height: 16),
          const EvaluationLoadingScoreCard(),
          const SizedBox(height: 16),
          EvaluationTopicSummaryCard(config: config),
          const SizedBox(height: 16),
          const EvaluationLoadingCard(
            title: '주요 강점 분석 중',
            lines: 3,
            icon: Icons.thumb_up_alt_outlined,
            iconColor: Color(0xFF2F6BFF),
            fullWidth: true,
          ),
          const SizedBox(height: 16),
          const EvaluationLoadingCard(
            title: '보완점 분석 중',
            lines: 3,
            icon: Icons.error_outline_rounded,
            iconColor: Color(0xFFFF6B6B),
            fullWidth: true,
          ),
          const SizedBox(height: 16),
          const EvaluationLoadingCard(
            title: 'AI 상세 코칭 생성 중',
            lines: 4,
            icon: Icons.forum_outlined,
            iconColor: Color(0xFF667085),
            fullWidth: true,
          ),
        ],
      );
    }

    return Column(
      children: [
        const EvaluationLoadingBanner(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 320, child: EvaluationLoadingScoreCard()),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  EvaluationTopicSummaryCard(config: config),
                  const SizedBox(height: 20),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: EvaluationLoadingCard(
                          title: '주요 강점 분석 중',
                          lines: 3,
                          icon: Icons.thumb_up_alt_outlined,
                          iconColor: Color(0xFF2F6BFF),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: EvaluationLoadingCard(
                          title: '보완점 분석 중',
                          lines: 3,
                          icon: Icons.error_outline_rounded,
                          iconColor: Color(0xFFFF6B6B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const EvaluationLoadingCard(
                    title: 'AI 상세 코칭 생성 중',
                    lines: 4,
                    icon: Icons.forum_outlined,
                    iconColor: Color(0xFF667085),
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
