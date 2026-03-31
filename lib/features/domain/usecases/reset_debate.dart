import '../repositories/debate_repository.dart';

class ResetDebate {
  final DebateRepository repository;

  const ResetDebate(this.repository);

  Future<void> call() {
    return repository.resetDebate();
  }
}
