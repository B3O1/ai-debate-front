import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  final String text;

  const ChatMessageModel({required this.text});

  factory ChatMessageModel.fromApi(dynamic data) {
    return ChatMessageModel(text: _extractText(data));
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
        if (value is String && value.trim().isNotEmpty) {
          return value;
        }
      }

      final nested = data['data'];
      if (nested != null) {
        return _extractText(nested);
      }
    }

    return '응답을 해석하지 못했습니다. 잠시 후 다시 시도해주세요.';
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
