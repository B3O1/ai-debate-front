import '../../domain/entities/chat_message.dart';
import '../../domain/entities/debate_evaluation.dart';
import '../../domain/entities/debate_session_config.dart';

class ChatState {
  final DebateSessionConfig? config;
  final List<ChatMessage> messages;
  final String input;
  final bool isSending;
  final bool isEvaluating;
  final bool isResetting;
  final String? errorMessage;
  final DebateEvaluation? evaluation;

  const ChatState({
    required this.config,
    required this.messages,
    required this.input,
    required this.isSending,
    required this.isEvaluating,
    required this.isResetting,
    required this.errorMessage,
    required this.evaluation,
  });

  const ChatState.initial()
      : config = null,
        messages = const [],
        input = '',
        isSending = false,
        isEvaluating = false,
        isResetting = false,
        errorMessage = null,
        evaluation = null;

  bool get canSend => input.trim().isNotEmpty && !isSending && !isResetting;

  ChatState copyWith({
    DebateSessionConfig? config,
    List<ChatMessage>? messages,
    String? input,
    bool? isSending,
    bool? isEvaluating,
    bool? isResetting,
    String? errorMessage,
    bool clearErrorMessage = false,
    DebateEvaluation? evaluation,
    bool clearEvaluation = false,
  }) {
    return ChatState(
      config: config ?? this.config,
      messages: messages ?? this.messages,
      input: input ?? this.input,
      isSending: isSending ?? this.isSending,
      isEvaluating: isEvaluating ?? this.isEvaluating,
      isResetting: isResetting ?? this.isResetting,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      evaluation: clearEvaluation ? null : evaluation ?? this.evaluation,
    );
  }
}
