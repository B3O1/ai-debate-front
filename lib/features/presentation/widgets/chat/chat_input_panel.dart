import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInputPanel extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool canSend;
  final bool isResetting;
  final bool keyboardVisible;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  const ChatInputPanel({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.canSend,
    required this.isResetting,
    this.keyboardVisible = false,
    required this.onChanged,
    required this.onSubmit,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 700;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final compactMobile = isMobile && keyboardVisible;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 14 : 28,
        compactMobile ? 10 : 18,
        isMobile ? 14 : 28,
        (compactMobile ? 10 : isMobile ? 16 : 20) + viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            if (compactMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _InputField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      onSubmit: onSubmit,
                      mobile: true,
                      compact: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.refresh_rounded,
                    enabled: !isResetting,
                    onTap: onReset,
                  ),
                  const SizedBox(width: 8),
                  _ActionButton(
                    icon: Icons.send_rounded,
                    enabled: canSend,
                    onTap: onSubmit,
                  ),
                ],
              )
            else ...[
              _InputField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                onSubmit: onSubmit,
                mobile: true,
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
            ],
          ] else
            Row(
              children: [
                Expanded(
                  child: _InputField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onSubmit: onSubmit,
                    mobile: false,
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
          if (!compactMobile) ...[
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
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmit;
  final bool mobile;
  final bool compact;

  const _InputField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmit,
    required this.mobile,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 16 : 20,
        vertical: compact ? 2 : 6,
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
          focusNode: focusNode,
          autofocus: true,
          maxLines: compact ? 3 : 4,
          minLines: 1,
          keyboardType: TextInputType.multiline,
          onTapOutside: (_) => focusNode.unfocus(),
          textInputAction: mobile
              ? TextInputAction.send
              : TextInputAction.newline,
          onSubmitted: (_) => onSubmit(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '상대방의 논리에 반박할 내용을 입력하세요...',
          ),
          style: TextStyle(
            fontSize: compact ? 15 : 16,
            height: compact ? 1.3 : 1.4,
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
