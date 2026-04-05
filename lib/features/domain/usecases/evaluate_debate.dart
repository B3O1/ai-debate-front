import '../entities/debate_session_config.dart';
import '../entities/debate_evaluation.dart';
import '../repositories/debate_repository.dart';

class EvaluateDebate {
  final DebateRepository repository;

  const EvaluateDebate(this.repository);

  Future<DebateEvaluation> call({
    required DebateSessionConfig config,
  }) {
    return repository.evaluateDebate(config: config);
  }
}
