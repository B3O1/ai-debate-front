import 'package:flutter/material.dart';

import '../../features/presentation/pages/home_page.dart';

class AppRouter {
  static const String home = '/';

  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
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
