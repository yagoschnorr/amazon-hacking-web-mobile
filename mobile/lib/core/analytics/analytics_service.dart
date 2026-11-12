import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../constants/analytics.dart';

/// Os dois eventos do contrato (docs/contrato-de-dados.md). Uma falha no
/// envio não interrompe o visitante: fica só no log.
class AnalyticsService {
  final _analytics = FirebaseAnalytics.instance;

  /// O visitante abriu a tela da missão.
  Future<void> missaoAberta() => _registrar(EventosAnalytics.missaoAberta);

  /// Gravação do check-in confirmada, com o código do estande lido.
  Future<void> checkinConcluido(String estandeId) => _registrar(
    EventosAnalytics.checkinConcluido,
    {ParametrosAnalytics.estandeId: estandeId},
  );

  Future<void> _registrar(
    String nome, [
    Map<String, Object>? parametros,
  ]) async {
    try {
      await _analytics.logEvent(name: nome, parameters: parametros);
    } catch (erro) {
      debugPrint('Falha ao registrar o evento $nome: $erro');
    }
  }
}
