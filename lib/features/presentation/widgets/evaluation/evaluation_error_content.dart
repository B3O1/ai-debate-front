import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/debate_session_config.dart';
import '../../bloc/evaluation/evaluation_bloc.dart';
import '../../bloc/evaluation/evaluation_event.dart';
import '../../bloc/evaluation/evaluation_state.dart';
import 'evaluation_coaching_card.dart';
import 'evaluation_topic_summary_card.dart';

class EvaluationErrorContent extends StatelessWidget {
  final DebateSessionConfig config;
  final EvaluationError state;

  const EvaluationErrorContent({
    super.key,
    required this.config,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 960;

    final summaryCard = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: Color(0xFF2F6BFF)),
              SizedBox(width: 10),
              Text(
                '평가 데이터를 정리하는 중',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            state.message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475467),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () {
              context.read<EvaluationBloc>().add(EvaluationRetried(config));
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          EvaluationTopicSummaryCard(config: config),
          const SizedBox(height: 16),
          summaryCard,
          const SizedBox(height: 16),
          EvaluationCoachingCard(state: state, config: config),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 320, child: EvaluationTopicSummaryCard(config: config)),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: [
              summaryCard,
              const SizedBox(height: 20),
              EvaluationCoachingCard(state: state, config: config),
            ],
          ),
        ),
      ],
    );
  }
}
