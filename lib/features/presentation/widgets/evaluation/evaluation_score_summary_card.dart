import 'package:flutter/material.dart';

import '../../../domain/entities/debate_evaluation.dart';
import '../../bloc/evaluation_state.dart';
import 'evaluation_mini_score_tile.dart';
import 'evaluation_preference_bar.dart';
import 'evaluation_skeletons.dart';

class EvaluationScoreSummaryCard extends StatelessWidget {
  final EvaluationState state;

  const EvaluationScoreSummaryCard({
    super.key,
    required this.state,
  });

  DebateEvaluation? get _evaluation =>
      state is EvaluationLoaded ? (state as EvaluationLoaded).evaluation : null;

  @override
  Widget build(BuildContext context) {
    final evaluation = _evaluation;
    final hasScoreData = state is EvaluationLoaded && evaluation?.score != null;
    final hasRatioData = evaluation?.logicScore != null &&
        evaluation?.persuasionScore != null;

    return Container(
      constraints: const BoxConstraints(minHeight: 640),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
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
          const Text(
            '종합 평가',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: hasScoreData ? '${evaluation!.score}' : '--',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const TextSpan(
                    text: '점',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF98A2B3),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              state is EvaluationError
                  ? '유효한 총점 데이터를 받지 못했습니다. score, logic_score, persuasion_score를 확인해주세요.'
                  : hasScoreData
                  ? '서버에서 전달한 평가 총점입니다.'
                  : '총점 데이터를 불러오는 중입니다',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          EvaluationPreferenceBar(
            logicScore: evaluation?.logicScore,
            persuasionScore: evaluation?.persuasionScore,
            hasData: hasRatioData,
          ),
          const SizedBox(height: 24),
          EvaluationMiniScoreTile(
            title: '논리력',
            score: evaluation?.logicScore,
            accentColor: evaluation?.logicScore != null
                ? const Color(0xFF2F6BFF)
                : const Color(0xFF98A2B3),
          ),
          const SizedBox(height: 16),
          EvaluationMiniScoreTile(
            title: '설득력',
            score: evaluation?.persuasionScore,
            accentColor: evaluation?.persuasionScore != null
                ? const Color(0xFFFF6B6B)
                : const Color(0xFF98A2B3),
          ),
        ],
      ),
    );
  }
}

class EvaluationLoadingScoreCard extends StatelessWidget {
  const EvaluationLoadingScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 640),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '종합 평가',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 28),
          Center(
            child: EvaluationSkeletonBox(width: 120, height: 72, radius: 18),
          ),
          SizedBox(height: 18),
          Center(
            child: EvaluationSkeletonBox(width: 180, height: 18, radius: 999),
          ),
          SizedBox(height: 38),
          EvaluationSkeletonBox(width: double.infinity, height: 14, radius: 999),
          SizedBox(height: 10),
          EvaluationSkeletonBox(width: 180, height: 12, radius: 999),
          SizedBox(height: 28),
          EvaluationSkeletonMetricCard(),
          SizedBox(height: 16),
          EvaluationSkeletonMetricCard(),
        ],
      ),
    );
  }
}
