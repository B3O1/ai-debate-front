import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/debate_session_config.dart';
import '../../bloc/evaluation/evaluation_bloc.dart';
import '../../bloc/evaluation/evaluation_event.dart';
import '../../bloc/evaluation/evaluation_state.dart';

class EvaluationCoachingCard extends StatelessWidget {
  final EvaluationState state;
  final DebateSessionConfig config;

  const EvaluationCoachingCard({
    super.key,
    required this.state,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    String body;

    if (state is EvaluationLoading || state is EvaluationInitial) {
      body = '정확한 종합 코칭 데이터를 불러오는 중입니다.';
    } else if (state is EvaluationLoaded) {
      final summary = (state as EvaluationLoaded).evaluation.summary.trim();
      body = summary.isNotEmpty
          ? summary
          : '상세 코칭 데이터를 표시할 수 없습니다. feedback 응답이 필요합니다.';
    } else if (state is EvaluationError) {
      body = (state as EvaluationError).message;
    } else {
      body = '정확한 종합 코칭 데이터를 확인할 수 없습니다.';
    }

    return Container(
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
          const Row(
            children: [
              Icon(Icons.forum_outlined, size: 22, color: Color(0xFF667085)),
              SizedBox(width: 10),
              Text(
                'AI 상세 코칭',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              body,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF475467),
                height: 1.9,
              ),
            ),
          ),
          if (state is EvaluationError) ...[
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                context.read<EvaluationBloc>().add(EvaluationRetried(config));
              },
              child: const Text('다시 시도'),
            ),
          ],
        ],
      ),
    );
  }
}
