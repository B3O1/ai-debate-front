import 'package:flutter/material.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Color(0xFF2F6BFF),
          child: Icon(Icons.chat_bubble_outline, color: Colors.white),
        ),
        SizedBox(width: 14),
        Text(
          'AI Debate Talk',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        Spacer(),
        Text(
          '토론 주제를 선택하세요.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF53637B),
          ),
        ),
        SizedBox(width: 28),
      ],
    );
  }
}
