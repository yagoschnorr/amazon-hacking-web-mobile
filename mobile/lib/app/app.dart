import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

class CircuitoApp extends StatelessWidget {
  const CircuitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circuito de Descobertas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      // Tela inicial vazia até a SplashPage (M3) e a HomePage (M4).
      home: const Scaffold(),
    );
  }
}
