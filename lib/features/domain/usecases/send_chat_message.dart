import '../entities/chat_message.dart';
import '../entities/debate_session_config.dart';
import '../repositories/debate_repository.dart';

class SendChatMessage {
  final DebateRepository repository;

  const SendChatMessage(this.repository);

  Future<ChatMessage> call({
    required DebateSessionConfig config,
    required String message,
  }) {
    return repository.sendChatMessage(
      config: config,
      message: message,
    );
  }
}
