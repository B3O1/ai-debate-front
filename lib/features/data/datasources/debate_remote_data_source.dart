import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/debate_style.dart';
import '../../domain/entities/debate_session_config.dart';
import '../models/chat_message_model.dart';
import '../models/debate_evaluation_model.dart';

abstract class DebateRemoteDataSource {
  Future<ChatMessageModel> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  });

  Future<DebateEvaluationModel> evaluateDebate();

  Future<void> resetDebate();
}

class DebateRemoteDataSourceImpl implements DebateRemoteDataSource {
  final Dio dio;
  static final Random _random = Random();
  String _sessionId = _createSessionId();

  DebateRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatMessageModel> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  }) async {
    final response = await dio.post(
      'chat',
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
      data: _buildChatRequestBody(config: config, message: message),
    );

    return ChatMessageModel.fromApi(response.data);
  }

  @override
  Future<DebateEvaluationModel> evaluateDebate() async {
    final response = await dio.post(
      'evaluate',
      options: Options(
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 60),
      ),
      data: {'session_id': _sessionId},
    );
    return DebateEvaluationModel.fromApi(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> resetDebate() async {
    _sessionId = _createSessionId();
    debugPrint('[DebateRemoteDataSource] started session $_sessionId');
    await dio.post('reset', data: {'session_id': _sessionId});
  }

  Map<String, dynamic> _buildChatRequestBody({
    required DebateSessionConfig config,
    required String message,
  }) {
    final topicBackground = config.isCustomTopic
        ? '사용자가 직접 입력한 논제입니다.'
        : '선택한 토론 논제를 기준으로 토론을 진행합니다.';

    return {
      'user_id': 'guest',
      'session_id': _sessionId,
      'message': message,
      'model_type': 'groq',
      'personality': config.style.personalityValue,
      'attitude': config.style.attitudeValue,
      'atmosphere': config.style.atmosphereValue,
      'topic': config.topic,
      'background': topicBackground,
      'goal': '상대의 주장에 반박하고 토론을 이어간다.',
      'condition': '항상 한국어로 답변하고 선택된 스타일 톤을 유지한다.',
    };
  }

  static String _createSessionId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomSuffix = List.generate(
      8,
      (_) => _random.nextInt(16).toRadixString(16),
    ).join();
    return 'session-$timestamp-$randomSuffix';
  }
}
