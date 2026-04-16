import 'package:flutter/material.dart';

import '../../../domain/entities/chat_message.dart';
import 'chat_message_bubble.dart';
import 'ai_typing_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ScrollController controller;
  final List<ChatMessage> messages;
  final bool isSending;

  const ChatMessageList({
    super.key,
    required this.controller,
    required this.messages,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      children: [
        for (final message in messages) ChatMessageBubble(message: message),
        if (isSending) const AiTypingBubble(),
      ],
    );
  }
}
