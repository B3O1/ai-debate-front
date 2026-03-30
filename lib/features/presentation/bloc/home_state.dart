import '../../domain/entities/home_item.dart';
import 'home_event.dart';

class HomeState {
  final bool isLoading;
  final List<HomeItem> topics;
  final String? selectedTopicId;
  final String? hoveredTopicId;
  final DebateStyle? selectedStyle;
  final DebateStyle? hoveredStyle;
  final String customTopicText;
  final String? errorMessage;

  const HomeState({
    required this.isLoading,
    required this.topics,
    required this.selectedTopicId,
    required this.hoveredTopicId,
    required this.selectedStyle,
    required this.hoveredStyle,
    required this.customTopicText,
    required this.errorMessage,
  });

  const HomeState.initial()
    : isLoading = false,
      topics = const [],
      selectedTopicId = null,
      hoveredTopicId = null,
      selectedStyle = null,
      hoveredStyle = null,
      customTopicText = '',
      errorMessage = null;

  bool get isCustomTopicSelected => selectedTopicId == 'custom';

  bool get isStartEnabled {
    if (selectedTopicId == null) return false;
    if (selectedStyle == null) return false;

    if (isCustomTopicSelected) {
      return customTopicText.trim().isNotEmpty;
    }

    return true;
  }

  HomeState copyWith({
    bool? isLoading,
    List<HomeItem>? topics,
    String? selectedTopicId,
    bool clearSelectedTopic = false,
    String? hoveredTopicId,
    bool clearHoveredTopic = false,
    DebateStyle? selectedStyle,
    bool clearSelectedStyle = false,
    DebateStyle? hoveredStyle,
    bool clearHoveredStyle = false,
    String? customTopicText,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      topics: topics ?? this.topics,
      selectedTopicId: clearSelectedTopic
          ? null
          : selectedTopicId ?? this.selectedTopicId,
      hoveredTopicId: clearHoveredTopic
          ? null
          : hoveredTopicId ?? this.hoveredTopicId,
      selectedStyle: clearSelectedStyle
          ? null
          : selectedStyle ?? this.selectedStyle,
      hoveredStyle: clearHoveredStyle
          ? null
          : hoveredStyle ?? this.hoveredStyle,
      customTopicText: customTopicText ?? this.customTopicText,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
