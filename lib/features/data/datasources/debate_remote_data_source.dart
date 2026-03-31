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

  Future<DebateEvaluationModel> evaluateDebate();

  Future<void> resetDebate();
}

class DebateRemoteDataSourceImpl implements DebateRemoteDataSource {
  final Dio dio;

  const DebateRemoteDataSourceImpl(this.dio);

  @override
  Future<ChatMessageModel> sendChatMessage({
    required DebateSessionConfig config,
    required String message,
  }) async {
    final response = await dio.post(
      'chat',
      data: {
        'topic': config.topic,
        'topicId': config.topicId,
        'customTopic': config.customTopic,
        'style': config.style.apiValue,
        'mode': config.style.apiValue,
        'message': message,
        'userMessage': message,
        'user_input': message,
      },
    );

    return ChatMessageModel.fromApi(response.data);
  }

  @override
  Future<DebateEvaluationModel> evaluateDebate() async {
    final response = await dio.post('evaluate');
    return DebateEvaluationModel.fromApi(response.data);
  }

  @override
  Future<void> resetDebate() async {
    await dio.post('reset');
  }
}
