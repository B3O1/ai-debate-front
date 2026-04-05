import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/debate_session_config.dart';
import '../../domain/usecases/evaluate_debate.dart';
import '../../domain/usecases/reset_debate.dart';
import '../../domain/usecases/send_chat_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendChatMessage sendChatMessage;
  final EvaluateDebate evaluateDebate;
  final ResetDebate resetDebate;

  ChatBloc({
    required this.sendChatMessage,
    required this.evaluateDebate,
    required this.resetDebate,
  }) : super(const ChatState.initial()) {
    on<ChatStarted>(_onChatStarted);
    on<ChatInputChanged>(_onChatInputChanged);
    on<ChatSubmitted>(_onChatSubmitted);
    on<DebateEvaluationRequested>(_onDebateEvaluationRequested);
    on<DebateEvaluationCleared>(_onDebateEvaluationCleared);
    on<DebateResetRequested>(_onDebateResetRequested);
    on<ChatErrorCleared>(_onChatErrorCleared);
  }

  Future<void> _onChatStarted(
    ChatStarted event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        config: event.config,
        clearErrorMessage: true,
        clearEvaluation: true,
      ),
    );

    final welcomeMessage = _buildWelcomeMessage(event.config);

    try {
      await resetDebate(config: event.config);
      emit(
        state.copyWith(
          messages: [welcomeMessage],
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          messages: [welcomeMessage],
          errorMessage: '대화 세션 초기화에 실패했습니다. 계속 진행은 가능하지만 API 상태를 확인해주세요.',
        ),
      );
    }
  }

  void _onChatInputChanged(
    ChatInputChanged event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(input: event.value));
  }

  Future<void> _onChatSubmitted(
    ChatSubmitted event,
    Emitter<ChatState> emit,
  ) async {
    final config = state.config;
    final trimmed = event.message.trim();

    if (config == null || trimmed.isEmpty || state.isSending) {
      return;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      createdAt: DateTime.now(),
    );

    final pendingMessages = [...state.messages, userMessage];

    emit(
      state.copyWith(
        messages: pendingMessages,
        input: '',
        isSending: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final reply = await sendChatMessage(
        config: config,
        message: trimmed,
      );

      emit(
        state.copyWith(
          isSending: false,
          messages: [...pendingMessages, reply],
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSending: false,
          messages: pendingMessages,
          errorMessage: '채팅 요청에 실패했습니다. 요청 body와 응답 필드를 확인해주세요.',
        ),
      );
    }
  }

  Future<void> _onDebateEvaluationRequested(
    DebateEvaluationRequested event,
    Emitter<ChatState> emit,
  ) async {
    final config = state.config;

    if (state.isEvaluating) {
      return;
    }

    if (config == null) {
      emit(
        state.copyWith(
          errorMessage: '평가에 필요한 토론 세션 정보가 없습니다. 다시 시작해주세요.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isEvaluating: true,
        clearErrorMessage: true,
        clearEvaluation: true,
      ),
    );

    try {
      final result = await evaluateDebate(config: config);
      emit(
        state.copyWith(
          isEvaluating: false,
          evaluation: result,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isEvaluating: false,
          errorMessage: '평가 요청에 실패했습니다. API 응답 형식을 확인해주세요.',
        ),
      );
    }
  }

  void _onDebateEvaluationCleared(
    DebateEvaluationCleared event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(clearEvaluation: true));
  }

  Future<void> _onDebateResetRequested(
    DebateResetRequested event,
    Emitter<ChatState> emit,
  ) async {
    final config = state.config;

    emit(
      state.copyWith(
        isResetting: true,
        input: '',
        clearErrorMessage: true,
        clearEvaluation: true,
      ),
    );

    try {
      if (config == null) {
        emit(state.copyWith(isResetting: false));
        return;
      }

      final safeConfig = config;

      await resetDebate(config: safeConfig);
      emit(
        state.copyWith(
          isResetting: false,
          messages: [_buildWelcomeMessage(safeConfig)],
        ),
      );
    } catch (_) {
      if (config == null) {
        emit(
          state.copyWith(
            isResetting: false,
            errorMessage: '세션 초기화에 실패했습니다.',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isResetting: false,
          messages: [_buildWelcomeMessage(config)],
          errorMessage: '세션 초기화에 실패했습니다.',
        ),
      );
    }
  }

  void _onChatErrorCleared(
    ChatErrorCleared event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(clearErrorMessage: true));
  }

  ChatMessage _buildWelcomeMessage(DebateSessionConfig config) {
    return ChatMessage(
      id: 'welcome-${DateTime.now().microsecondsSinceEpoch}',
      text: '"${config.topic}"에 대해 이야기해 주세요. 먼저 주장을 말씀해주시면 그 논리를 바탕으로 반박을 이어가겠습니다.',
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
