import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  final String text;
  final String step1Context;
  final String step2Attitude;
  final String userSummary;
  final String aiSummary;
  final int? logicScore;
  final int? persuasionScore;
  final String feedback;
  final List<String> userHistory;
  final List<String> aiHistory;
  final int? totalTokens;
  final String timestamp;

  const ChatMessageModel({
    required this.text,
    required this.step1Context,
    required this.step2Attitude,
    required this.userSummary,
    required this.aiSummary,
    required this.logicScore,
    required this.persuasionScore,
    required this.feedback,
    required this.userHistory,
    required this.aiHistory,
    required this.totalTokens,
    required this.timestamp,
  });

  factory ChatMessageModel.fromApi(dynamic data) {
    if (data is Map<String, dynamic>) {
      final evaluation = _asMap(data['evaluation']);

      return ChatMessageModel(
        text: _extractText(data),
        step1Context: _asString(data['step1_context']),
        step2Attitude: _asString(data['step2_attitude']),
        userSummary: _asString(data['user_summary']),
        aiSummary: _asString(data['ai_summary']),
        logicScore: _asInt(evaluation['logic_score']),
        persuasionScore: _asInt(evaluation['persuasion_score']),
        feedback: _asString(evaluation['feedback']),
        userHistory: _asStringList(data['user_history']),
        aiHistory: _asStringList(data['ai_history']),
        totalTokens: _asInt(data['total_tokens']),
        timestamp: _asString(data['timestamp']),
      );
    }

    return ChatMessageModel(
      text: _extractText(data),
      step1Context: '',
      step2Attitude: '',
      userSummary: '',
      aiSummary: '',
      logicScore: null,
      persuasionScore: null,
      feedback: '',
      userHistory: const [],
      aiHistory: const [],
      totalTokens: null,
      timestamp: '',
    );
  }

  static String _extractText(dynamic data) {
    if (data is String) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      const candidateKeys = [
        'ai_rebuttal',
        'response',
        'reply',
        'assistantResponse',
        'assistant_response',
        'aiResponse',
        'ai_response',
        'message',
        'content',
        'result',
        'output',
        'text',
      ];

      for (final key in candidateKeys) {
        final value = data[key];
        final text = _asString(value);
        if (text.isNotEmpty) {
          return text;
        }
      }

      final nested = data['data'];
      if (nested != null) {
        return _extractText(nested);
      }
    }

    return '응답을 해석하지 못했습니다. 잠시 후 다시 시도해주세요.';
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    return const {};
  }

  static String _asString(dynamic value) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || trimmed.toLowerCase() == 'string') {
        return '';
      }
      return trimmed;
    }
    return '';
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static List<String> _asStringList(dynamic value) {
    if (value is List) {
      return value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty && item.toLowerCase() != 'string')
          .toList();
    }
    return const [];
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      createdAt: DateTime.now(),
    );
  }
}
