import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'package:b3o1/features/domain/entities/chat_message.dart';
import 'package:b3o1/features/domain/entities/debate_evaluation.dart';
import 'package:b3o1/features/domain/entities/debate_session_config.dart';
import 'package:b3o1/features/domain/entities/debate_style.dart';
import 'package:b3o1/features/domain/repositories/debate_repository.dart';
import 'package:b3o1/features/domain/usecases/evaluate_debate.dart';
import 'package:b3o1/features/domain/usecases/reset_debate.dart';
import 'package:b3o1/features/domain/usecases/send_chat_message.dart';
import 'package:b3o1/features/presentation/bloc/chat/chat_bloc.dart';
import 'package:b3o1/features/presentation/bloc/chat/chat_event.dart';
import 'package:b3o1/features/presentation/bloc/chat/chat_state.dart';

class _FakeDebateRepository implements DebateRepository {
  _FakeDebateRepository({
    Future<ChatMessage> Function({
      required DebateSessionConfig config,
      required String message,
    })?
    sendChatMessageImpl,
    Future<DebateEvaluation> Function()? evaluateDebateImpl,
    Future<void> Function()? resetDebateImpl,
  }) : _sendChatMessageImpl = sendChatMessageImpl,
       _evaluateDebateImpl = evaluateDebateImpl,
       _resetDebateImpl = resetDebateImpl;

  final Future<ChatMessage> Function({
    required DebateSessionConfig config,
    required String message,
  })?
  _sendChatMessageImpl;
  final Future<DebateEvaluation> Function()? _evaluateDebateImpl;
  final Future<void> Function()? _resetDebateImpl;

  @override
  Future<ChatMessage> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  }) {
    return _sendChatMessageImpl!(config: config, message: message);
  }

  @override
  Future<DebateEvaluation> evaluateDebate() {
    return _evaluateDebateImpl!();
  }

  @override
  Future<void> resetDebate() {
    return _resetDebateImpl!();
  }
}

void main() {
  const config = DebateSessionConfig(
    topic: '인공지능 예술작품의 저작권을 인정해야 하는가?',
    style: DebateStyle.aggressive,
  );

  ChatBloc buildBloc({
    Future<ChatMessage> Function({
      required DebateSessionConfig config,
      required String message,
    })?
    sendChatMessageImpl,
    Future<DebateEvaluation> Function()? evaluateDebateImpl,
    Future<void> Function()? resetDebateImpl,
  }) {
    final repository = _FakeDebateRepository(
      sendChatMessageImpl:
          sendChatMessageImpl ??
          ({required config, required message}) async => ChatMessage(
            id: 'assistant-1',
            text: '반박 응답',
            isUser: false,
            createdAt: DateTime(2026),
          ),
      evaluateDebateImpl:
          evaluateDebateImpl ??
          () async => const DebateEvaluation(
            score: 80,
            logicScore: 40,
            persuasionScore: 40,
            strengths: ['논리'],
            weaknesses: ['근거'],
            summary: '요약',
            rawChat: '대화',
          ),
      resetDebateImpl: resetDebateImpl ?? () async {},
    );

    return ChatBloc(
      sendChatMessage: SendChatMessage(repository),
      evaluateDebate: EvaluateDebate(repository),
      resetDebate: ResetDebate(repository),
    );
  }

  Future<List<ChatState>> collectStates(
    ChatBloc bloc,
    Future<void> Function() action,
  ) async {
    final emitted = <ChatState>[];
    final subscription = bloc.stream.listen(emitted.add);

    await action();
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await subscription.cancel();
    return emitted;
  }

  group('ChatBloc', () {
    test('시작 시 환영 메시지를 준비한다', () async {
      final bloc = buildBloc();

      final emitted = await collectStates(
        bloc,
        () async => bloc.add(const ChatStarted(config)),
      );

      expect(emitted, hasLength(2));
      expect(emitted.first.config?.topic, config.topic);
      expect(emitted.last.messages, hasLength(1));
      expect(emitted.last.messages.first.isUser, isFalse);
      expect(emitted.last.messages.first.text, contains('먼저 주장을 말씀해주시면'));

      await bloc.close();
    });

    test('메시지 전송 성공 시 사용자/응답 메시지를 순서대로 추가한다', () async {
      final bloc = buildBloc();
      bloc.add(const ChatStarted(config));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final emitted = await collectStates(
        bloc,
        () async => bloc.add(const ChatSubmitted('안녕하세요')),
      );

      expect(emitted, hasLength(2));
      expect(emitted.first.isSending, isTrue);
      expect(emitted.first.input, isEmpty);
      expect(emitted.first.messages.last.text, '안녕하세요');
      expect(emitted.first.messages.last.isUser, isTrue);
      expect(emitted.last.isSending, isFalse);
      expect(emitted.last.messages.last.text, '반박 응답');
      expect(emitted.last.messages.last.isUser, isFalse);

      await bloc.close();
    });

    test('메시지 전송 실패 시 사용자 메시지는 유지하고 오류를 노출한다', () async {
      final bloc = buildBloc(
        sendChatMessageImpl:
            ({
              required DebateSessionConfig config,
              required String message,
            }) async {
              throw Exception('server error');
            },
      );
      bloc.add(const ChatStarted(config));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final emitted = await collectStates(
        bloc,
        () async => bloc.add(const ChatSubmitted('안녕하세요')),
      );

      expect(emitted, hasLength(2));
      expect(emitted.first.isSending, isTrue);
      expect(emitted.last.isSending, isFalse);
      expect(emitted.last.messages.last.text, '안녕하세요');
      expect(
        emitted.last.errorMessage,
        '채팅 요청 처리 중 예기치 못한 오류가 발생했습니다. 요청 값과 서버 로그를 함께 확인해주세요.',
      );

      await bloc.close();
    });

    test('메시지 전송 타임아웃 시 지연 안내 문구를 노출한다', () async {
      final bloc = buildBloc(
        sendChatMessageImpl:
            ({
              required DebateSessionConfig config,
              required String message,
            }) async {
              throw DioException(
                requestOptions: RequestOptions(path: 'chat'),
                type: DioExceptionType.receiveTimeout,
              );
            },
      );
      bloc.add(const ChatStarted(config));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final emitted = await collectStates(
        bloc,
        () async => bloc.add(const ChatSubmitted('안녕하세요')),
      );

      expect(emitted, hasLength(2));
      expect(emitted.last.isSending, isFalse);
      expect(
        emitted.last.errorMessage,
        '채팅 요청 응답이 지연되고 있습니다. 서버 처리 시간이 길어지거나 네트워크 상태가 불안정할 수 있어요. 잠시 후 다시 시도해주세요.',
      );

      await bloc.close();
    });
  });
}
