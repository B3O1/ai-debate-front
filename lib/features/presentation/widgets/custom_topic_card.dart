import 'package:flutter/material.dart';

class CustomTopicCard extends StatelessWidget {
  final double width;
  final double height;
  final bool isSelected;
  final bool isHovered;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;
  final ValueChanged<String> onChanged;

  const CustomTopicCard({
    super.key,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.isHovered,
    required this.controller,
    required this.onTap,
    required this.onHoverEnter,
    required this.onHoverExit,
    required this.onChanged,
  });

  Color _borderColor() {
    if (isSelected) return const Color(0xFF2F6BFF);
    if (isHovered) return const Color(0xFF8EB2FF);
    return const Color(0xFFD9E2F2);
  }

  BorderStyle _borderStyle() {
    return isSelected ? BorderStyle.solid : BorderStyle.solid;
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = width < 200;
    final isNarrow = width < 150;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: width,
          height: height,
          padding: EdgeInsets.all(
            isNarrow
                ? 12
                : isCompact
                ? 14
                : 20,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: _borderColor(),
              width: isSelected ? 2 : 1.4,
              style: _borderStyle(),
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0x142F6BFF)
                    : isHovered
                    ? const Color(0x0F2F6BFF)
                    : const Color(0x0A000000),
                blurRadius: isSelected ? 20 : 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: isSelected
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '직접 입력',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B6880),
                        ),
                      ),
                    ),
                    SizedBox(height: isNarrow ? 10 : 14),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        controller: controller,
                        onChanged: onChanged,
                        decoration: const InputDecoration(
                          hintText: '토론하고 싶은 주제를 자유롭게 적어주세요.',
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: TextStyle(
                          fontSize: isNarrow
                              ? 13
                              : isCompact
                              ? 14
                              : 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4D5B73),
                          height: isNarrow ? 1.35 : 1.5,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF2F6BFF),
                        size: isNarrow ? 20 : 24,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: isNarrow ? 28 : 38,
                      color: const Color(0xFF6A7892),
                    ),
                    SizedBox(height: isNarrow ? 10 : 16),
                    Text(
                      '원하는 주제가 없으신가요?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isNarrow
                            ? 13
                            : isCompact
                            ? 15
                            : 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF66748E),
                        height: isNarrow ? 1.35 : 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
