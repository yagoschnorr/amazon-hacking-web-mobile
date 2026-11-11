// Eventos do Analytics (docs/contrato-de-dados.md). Só o app envia eventos.

abstract final class EventosAnalytics {
  /// O visitante abre a tela da missão. Sem parâmetros.
  static const missaoAberta = 'missao_aberta';

  /// Logo após a gravação do check-in ser confirmada.
  static const checkinConcluido = 'checkin_concluido';
}

abstract final class ParametrosAnalytics {
  /// Código do estande, por exemplo E03.
  static const estandeId = 'estande_id';
}
