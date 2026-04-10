import '../../domain/entities/debate_evaluation.dart';

abstract class EvaluationState {
  const EvaluationState();
}

class EvaluationInitial extends EvaluationState {
  const EvaluationInitial();
}

class EvaluationLoading extends EvaluationState {
  const EvaluationLoading();
}

class EvaluationLoaded extends EvaluationState {
  final DebateEvaluation evaluation;

  const EvaluationLoaded(this.evaluation);
}

class EvaluationError extends EvaluationState {
  final String message;

  const EvaluationError(this.message);
}
