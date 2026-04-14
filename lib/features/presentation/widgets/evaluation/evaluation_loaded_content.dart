import 'package:flutter/material.dart';

import '../../../domain/entities/debate_session_config.dart';
import '../../bloc/evaluation_state.dart';
import 'evaluation_bullet_card.dart';
import 'evaluation_coaching_card.dart';
import 'evaluation_score_summary_card.dart';
import 'evaluation_topic_summary_card.dart';

class EvaluationLoadedContent extends StatelessWidget {
  final DebateSessionConfig config;
  final EvaluationState state;

  const EvaluationLoadedContent({
    super.key,
    required this.config,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 960;

    if (isMobile) {
      return Column(
        children: [
          EvaluationScoreSummaryCard(state: state),
          const SizedBox(height: 16),
          EvaluationTopicSummaryCard(config: config),
          const SizedBox(height: 16),
          EvaluationBulletCard(
            state: state,
            title: '주요 강점',
            accentColor: const Color(0xFF2F6BFF),
          ),
          const SizedBox(height: 16),
          EvaluationBulletCard(
            state: state,
            title: '보완점',
            accentColor: const Color(0xFFFF6B6B),
          ),
          const SizedBox(height: 16),
          EvaluationCoachingCard(state: state, config: config),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 320, child: EvaluationScoreSummaryCard(state: state)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              EvaluationTopicSummaryCard(config: config),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EvaluationBulletCard(
                      state: state,
                      title: '주요 강점',
                      accentColor: const Color(0xFF2F6BFF),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: EvaluationBulletCard(
                      state: state,
                      title: '보완점',
                      accentColor: const Color(0xFFFF6B6B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              EvaluationCoachingCard(state: state, config: config),
            ],
          ),
        ),
      ],
    );
  }
}
