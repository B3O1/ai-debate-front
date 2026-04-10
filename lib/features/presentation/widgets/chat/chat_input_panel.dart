import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInputPanel extends StatelessWidget {
  final TextEditingController controller;
  final bool canSend;
  final bool isResetting;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  const ChatInputPanel({
    super.key,
    required this.controller,
    required this.canSend,
    required this.isResetting,
    required this.onChanged,
    required this.onSubmit,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 18, 28, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFE),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFD6E3FF)),
                  ),
                  child: Focus(
                    onKeyEvent: (_, event) {
                      if (event is! KeyDownEvent ||
                          event.logicalKey != LogicalKeyboardKey.enter) {
                        return KeyEventResult.ignored;
                      }

                      if (HardwareKeyboard.instance.isShiftPressed) {
                        return KeyEventResult.ignored;
                      }

                      onSubmit();
                      return KeyEventResult.handled;
                    },
                    child: TextField(
                      controller: controller,
                      maxLines: 4,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      onChanged: onChanged,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '상대방의 논리에 반박할 내용을 입력하세요...',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                icon: Icons.send_rounded,
                enabled: canSend,
                onTap: onSubmit,
              ),
              const SizedBox(width: 10),
              _ActionButton(
                icon: Icons.refresh_rounded,
                enabled: !isResetting,
                onTap: onReset,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Shift + Enter 를 눌러 줄바꿈을 할 수 있습니다.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 54,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF2F6BFF) : const Color(0xFFD6E3FF),
          borderRadius: BorderRadius.circular(18),
        ),
        child: IconButton(
          onPressed: enabled ? onTap : null,
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
