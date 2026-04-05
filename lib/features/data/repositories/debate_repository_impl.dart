import '../../domain/entities/chat_message.dart';
import '../../domain/entities/debate_evaluation.dart';
import '../../domain/entities/debate_session_config.dart';
import '../../domain/repositories/debate_repository.dart';
import '../datasources/debate_remote_data_source.dart';

class DebateRepositoryImpl implements DebateRepository {
  final DebateRemoteDataSource remoteDataSource;

  const DebateRepositoryImpl(this.remoteDataSource);

  @override
  Future<ChatMessage> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  }) async {
    final response = await remoteDataSource.sendChatMessage(
      config: config,
      message: message,
    );

    return response.toEntity();
  }

  @override
  Future<DebateEvaluation> evaluateDebate({
    required DebateSessionConfig config,
  }) async {
    final response = await remoteDataSource.evaluateDebate(config: config);
    return response.toEntity();
  }

  @override
  Future<void> resetDebate({
    required DebateSessionConfig config,
  }) {
    return remoteDataSource.resetDebate(config: config);
  }
}
