import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../domain/entities/debate_style.dart';
import '../../domain/entities/debate_session_config.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_message_bubble.dart';

class ChatPage extends StatelessWidget {
  final DebateSessionConfig config;

  const ChatPage({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(ChatStarted(config)),
      child: _ChatView(config: config),
    );
  }
}

class _ChatView extends StatefulWidget {
  final DebateSessionConfig config;

  const _ChatView({required this.config});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isNearBottom() {
    if (!_scrollController.hasClients) {
      return true;
    }

    final position = _scrollController.position;
    final distanceToBottom = position.maxScrollExtent - position.pixels;

    return distanceToBottom < 120;
  }

  void _submitCurrentMessage(BuildContext context) {
    final raw = _inputController.text;

    if (raw.trim().isEmpty) {
      return;
    }

    _inputController.clear();
    context.read<ChatBloc>().add(const ChatInputChanged(''));
    context.read<ChatBloc>().add(ChatSubmitted(raw));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChatBloc, ChatState>(
              listenWhen: (previous, current) =>
                  previous.input != current.input,
              listener: (context, state) {
                if (_inputController.text != state.input) {
                  _inputController.value = TextEditingValue(
                    text: state.input,
                    selection: TextSelection.collapsed(
                      offset: state.input.length,
                    ),
                  );
                }
              },
            ),
            BlocListener<ChatBloc, ChatState>(
              listenWhen: (previous, current) =>
                  previous.errorMessage != current.errorMessage ||
                  previous.evaluation != current.evaluation,
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                  context.read<ChatBloc>().add(const ChatErrorCleared());
                }

                if (state.evaluation != null) {
                  showDialog<void>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('토론 종합 분석'),
                        content: SingleChildScrollView(
                          child: Text(
                            state.evaluation!.summary,
                            style: const TextStyle(height: 1.6),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('닫기'),
                          ),
                        ],
                      );
                    },
                  ).then((_) {
                    if (context.mounted) {
                      context.read<ChatBloc>().add(
                        const DebateEvaluationCleared(),
                      );
                    }
                  });
                }
              },
            ),
            BlocListener<ChatBloc, ChatState>(
              listenWhen: (previous, current) =>
                  previous.messages.length != current.messages.length,
              listener: (context, state) {
                final shouldAutoScroll = _isNearBottom();

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients && shouldAutoScroll) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                    );
                  }
                });
              },
            ),
          ],
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: SizedBox(
                          height: constraints.maxHeight - 32,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFDDE6F3),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x120F172A),
                                  blurRadius: 30,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _ChatHeader(config: widget.config),
                                Expanded(
                                  child: ListView(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 28,
                                      vertical: 24,
                                    ),
                                    children: [
                                      for (final message in state.messages)
                                        ChatMessageBubble(message: message),
                                      if (state.isSending)
                                        const _AiTypingBubble(),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    28,
                                    18,
                                    28,
                                    20,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(color: Color(0xFFE6EDF7)),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF8FAFE),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFD6E3FF,
                                                  ),
                                                ),
                                              ),
                                              child: Focus(
                                                onKeyEvent: (_, event) {
                                                  if (event is KeyDownEvent &&
                                                      event.logicalKey ==
                                                          LogicalKeyboardKey
                                                              .enter &&
                                                      !HardwareKeyboard
                                                          .instance
                                                          .isShiftPressed) {
                                                    _submitCurrentMessage(
                                                      context,
                                                    );
                                                    return KeyEventResult
                                                        .handled;
                                                  }

                                                  return KeyEventResult.ignored;
                                                },
                                                child: TextField(
                                                  controller: _inputController,
                                                  maxLines: 4,
                                                  minLines: 1,
                                                  keyboardType:
                                                      TextInputType.multiline,
                                                  textInputAction:
                                                      TextInputAction.newline,
                                                  onChanged: (value) {
                                                    context
                                                        .read<ChatBloc>()
                                                        .add(
                                                          ChatInputChanged(
                                                            value,
                                                          ),
                                                        );
                                                  },
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        '상대방의 논리에 반박할 내용을 입력하세요...',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          _ActionButton(
                                            icon: Icons.send_rounded,
                                            enabled: state.canSend,
                                            onTap: () {
                                              _submitCurrentMessage(context);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          _ActionButton(
                                            icon: Icons.refresh_rounded,
                                            enabled: !state.isResetting,
                                            onTap: () {
                                              context.read<ChatBloc>().add(
                                                const DebateResetRequested(),
                                              );
                                            },
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  final DebateSessionConfig config;

  const _ChatHeader({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6EDF7))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF64748B),
            ),
            tooltip: '뒤로가기',
          ),
          const SizedBox(width: 4),
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF2F6BFF),
            child: Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
          const SizedBox(width: 14),
          const Text(
            'AI 토론',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE8EC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  config.style.modeLabel,
                  style: const TextStyle(
                    color: Color(0xFFFF4D67),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                config.topic,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1F2937),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              context.read<ChatBloc>().add(const DebateEvaluationRequested());
            },
            child: const Text(
              '토론 종료 및 종합 분석',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiTypingBubble extends StatelessWidget {
  const _AiTypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TypingDot(delay: 0),
            const SizedBox(width: 4),
            const _TypingDot(delay: 120),
            const SizedBox(width: 4),
            const _TypingDot(delay: 240),
            const SizedBox(width: 12),
            Text(
              'AI가 입력 중입니다...',
              style: TextStyle(
                color: const Color(0xFF7B879D).withOpacity(0.95),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      onEnd: () {},
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFF9DB2D3),
          shape: BoxShape.circle,
        ),
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
