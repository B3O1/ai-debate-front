import 'package:flutter/material.dart';

import '../../features/domain/entities/debate_session_config.dart';
import '../../features/presentation/pages/chat_page.dart';
import '../../features/presentation/pages/home_page.dart';

class AppRouter {
  static const String home = '/';
  static const String chat = '/chat';

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: setting,
        );
      case chat:
        final arguments = setting.arguments;

        if (arguments is! DebateSessionConfig) {
          return MaterialPageRoute(
            builder: (_) => const HomePage(),
            settings: const RouteSettings(name: home),
          );
        }

        return MaterialPageRoute(
          builder: (_) => ChatPage(config: arguments),
          settings: setting,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
          settings: setting,
        );
    }
  }
}
