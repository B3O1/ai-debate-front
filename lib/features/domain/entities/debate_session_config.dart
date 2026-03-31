import 'debate_style.dart';

class DebateSessionConfig {
  final String topic;
  final String? topicId;
  final String? customTopic;
  final DebateStyle style;

  const DebateSessionConfig({
    required this.topic,
    required this.style,
    this.topicId,
    this.customTopic,
  });

  bool get isCustomTopic => customTopic != null && customTopic!.trim().isNotEmpty;
}
