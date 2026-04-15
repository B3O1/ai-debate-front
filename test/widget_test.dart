import 'package:flutter/material.dart';
import 'package:b3o1/app/app.dart';
import 'package:b3o1/app/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('App can be created', () {
    expect(const App(), isA<StatelessWidget>());
  });

  test('App router exposes expected route names', () {
    expect(AppRouter.home, '/');
    expect(AppRouter.chat, '/chat');
    expect(AppRouter.evaluation, '/evaluation');
  });

  test('App router handles unknown routes', () {
    final route = AppRouter.onGenerateRoute(
      const RouteSettings(name: '/missing'),
    );

    expect(route, isA<MaterialPageRoute<dynamic>>());
    expect(route.settings.name, '/missing');
  });
}
