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
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 28,
        18,
        isMobile ? 16 : 28,
        (isMobile ? 16 : 20) + viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            _InputField(
              controller: controller,
              onChanged: onChanged,
              onSubmit: onSubmit,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.send_rounded,
                    enabled: canSend,
                    onTap: onSubmit,
                    compact: false,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.refresh_rounded,
                    enabled: !isResetting,
                    onTap: onReset,
                    compact: false,
                  ),
                ),
              ],
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    controller: controller,
                    onChanged: onChanged,
                    onSubmit: onSubmit,
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
          Text(
            isMobile
                ? '모바일에서는 Enter로 전송됩니다.'
                : 'Shift + Enter 를 눌러 줄바꿈을 할 수 있습니다.',
            style: const TextStyle(
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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;

  const _InputField({
    required this.controller,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD6E3FF)),
      ),
      child: Focus(
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter &&
              HardwareKeyboard.instance.isShiftPressed) {
            final value = controller.value;
            final selection = value.selection;

            final start = selection.isValid
                ? selection.start
                : value.text.length;
            final end = selection.isValid ? selection.end : value.text.length;

            final newText = value.text.replaceRange(start, end, '\n');

            controller.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: start + 1),
            );

            onChanged(newText);
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: controller,
          maxLines: 4,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => onSubmit(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '상대방의 논리에 반박할 내용을 입력하세요...',
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  final bool compact;

  const _ActionButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: compact ? 54 : double.infinity,
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
