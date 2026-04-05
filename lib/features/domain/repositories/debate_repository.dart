import '../entities/chat_message.dart';
import '../entities/debate_evaluation.dart';
import '../entities/debate_session_config.dart';

abstract class DebateRepository {
  Future<ChatMessage> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  });

  Future<DebateEvaluation> evaluateDebate({
    required DebateSessionConfig config,
  });

  Future<void> resetDebate({
    required DebateSessionConfig config,
  });
}
