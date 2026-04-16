import 'package:flutter/material.dart';

import '../../../domain/entities/home_item.dart';
import 'custom_topic_card.dart';
import 'topic_card.dart';

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
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: topics.map<Widget>((topic) {
        if (topic.isCustomInput) {
          return CustomTopicCard(
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
          topic: topic,
          isSelected: selectedTopicId == topic.id,
          isHovered: hoveredTopicId == topic.id,
          onTap: () => onTopicTap(topic.id),
          onHoverEnter: () => onTopicHoverEnter(topic.id),
          onHoverExit: onTopicHoverExit,
        );
      }).toList(),
    );
  }
}
