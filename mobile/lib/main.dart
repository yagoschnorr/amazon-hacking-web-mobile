import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'features/missao/data/missao_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // A missão carrega em paralelo; até lá vale o padrão local (desligada).
  final missao = MissaoController();
  unawaited(missao.iniciar());
  runApp(CircuitoApp(missao: missao));
}
