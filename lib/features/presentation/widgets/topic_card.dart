import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/home_item.dart';

class TopicCard extends StatelessWidget {
  final double width;
  final double height;
  final HomeItem topic;
  final bool isSelected;
  final bool isHovered;
  final VoidCallback onTap;
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  const TopicCard({
    super.key,
    required this.width,
    required this.height,
    required this.topic,
    required this.isSelected,
    required this.isHovered,
    required this.onTap,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  IconData _resolveIcon(String iconKey) {
    switch (iconKey) {
      case 'favorite':
        return Icons.favorite_border;
      case 'trending_up':
        return Icons.trending_up;
      case 'phone_android':
        return Icons.phone_android;
      case 'gavel':
        return Icons.gavel;
      case 'school':
        return Icons.school;
      case 'eco':
        return Icons.eco;
      case 'account_balance':
        return Icons.account_balance;
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'psychology':
        return Icons.psychology;
      default:
        return Icons.topic_outlined;
    }
  }

  Color _borderColor() {
    if (isSelected) return const Color(0xFF2F6BFF);
    if (isHovered) return const Color(0xFF8EB2FF);
    return const Color(0xFFE4EAF4);
  }

  double _borderWidth() {
    if (isSelected) return 2;
    if (isHovered) return 1.5;
    return 1.2;
  }

  @override
  Widget build(BuildContext context) {
    final isWebCard = kIsWeb && width < 220;
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
            border: Border.all(color: _borderColor(), width: _borderWidth()),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryChip(category: topic.category, compact: isNarrow),
              SizedBox(
                height: isNarrow
                    ? 10
                    : isCompact
                    ? 12
                    : 18,
              ),
              Expanded(
                child: Text(
                  topic.title,
                  maxLines: isNarrow
                      ? 4
                      : isWebCard
                      ? 4
                      : 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isNarrow
                        ? 13
                        : isWebCard
                        ? 15
                        : isCompact
                        ? 14
                        : 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1D2433),
                    height: isNarrow ? 1.35 : 1.5,
                  ),
                ),
              ),
              SizedBox(height: isNarrow ? 8 : 12),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  isSelected ? Icons.check_circle : _resolveIcon(topic.iconKey),
                  color: isSelected
                      ? const Color(0xFF2F6BFF)
                      : const Color(0xFFC0CADB),
                  size: isNarrow ? 20 : 26,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  final bool compact;

  const _CategoryChip({required this.category, this.compact = false});

  Color _backgroundColor() {
    switch (category) {
      case '연애':
        return const Color(0xFFFFEEF1);
      case '경제':
        return const Color(0xFFEAF1FF);
      case '사회':
        return const Color(0xFFFFF4D8);
      case '법률':
        return const Color(0xFFFFE8E6);
      case '교육':
        return const Color(0xFFE7FAEE);
      case '환경':
        return const Color(0xFFE6FBF5);
      case '정치':
        return const Color(0xFFF0E9FF);
      case '과학':
        return const Color(0xFFE9EEFF);
      case 'AI':
        return const Color(0xFFF0F3F8);
      default:
        return const Color(0xFFF2F4F8);
    }
  }

  Color _textColor() {
    switch (category) {
      case '연애':
        return const Color(0xFFE34D67);
      case '경제':
        return const Color(0xFF3674F6);
      case '사회':
        return const Color(0xFFE29D12);
      case '법률':
        return const Color(0xFFEF4C4C);
      case '교육':
        return const Color(0xFF21A56B);
      case '환경':
        return const Color(0xFF0FA27A);
      case '정치':
        return const Color(0xFF9B52F2);
      case '과학':
        return const Color(0xFF5D77FF);
      case 'AI':
        return const Color(0xFF556273);
      default:
        return const Color(0xFF5B6880);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: compact ? 12 : 14,
          fontWeight: FontWeight.w700,
          color: _textColor(),
        ),
      ),
    );
  }
}
