import 'package:flutter/material.dart';

import '../../../domain/entities/chat_message.dart';
import 'chat_message_bubble.dart';
import 'ai_typing_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ScrollController controller;
  final List<ChatMessage> messages;
  final bool isSending;
  final bool compact;

  const ChatMessageList({
    super.key,
    required this.controller,
    required this.messages,
    required this.isSending,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return ListView(
      controller: controller,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? (compact ? 12 : 16) : 28,
        vertical: isMobile ? (compact ? 10 : 16) : 24,
      ),
      children: [
        for (final message in messages) ChatMessageBubble(message: message),
        if (isSending) const AiTypingBubble(),
      ],
    );
  }
}
