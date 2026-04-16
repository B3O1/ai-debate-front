import 'package:flutter/material.dart';

import '../../../domain/entities/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isMobile = MediaQuery.sizeOf(context).width < 700;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 14),
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              _SpeakerAvatar(isUser: false, mobile: isMobile),
              SizedBox(width: isMobile ? 8 : 12),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 20,
                  vertical: isMobile ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: isUser ? const Color(0xFF2F6BFF) : Colors.white,
                  borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
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
                    fontSize: isMobile ? 15 : 18,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: isUser ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ),
            ),
            if (isUser) ...[
              SizedBox(width: isMobile ? 8 : 12),
              _SpeakerAvatar(isUser: true, mobile: isMobile),
            ],
          ],
        ),
      ),
    );
  }
}

class _SpeakerAvatar extends StatelessWidget {
  final bool isUser;
  final bool mobile;

  const _SpeakerAvatar({required this.isUser, this.mobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobile ? 32 : 38,
      height: mobile ? 32 : 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD6E3FF)),
      ),
      child: Icon(
        isUser ? Icons.person_outline : Icons.smart_toy_outlined,
        size: mobile ? 18 : 20,
        color: const Color(0xFF2F6BFF),
      ),
    );
  }
}
