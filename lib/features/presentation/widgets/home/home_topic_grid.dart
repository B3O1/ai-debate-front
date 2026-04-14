import 'package:flutter/material.dart';

import '../../../domain/entities/home_item.dart';
import '../custom_topic_card.dart';
import '../topic_card.dart';

class HomeTopicGrid extends StatelessWidget {
  final List<HomeItem> topics;
  final String? selectedTopicId;
  final String? hoveredTopicId;
  final TextEditingController customTopicController;
  final ValueChanged<String> onTopicTap;
  final ValueChanged<String> onTopicHoverEnter;
  final VoidCallback onTopicHoverExit;
  final ValueChanged<String> onCustomTopicChanged;

  const HomeTopicGrid({
    super.key,
    required this.topics,
    required this.selectedTopicId,
    required this.hoveredTopicId,
    required this.customTopicController,
    required this.onTopicTap,
    required this.onTopicHoverEnter,
    required this.onTopicHoverExit,
    required this.onCustomTopicChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final spacing = width < 700 ? 14.0 : 20.0;
        final cardWidth = width < 520
            ? width
            : width < 900
            ? (width - spacing) / 2
            : 220.0;
        final cardHeight = width < 520 ? 180.0 : 220.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: topics.map<Widget>((topic) {
            if (topic.isCustomInput) {
              return CustomTopicCard(
                width: cardWidth,
                height: cardHeight,
                isSelected: selectedTopicId == topic.id,
                isHovered: hoveredTopicId == topic.id,
                controller: customTopicController,
                onTap: () => onTopicTap(topic.id),
                onHoverEnter: () => onTopicHoverEnter(topic.id),
                onHoverExit: onTopicHoverExit,
                onChanged: onCustomTopicChanged,
              );
            }

            return TopicCard(
              width: cardWidth,
              height: cardHeight,
              topic: topic,
              isSelected: selectedTopicId == topic.id,
              isHovered: hoveredTopicId == topic.id,
              onTap: () => onTopicTap(topic.id),
              onHoverEnter: () => onTopicHoverEnter(topic.id),
              onHoverExit: onTopicHoverExit,
            );
          }).toList(),
        );
      },
    );
  }
}
