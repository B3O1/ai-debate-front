import '../../domain/entities/debate_session_config.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatStarted extends ChatEvent {
  final DebateSessionConfig config;

  const ChatStarted(this.config);
}

class ChatInputChanged extends ChatEvent {
  final String value;

  const ChatInputChanged(this.value);
}

class ChatSubmitted extends ChatEvent {
  final String message;

  const ChatSubmitted(this.message);
}

class DebateEvaluationRequested extends ChatEvent {
  const DebateEvaluationRequested();
}

class DebateEvaluationCleared extends ChatEvent {
  const DebateEvaluationCleared();
}

class DebateResetRequested extends ChatEvent {
  const DebateResetRequested();
}

class ChatErrorCleared extends ChatEvent {
  const ChatErrorCleared();
}
