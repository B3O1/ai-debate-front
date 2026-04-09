import 'package:dio/dio.dart';

import '../../domain/entities/debate_style.dart';
import '../../domain/entities/debate_session_config.dart';
import '../models/chat_message_model.dart';
import '../models/debate_evaluation_model.dart';

abstract class DebateRemoteDataSource {
  Future<ChatMessageModel> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  });

  Future<DebateEvaluationModel> evaluateDebate({
    required DebateSessionConfig config,
  });

  Future<void> resetDebate({required DebateSessionConfig config});
}

class DebateRemoteDataSourceImpl implements DebateRemoteDataSource {
  final Dio dio;
  static const String _defaultSessionId = 'default';

  const DebateRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatMessageModel> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  }) async {
    final topicBackground = config.isCustomTopic
        ? '사용자가 직접 입력한 논제입니다.'
        : '선택된 논제를 기준으로 토론합니다.';

    final response = await dio.post(
      'chat',
      data: {
        'user_id': 'guest',
        'session_id': _defaultSessionId,
        'topic': config.topic,
        'message': message,
        'model_type': 'groq',
        'personality': config.style.personalityValue,
        'attitude': config.style.attitudeValue,
        'atmosphere': config.style.atmosphereValue,
        'background': topicBackground,
        'goal': '사용자의 주장에 논리적으로 반박하고 토론을 이어간다.',
        'condition': '항상 한국어로 답변하고, 사용자의 주장에 직접 반박하되 선택된 스타일 톤을 유지한다.',
      },
    );

    return ChatMessageModel.fromApi(response.data);
  }

  @override
  Future<DebateEvaluationModel> evaluateDebate({
    required DebateSessionConfig config,
  }) async {
    final response = await dio.post(
      'evaluate',
      options: Options(
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 60),
      ),
      data: {'session_id': _defaultSessionId},
    );
    return DebateEvaluationModel.fromApi(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> resetDebate({required DebateSessionConfig config}) async {
    await dio.post('reset', data: {'session_id': _defaultSessionId});
  }
}
