import 'package:flutter/material.dart';

class EvaluationPreferenceBar extends StatelessWidget {
  final int? logicScore;
  final int? persuasionScore;
  final bool hasData;

  const EvaluationPreferenceBar({
    super.key,
    this.logicScore,
    this.persuasionScore,
    required this.hasData,
  });

  @override
  Widget build(BuildContext context) {
    final safeLogic = logicScore ?? 0;
    final safePersuasion = persuasionScore ?? 0;
    final total = safeLogic + safePersuasion;
    final logicRatio = hasData && total > 0 ? safeLogic / total : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              '논리 중심',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2F6BFF),
              ),
            ),
            Spacer(),
            Text(
              '공감 중심',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF6B6B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 12,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (!hasData || logicRatio == null) {
                    return const ColoredBox(color: Color(0xFFD0D5DD));
                  }

                  final logicWidth = constraints.maxWidth * logicRatio;
                  final persuasionWidth = constraints.maxWidth - logicWidth;

                  return Stack(
                    children: [
                      const Positioned.fill(
                        child: ColoredBox(color: Color(0xFFE5EAF3)),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: logicWidth,
                          color: const Color(0xFF2F6BFF),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: persuasionWidth,
                          color: const Color(0xFFFF6B6B),
                        ),
                      ),
                      if (logicWidth > 0 && persuasionWidth > 0)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: logicWidth - 1),
                            width: 2,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        if (!hasData) ...[
          const SizedBox(height: 10),
          const Text(
            '논리 중심/공감 중심 비율을 표시하려면 유효한 logic_score와 persuasion_score가 모두 필요합니다.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF98A2B3),
            ),
          ),
        ],
      ],
    );
  }
}
