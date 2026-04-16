import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/app_router.dart';
import '../../../core/di/injection.dart';
import '../../domain/entities/debate_session_config.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../widgets/home/home_header_section.dart';
import '../widgets/home/home_action_panel.dart';
import '../widgets/home/home_topic_grid.dart';

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
                  final isMobile = constraints.maxWidth < 700;
                  final isTabletLandscape =
                      !kIsWeb &&
                      constraints.maxWidth >= 900 &&
                      constraints.maxWidth > constraints.maxHeight;
                  final horizontalPadding = isMobile ? 16.0 : 28.0;
                  final verticalPadding = isTabletLandscape
                      ? 20.0
                      : isMobile
                      ? 20.0
                      : 40.0;
                  final containerPadding = isTabletLandscape
                      ? 24.0
                      : isMobile
                      ? 20.0
                      : 32.0;
                  final topicAreaHeightBudget = isTabletLandscape
                      ? constraints.maxHeight -
                            (verticalPadding * 2) -
                            (containerPadding * 2) -
                            200
                      : null;

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            constraints.maxHeight - (verticalPadding * 2),
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1280),
                          child: Container(
                            padding: EdgeInsets.all(containerPadding),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                isMobile ? 22 : 28,
                              ),
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
                                SizedBox(height: isMobile ? 24 : 32),
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
                                  HomeTopicGrid(
                                    topics: state.topics,
                                    availableHeight: topicAreaHeightBudget,
                                    compactLandscape: isTabletLandscape,
                                    selectedTopicId: state.selectedTopicId,
                                    hoveredTopicId: state.hoveredTopicId,
                                    customTopicController:
                                        _customTopicController,
                                    onTopicTap: (topicId) {
                                      context.read<HomeBloc>().add(
                                        TopicSelected(topicId),
                                      );
                                    },
                                    onTopicHoverEnter: (topicId) {
                                      context.read<HomeBloc>().add(
                                        TopicHovered(topicId),
                                      );
                                    },
                                    onTopicHoverExit: () {
                                      context.read<HomeBloc>().add(
                                        const TopicHoverExited(),
                                      );
                                    },
                                    onCustomTopicChanged: (value) {
                                      context.read<HomeBloc>().add(
                                        CustomTopicChanged(value),
                                      );
                                    },
                                  ),
                                SizedBox(
                                  height: isTabletLandscape
                                      ? 20
                                      : isMobile
                                      ? 24
                                      : 40,
                                ),
                                HomeActionPanel(
                                  compact: isTabletLandscape,
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
                                  isStartEnabled: state.isStartEnabled,
                                  onStartPressed: () {
                                    if (!state.isStartEnabled) return;

                                    final selectedTopic = state.topics
                                        .firstWhere(
                                          (topic) =>
                                              topic.id == state.selectedTopicId,
                                        );

                                    final config = DebateSessionConfig(
                                      topic: state.isCustomTopicSelected
                                          ? state.customTopicText.trim()
                                          : selectedTopic.title,
                                      topicId: state.isCustomTopicSelected
                                          ? null
                                          : selectedTopic.id,
                                      customTopic: state.isCustomTopicSelected
                                          ? state.customTopicText.trim()
                                          : null,
                                      style: state.selectedStyle!,
                                    );

                                    Navigator.of(context).pushNamed(
                                      AppRouter.chat,
                                      arguments: config,
                                    );
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
