import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import '../../domain/entities/debate_session_config.dart';
import '../bloc/evaluation_bloc.dart';
import '../bloc/evaluation_event.dart';
import '../bloc/evaluation_state.dart';
import '../widgets/evaluation/evaluation_header.dart';
import '../widgets/evaluation/evaluation_loaded_content.dart';
import '../widgets/evaluation/evaluation_loading_content.dart';

class EvaluationPage extends StatelessWidget {
  final DebateSessionConfig config;

  const EvaluationPage({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EvaluationBloc>()..add(EvaluationStarted(config)),
      child: _EvaluationView(config: config),
    );
  }
}

class _EvaluationView extends StatelessWidget {
  final DebateSessionConfig config;

  const _EvaluationView({
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FA),
      body: SafeArea(
        child: BlocBuilder<EvaluationBloc, EvaluationState>(
          builder: (context, state) {
            final body = state is EvaluationLoading || state is EvaluationInitial
                ? EvaluationLoadingContent(config: config)
                : EvaluationLoadedContent(
                    config: config,
                    state: state,
                  );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE2EAF6)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x100F172A),
                      blurRadius: 36,
                      offset: Offset(0, 18),
                    ),
                    BoxShadow(
                      color: Color(0x080F172A),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EvaluationHeader(
                          onRestart: () {
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                        ),
                        const SizedBox(height: 24),
                        body,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
