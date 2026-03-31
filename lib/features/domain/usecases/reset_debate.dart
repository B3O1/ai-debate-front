import '../entities/debate_session_config.dart';
import '../repositories/debate_repository.dart';

class ResetDebate {
  final DebateRepository repository;

  const ResetDebate(this.repository);

  Future<void> call({
    required DebateSessionConfig config,
  }) {
    return repository.resetDebate(config: config);
  }
}
