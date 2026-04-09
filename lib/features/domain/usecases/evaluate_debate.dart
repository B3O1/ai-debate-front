import '../entities/debate_evaluation.dart';
import '../repositories/debate_repository.dart';

class EvaluateDebate {
  final DebateRepository repository;

  const EvaluateDebate(this.repository);

  Future<DebateEvaluation> call() {
    return repository.evaluateDebate();
  }
}
