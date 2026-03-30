abstract class HomeEvent {
  const HomeEvent();
}

class HomeStarted extends HomeEvent {
  const HomeStarted();
}

class TopicSelected extends HomeEvent {
  final String topicId;

  const TopicSelected(this.topicId);
}

class TopicHovered extends HomeEvent {
  final String topicId;

  const TopicHovered(this.topicId);
}

class TopicHoverExited extends HomeEvent {
  const TopicHoverExited();
}

enum DebateStyle { aggressive, logical, kind }

class DebateStyleToggled extends HomeEvent {
  final DebateStyle style;

  const DebateStyleToggled(this.style);
}

class DebateStyleHovered extends HomeEvent {
  final DebateStyle style;

  const DebateStyleHovered(this.style);
}

class DebateStyleHoverExited extends HomeEvent {
  const DebateStyleHoverExited();
}

class CustomTopicChanged extends HomeEvent {
  final String value;

  const CustomTopicChanged(this.value);
}

class StartButtonPressed extends HomeEvent {
  const StartButtonPressed();
}
