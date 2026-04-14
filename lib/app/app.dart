import 'package:flutter/material.dart';

import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI TALK',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2f6BFF)),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: 'Pretendard',
        fontFamilyFallback: const [
          'Apple SD Gothic Neo',
          'Malgun Gothic',
          'Nanum Gothic',
          'Noto Sans KR',
          'Noto Sans CJK KR',
          'sans-serif',
        ],
        useMaterial3: true,
      ),
    );
  }
}
