import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  static const _webFontFallback = <String>[
    'Apple SD Gothic Neo',
    'Malgun Gothic',
    'Nanum Gothic',
    'Noto Sans KR',
    'Noto Sans CJK KR',
    'sans-serif',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI TalK',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2f6BFF)),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: kIsWeb ? null : 'Pretendard',
        fontFamilyFallback: kIsWeb
            ? _webFontFallback
            : const [
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
