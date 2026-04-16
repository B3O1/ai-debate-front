import 'package:flutter/material.dart';

import '../../../domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              const _SpeakerAvatar(isUser: false),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF2F6BFF) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isUser
                        ? const Color(0xFF2F6BFF)
                        : const Color(0xFFDCE5F2),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: isUser ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 12),
              const _SpeakerAvatar(isUser: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpeakerAvatar extends StatelessWidget {
  final bool isUser;

  const _SpeakerAvatar({required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6E3FF)),
      ),
      child: Icon(
        isUser ? Icons.person_outline : Icons.smart_toy_outlined,
        size: 20,
        color: const Color(0xFF2F6BFF),
      ),
    );
  }
}
