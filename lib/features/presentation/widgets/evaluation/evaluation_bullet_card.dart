import 'package:flutter/material.dart';

import '../../bloc/evaluation/evaluation_state.dart';

class EvaluationBulletCard extends StatelessWidget {
  final EvaluationState state;
  final String title;
  final Color accentColor;

  const EvaluationBulletCard({
    super.key,
    required this.state,
    required this.title,
    required this.accentColor,
  });

  List<String> get _items {
    if (state is EvaluationLoaded) {
      final evaluation = (state as EvaluationLoaded).evaluation;
      return title == '주요 강점' ? evaluation.strengths : evaluation.weaknesses;
    }

    return const [];
  }

  String get _missingMessage {
    if (state is EvaluationError) {
      return '$title 데이터를 표시할 수 없습니다. 응답에 구조화된 ${title == '주요 강점' ? 'strengths' : 'weaknesses'} 데이터가 필요합니다.';
    }

    if (state is EvaluationLoading || state is EvaluationInitial) {
      return '$title 데이터를 불러오는 중입니다.';
    }

    return '$title 데이터가 응답에 포함되지 않았습니다.';
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;

    return Container(
      constraints: const BoxConstraints(minHeight: 255),
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
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  title == '주요 강점'
                      ? Icons.thumb_up_alt_outlined
                      : Icons.error_outline_rounded,
                  size: 20,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (items.isEmpty)
            Text(
              _missingMessage,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085),
                height: 1.7,
              ),
            )
          else
            for (var i = 0; i < items.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      items[i],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF344054),
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
              if (i != items.length - 1) const SizedBox(height: 16),
            ],
        ],
      ),
    );
  }
}
