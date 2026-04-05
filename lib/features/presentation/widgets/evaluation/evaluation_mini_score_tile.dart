import 'package:flutter/material.dart';

class EvaluationMiniScoreTile extends StatelessWidget {
  final String title;
  final int? score;
  final Color accentColor;

  const EvaluationMiniScoreTile({
    super.key,
    required this.title,
    required this.score,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidScore = score != null && score! > 0;
    final displayText = hasValidScore ? '$score' : '데이터 필요';
    final progress = hasValidScore ? (score!.clamp(0, 100) / 100) : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7ECF5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  title == '논리력'
                      ? Icons.psychology_alt_outlined
                      : Icons.favorite_border,
                  size: 16,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF344054),
                ),
              ),
              const Spacer(),
              Text(
                displayText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress ?? 0,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5EAF3),
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}
