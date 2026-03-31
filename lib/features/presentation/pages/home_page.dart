import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/app_router.dart';
import '../../../core/di/injection.dart';
import '../../domain/entities/debate_session_config.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/custom_topic_card.dart';
import '../widgets/debate_style_section.dart';
import '../widgets/home_header_section.dart';
import '../widgets/start_debate_button.dart';
import '../widgets/topic_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final TextEditingController _customTopicController = TextEditingController();

  @override
  void dispose() {
    _customTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: BlocListener<HomeBloc, HomeState>(
          listenWhen: (previous, current) =>
              previous.customTopicText != current.customTopicText,
          listener: (context, state) {
            if (_customTopicController.text != state.customTopicText) {
              _customTopicController.value = TextEditingValue(
                text: state.customTopicText,
                selection: TextSelection.collapsed(
                  offset: state.customTopicText.length,
                ),
              );
            }
          },
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 40,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 80,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0xFFDDE6F3),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x120F172A),
                                  blurRadius: 36,
                                  offset: Offset(0, 18),
                                ),
                                BoxShadow(
                                  color: Color(0x0A0F172A),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const HomeHeaderSection(),
                                const SizedBox(height: 32),
                                if (state.isLoading)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 80,
                                      ),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (state.errorMessage != null)
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 80,
                                      ),
                                      child: Text(
                                        state.errorMessage!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Wrap(
                                    spacing: 20,
                                    runSpacing: 20,
                                    children: state.topics.map((topic) {
                                      if (topic.isCustomInput) {
                                        return CustomTopicCard(
                                          isSelected:
                                              state.selectedTopicId == topic.id,
                                          isHovered:
                                              state.hoveredTopicId == topic.id,
                                          controller: _customTopicController,
                                          onTap: () {
                                            context.read<HomeBloc>().add(
                                              TopicSelected(topic.id),
                                            );
                                          },
                                          onHoverEnter: () {
                                            context.read<HomeBloc>().add(
                                              TopicHovered(topic.id),
                                            );
                                          },
                                          onHoverExit: () {
                                            context.read<HomeBloc>().add(
                                              const TopicHoverExited(),
                                            );
                                          },
                                          onChanged: (value) {
                                            context.read<HomeBloc>().add(
                                              CustomTopicChanged(value),
                                            );
                                          },
                                        );
                                      }

                                      return TopicCard(
                                        topic: topic,
                                        isSelected:
                                            state.selectedTopicId == topic.id,
                                        isHovered:
                                            state.hoveredTopicId == topic.id,
                                        onTap: () {
                                          context.read<HomeBloc>().add(
                                            TopicSelected(topic.id),
                                          );
                                        },
                                        onHoverEnter: () {
                                          context.read<HomeBloc>().add(
                                            TopicHovered(topic.id),
                                          );
                                        },
                                        onHoverExit: () {
                                          context.read<HomeBloc>().add(
                                            const TopicHoverExited(),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                const SizedBox(height: 40),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7FAFE),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: const Color(0xFFE4EBF5),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: DebateStyleSection(
                                          selectedStyle: state.selectedStyle,
                                          hoveredStyle: state.hoveredStyle,
                                          onStyleTapped: (style) {
                                            context.read<HomeBloc>().add(
                                              DebateStyleToggled(style),
                                            );
                                          },
                                          onStyleHoverEnter: (style) {
                                            context.read<HomeBloc>().add(
                                              DebateStyleHovered(style),
                                            );
                                          },
                                          onStyleHoverExit: () {
                                            context.read<HomeBloc>().add(
                                              const DebateStyleHoverExited(),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: StartDebateButton(
                                            enabled: state.isStartEnabled,
                                            onPressed: () {
                                              if (!state.isStartEnabled) return;

                                              final selectedTopic = state.topics
                                                  .firstWhere(
                                                    (topic) =>
                                                        topic.id ==
                                                        state.selectedTopicId,
                                                  );

                                              final config = DebateSessionConfig(
                                                topic:
                                                    state.isCustomTopicSelected
                                                    ? state.customTopicText
                                                          .trim()
                                                    : selectedTopic.title,
                                                topicId:
                                                    state.isCustomTopicSelected
                                                    ? null
                                                    : selectedTopic.id,
                                                customTopic:
                                                    state.isCustomTopicSelected
                                                    ? state.customTopicText
                                                          .trim()
                                                    : null,
                                                style: state.selectedStyle!,
                                              );

                                              Navigator.of(context).pushNamed(
                                                AppRouter.chat,
                                                arguments: config,
                                              );
                                            },
                                          ),
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
