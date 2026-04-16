import 'package:flutter/material.dart';

import '../../../domain/entities/debate_style.dart';

class DebateStyleSection extends StatelessWidget {
  final bool compact;
  final DebateStyle? selectedStyle;
  final DebateStyle? hoveredStyle;
  final ValueChanged<DebateStyle> onStyleTapped;
  final ValueChanged<DebateStyle> onStyleHoverEnter;
  final VoidCallback onStyleHoverExit;

  const DebateStyleSection({
    super.key,
    this.compact = false,
    required this.selectedStyle,
    required this.hoveredStyle,
    required this.onStyleTapped,
    required this.onStyleHoverEnter,
    required this.onStyleHoverExit,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 520;
    final isDense = compact && !isCompact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.psychology_outlined,
              size: 20,
              color: Color(0xFF344054),
            ),
            const SizedBox(width: 8),
            Text(
              'AI 반박 스타일 선택',
              style: TextStyle(
                fontSize: isCompact
                    ? 18
                    : isDense
                    ? 18
                    : 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF243041),
              ),
            ),
          ],
        ),
        SizedBox(height: isDense ? 14 : 18),
        _SlidingSegmentedControl(
          compact: compact,
          selectedStyle: selectedStyle,
          hoveredStyle: hoveredStyle,
          onStyleTapped: onStyleTapped,
          onStyleHoverEnter: onStyleHoverEnter,
          onStyleHoverExit: onStyleHoverExit,
        ),
        SizedBox(height: isDense ? 10 : 14),
        Text(
          _description(selectedStyle),
          style: TextStyle(
            fontSize: isCompact
                ? 14
                : isDense
                ? 13
                : 15,
            color: const Color(0xFF66748E),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _description(DebateStyle? style) {
    switch (style) {
      case DebateStyle.aggressive:
        return '논리적 빈틈을 예리하게 파고듭니다.';
      case DebateStyle.logical:
        return '객관적인 근거와 데이터로 반박합니다.';
      case DebateStyle.kind:
        return '존중하는 태도로 부드럽게 반박합니다.';
      case null:
        return '원하는 반박 스타일을 선택해주세요.';
    }
  }
}

class _SlidingSegmentedControl extends StatelessWidget {
  final bool compact;
  final DebateStyle? selectedStyle;
  final DebateStyle? hoveredStyle;
  final ValueChanged<DebateStyle> onStyleTapped;
  final ValueChanged<DebateStyle> onStyleHoverEnter;
  final VoidCallback onStyleHoverExit;

  const _SlidingSegmentedControl({
    required this.compact,
    required this.selectedStyle,
    required this.hoveredStyle,
    required this.onStyleTapped,
    required this.onStyleHoverEnter,
    required this.onStyleHoverExit,
  });

  Alignment _thumbAlignment() {
    switch (selectedStyle) {
      case DebateStyle.aggressive:
        return Alignment.centerLeft;
      case DebateStyle.logical:
        return Alignment.center;
      case DebateStyle.kind:
        return Alignment.centerRight;
      case null:
        return Alignment.centerLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 520;

    if (isCompact) {
      return Column(
        children: DebateStyle.values
            .map(
              (style) => Padding(
                padding: EdgeInsets.only(
                  bottom: style == DebateStyle.kind ? 0 : 10,
                ),
                child: _SegmentedStyleLabel(
                  label: style.label,
                  isSelected: selectedStyle == style,
                  isHovered: hoveredStyle == style,
                  onTap: () => onStyleTapped(style),
                  onHoverEnter: () => onStyleHoverEnter(style),
                  onHoverExit: onStyleHoverExit,
                  compact: true,
                ),
              ),
            )
            .toList(),
      );
    }

    return Container(
      height: compact ? 52 : 58,
      padding: EdgeInsets.all(compact ? 5 : 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final thumbWidth = (constraints.maxWidth - 16) / 3;

          return Stack(
            children: [
              if (selectedStyle != null)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  alignment: _thumbAlignment(),
                  child: Container(
                    width: thumbWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF2F6BFF),
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: _SegmentedStyleLabel(
                      label: 'Aggressive',
                      isSelected: selectedStyle == DebateStyle.aggressive,
                      isHovered: hoveredStyle == DebateStyle.aggressive,
                      onTap: () => onStyleTapped(DebateStyle.aggressive),
                      onHoverEnter: () =>
                          onStyleHoverEnter(DebateStyle.aggressive),
                      onHoverExit: onStyleHoverExit,
                    ),
                  ),
                  Expanded(
                    child: _SegmentedStyleLabel(
                      label: 'Logical',
                      isSelected: selectedStyle == DebateStyle.logical,
                      isHovered: hoveredStyle == DebateStyle.logical,
                      onTap: () => onStyleTapped(DebateStyle.logical),
                      onHoverEnter: () =>
                          onStyleHoverEnter(DebateStyle.logical),
                      onHoverExit: onStyleHoverExit,
                    ),
                  ),
                  Expanded(
                    child: _SegmentedStyleLabel(
                      label: 'Kind',
                      isSelected: selectedStyle == DebateStyle.kind,
                      isHovered: hoveredStyle == DebateStyle.kind,
                      onTap: () => onStyleTapped(DebateStyle.kind),
                      onHoverEnter: () => onStyleHoverEnter(DebateStyle.kind),
                      onHoverExit: onStyleHoverExit,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SegmentedStyleLabel extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isHovered;
  final VoidCallback onTap;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;
  final bool compact;

  const _SegmentedStyleLabel({
    required this.label,
    required this.isSelected,
    required this.isHovered,
    required this.onTap,
    required this.onHoverEnter,
    required this.onHoverExit,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: compact ? 52 : null,
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 18)
              : EdgeInsets.zero,
          alignment: Alignment.center,
          decoration: compact
              ? BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFFE8EDF6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2F6BFF)
                        : Colors.transparent,
                    width: 2,
                  ),
                )
              : null,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            style: TextStyle(
              fontSize: compact ? 15 : 16,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? const Color(0xFF245DFF)
                  : isHovered
                  ? const Color(0xFF4B5E82)
                  : const Color(0xFF66758E),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
