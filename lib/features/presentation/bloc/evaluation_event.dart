import '../../domain/entities/debate_session_config.dart';

abstract class EvaluationEvent {
  const EvaluationEvent();
}

class EvaluationStarted extends EvaluationEvent {
  final DebateSessionConfig config;

  const EvaluationStarted(this.config);
}

class EvaluationRetried extends EvaluationEvent {
  final DebateSessionConfig config;

  const EvaluationRetried(this.config);
}
