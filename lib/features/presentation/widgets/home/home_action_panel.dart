import 'package:flutter/material.dart';

import '../../../domain/entities/debate_style.dart';
import 'debate_style_section.dart';
import 'start_debate_button.dart';

class HomeActionPanel extends StatelessWidget {
  final bool compact;
  final DebateStyle? selectedStyle;
  final DebateStyle? hoveredStyle;
  final ValueChanged<DebateStyle> onStyleTapped;
  final ValueChanged<DebateStyle> onStyleHoverEnter;
  final VoidCallback onStyleHoverExit;
  final bool isStartEnabled;
  final VoidCallback onStartPressed;

  const HomeActionPanel({
    super.key,
    this.compact = false,
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
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        compact
            ? 18
            : isMobile
            ? 20
            : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE4EBF5)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DebateStyleSection(
                  compact: compact,
                  selectedStyle: selectedStyle,
                  hoveredStyle: hoveredStyle,
                  onStyleTapped: onStyleTapped,
                  onStyleHoverEnter: onStyleHoverEnter,
                  onStyleHoverExit: onStyleHoverExit,
                ),
                const SizedBox(height: 20),
                StartDebateButton(
                  enabled: isStartEnabled,
                  onPressed: onStartPressed,
                  compact: compact,
                  fullWidth: true,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: DebateStyleSection(
                    compact: compact,
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
                      compact: compact,
                      onPressed: onStartPressed,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
