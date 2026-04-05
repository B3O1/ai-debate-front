import 'package:flutter/material.dart';

import '../../features/domain/entities/debate_session_config.dart';
import '../../features/presentation/pages/chat_page.dart';
import '../../features/presentation/pages/evaluation_page.dart';
import '../../features/presentation/pages/home_page.dart';

class AppRouter {
  static const String home = '/';
  static const String chat = '/chat';
  static const String evaluation = '/evaluation';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case chat:
        final arguments = settings.arguments;

        if (arguments is! DebateSessionConfig) {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: const RouteSettings(name: home),
          );
        }

        return MaterialPageRoute(
          builder: (_) => ChatPage(config: arguments),
          settings: settings,
        );
      case evaluation:
        final arguments = settings.arguments;

        if (arguments is! DebateSessionConfig) {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: const RouteSettings(name: home),
          );
        }

        return MaterialPageRoute(
          builder: (_) => EvaluationPage(config: arguments),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
          settings: settings,
        );
    }
  }
}
