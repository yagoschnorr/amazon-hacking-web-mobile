import 'package:flutter/material.dart';

import '../features/auth/data/auth_service.dart';
import '../features/auth/presentation/splash_page.dart';
import '../features/estandes/presentation/home_page.dart';
import '../features/missao/data/missao_controller.dart';
import 'theme/app_theme.dart';

class CircuitoApp extends StatelessWidget {
  const CircuitoApp({super.key, required this.missao});

  final MissaoController missao;

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return MaterialApp(
      title: 'Circuito de Descobertas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      home: SplashPage(
        garantirSessao: auth.garantirSessao,
        destino: (_) => HomePage(visitanteId: auth.uid, missao: missao),
      ),
    );
  }
}
