import 'package:flutter/material.dart';

import '../features/auth/data/auth_service.dart';
import '../features/auth/presentation/splash_page.dart';
import 'theme/app_theme.dart';

class CircuitoApp extends StatelessWidget {
  const CircuitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circuito de Descobertas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      home: SplashPage(
        garantirSessao: AuthService().garantirSessao,
        // Tela vazia até a HomePage (M4).
        destino: (_) => const Scaffold(),
      ),
    );
  }
}
