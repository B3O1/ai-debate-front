import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../domain/entities/debate_session_config.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat/chat_header.dart';
import '../widgets/chat/chat_input_panel.dart';
import '../widgets/chat/chat_message_list.dart';

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
  final FocusNode _inputFocusNode = FocusNode();
  bool _pendingSubmitAfterComposition = false;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_handleInputControllerChanged);
  }

  void _handleInputControllerChanged() {
    if (!_pendingSubmitAfterComposition) {
      return;
    }

    final currentValue = _inputController.value;
    final isComposing =
        currentValue.composing.isValid && !currentValue.composing.isCollapsed;

    if (isComposing) {
      return;
    }

    _pendingSubmitAfterComposition = false;

    if (!mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _submitCurrentMessage(context);
      }
    });
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) {
      return true;
    }

    final position = _scrollController.position;
    final distanceToBottom = position.maxScrollExtent - position.pixels;

    return distanceToBottom < 120;
  }

  void _submitCurrentMessage(BuildContext context) {
    final currentValue = _inputController.value;
    final isComposing =
        currentValue.composing.isValid && !currentValue.composing.isCollapsed;

    if (isComposing) {
      _pendingSubmitAfterComposition = true;
      return;
    }

    final raw = _inputController.text;

    if (raw.trim().isEmpty) {
      return;
    }

    _inputController.clear();
    context.read<ChatBloc>().add(const ChatInputChanged(''));
    context.read<ChatBloc>().add(ChatSubmitted(raw));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _inputFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _inputController.removeListener(_handleInputControllerChanged);
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
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
                if (_inputController.text == state.input) {
                  return;
                }

                final currentValue = _inputController.value;
                final isComposing =
                    currentValue.composing.isValid &&
                    !currentValue.composing.isCollapsed;

                // Keep the native IME in control while the user is typing.
                // We only force-sync when the bloc explicitly clears the field.
                if (isComposing) {
                  return;
                }

                if (state.input.isEmpty) {
                  _inputController.clear();
                  return;
                }

                if (!_inputFocusNode.hasFocus) {
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
                  final isMobile = constraints.maxWidth < 700;
                  final outerPadding = isMobile ? 8.0 : 16.0;

                  return Padding(
                    padding: EdgeInsets.all(outerPadding),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1280),
                        child: SizedBox(
                          height: constraints.maxHeight - (outerPadding * 2),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                isMobile ? 22 : 30,
                              ),
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
                                ChatHeader(config: widget.config),
                                Expanded(
                                  child: ChatMessageList(
                                    controller: _scrollController,
                                    messages: state.messages,
                                    isSending: state.isSending,
                                  ),
                                ),
                                ChatInputPanel(
                                  controller: _inputController,
                                  focusNode: _inputFocusNode,
                                  canSend: state.canSend,
                                  isResetting: state.isResetting,
                                  onChanged: (value) {
                                    context.read<ChatBloc>().add(
                                      ChatInputChanged(value),
                                    );
                                  },
                                  onSubmit: () {
                                    _submitCurrentMessage(context);
                                  },
                                  onReset: () {
                                    context.read<ChatBloc>().add(
                                      const DebateResetRequested(),
                                    );
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      if (mounted) {
                                        _inputFocusNode.requestFocus();
                                      }
                                    });
                                  },
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
