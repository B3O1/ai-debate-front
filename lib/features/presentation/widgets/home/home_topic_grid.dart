import 'package:flutter/material.dart';

import '../../../domain/entities/home_item.dart';
import '../custom_topic_card.dart';
import '../topic_card.dart';

class HomeTopicGrid extends StatelessWidget {
  final List<HomeItem> topics;
  final double? availableHeight;
  final bool compactLandscape;
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
    this.availableHeight,
    this.compactLandscape = false,
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
        final isNarrowMobile = width < 520;
        final spacing = compactLandscape
            ? 14.0
            : isNarrowMobile
            ? 12.0
            : width < 900
            ? 16.0
            : 20.0;
        final minCardWidth = compactLandscape
            ? 150.0
            : isNarrowMobile
            ? 140.0
            : 220.0;
        final maxCardWidth = compactLandscape
            ? 190.0
            : isNarrowMobile
            ? 180.0
            : 260.0;
        final maxColumns = isNarrowMobile ? 2 : 4;

        final crossAxisCount = width <= minCardWidth
            ? 1
            : ((width + spacing) / (minCardWidth + spacing)).floor().clamp(
                1,
                maxColumns,
              );
        final rawCardWidth =
            (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;
        final cardWidth = rawCardWidth.clamp(minCardWidth, maxCardWidth);
        final rowCount = (topics.length / crossAxisCount).ceil();
        final autoHeight = availableHeight == null
            ? null
            : (availableHeight! - (spacing * (rowCount - 1))) / rowCount;
        final cardHeight = compactLandscape
            ? (autoHeight ?? 150.0).clamp(138.0, 168.0)
            : isNarrowMobile
            ? 188.0
            : cardWidth < 220
            ? 190.0
            : 220.0;
        final gridWidth =
            (cardWidth * crossAxisCount) + (spacing * (crossAxisCount - 1));

        return Center(
          child: SizedBox(
            width: gridWidth > width ? width : gridWidth,
            child: Wrap(
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
            ),
          ),
        );
      },
    );
  }
}
