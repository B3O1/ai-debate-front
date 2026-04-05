import 'package:flutter/material.dart';

class EvaluationSkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const EvaluationSkeletonBox({
    super.key,
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EEF8),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class EvaluationSkeletonTextLine extends StatelessWidget {
  const EvaluationSkeletonTextLine({super.key});

  @override
  Widget build(BuildContext context) {
    return const EvaluationSkeletonBox(
      width: double.infinity,
      height: 18,
      radius: 999,
    );
  }
}

class EvaluationSkeletonMetricCard extends StatelessWidget {
  const EvaluationSkeletonMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7ECF5)),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              EvaluationSkeletonBox(width: 28, height: 28, radius: 999),
              SizedBox(width: 10),
              EvaluationSkeletonBox(width: 56, height: 16, radius: 999),
              Spacer(),
              EvaluationSkeletonBox(width: 28, height: 18, radius: 999),
            ],
          ),
          SizedBox(height: 14),
          EvaluationSkeletonBox(width: double.infinity, height: 8, radius: 999),
        ],
      ),
    );
  }
}

class EvaluationLoadingCard extends StatelessWidget {
  final String title;
  final int lines;
  final IconData icon;
  final Color iconColor;
  final bool fullWidth;

  const EvaluationLoadingCard({
    super.key,
    required this.title,
    required this.lines,
    required this.icon,
    required this.iconColor,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: fullWidth ? null : 255,
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
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: iconColor),
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
          for (var i = 0; i < lines; i++) ...[
            const EvaluationSkeletonTextLine(),
            if (i != lines - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
