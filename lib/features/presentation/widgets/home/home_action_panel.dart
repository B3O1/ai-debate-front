import 'package:flutter/material.dart';

import '../../../domain/entities/debate_style.dart';
import 'debate_style_section.dart';
import 'start_debate_button.dart';

class HomeActionPanel extends StatelessWidget {
  final DebateStyle? selectedStyle;
  final DebateStyle? hoveredStyle;
  final ValueChanged<DebateStyle> onStyleTapped;
  final ValueChanged<DebateStyle> onStyleHoverEnter;
  final VoidCallback onStyleHoverExit;
  final bool isStartEnabled;
  final VoidCallback onStartPressed;

  const HomeActionPanel({
    super.key,
    required this.selectedStyle,
    required this.hoveredStyle,
    required this.onStyleTapped,
    required this.onStyleHoverEnter,
    required this.onStyleHoverExit,
    required this.isStartEnabled,
    required this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4EBF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: DebateStyleSection(
              selectedStyle: selectedStyle,
              hoveredStyle: hoveredStyle,
              onStyleTapped: onStyleTapped,
              onStyleHoverEnter: onStyleHoverEnter,
              onStyleHoverExit: onStyleHoverExit,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: StartDebateButton(
                enabled: isStartEnabled,
                onPressed: onStartPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
