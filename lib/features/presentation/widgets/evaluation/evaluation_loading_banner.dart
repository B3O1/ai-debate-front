import 'package:flutter/material.dart';

class EvaluationLoadingBanner extends StatelessWidget {
  const EvaluationLoadingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: Color(0xFF2F6BFF),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '토론 데이터를 분석하는 중입니다. 점수, 강점, 보완점, 상세 코칭을 불러오고 있습니다.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3659A8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
