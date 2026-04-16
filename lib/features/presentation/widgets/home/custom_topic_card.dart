import 'package:flutter/material.dart';

class CustomTopicCard extends StatelessWidget {
  final bool isSelected;
  final bool isHovered;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;
  final ValueChanged<String> onChanged;

  const CustomTopicCard({
    super.key,
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
          width: 220,
          height: 220,
          padding: const EdgeInsets.all(20),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B6880),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4D5B73),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFF2F6BFF),
                        size: 24,
                      ),
                    ),
                  ],
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 38, color: Color(0xFF6A7892)),
                    SizedBox(height: 18),
                    Text(
                      '원하는 주제가 없으신가요?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF66748E),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
