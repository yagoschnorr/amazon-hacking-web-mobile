// Parâmetros do Remote Config (docs/contrato-de-dados.md).
// Publicados pela organização no console do Firebase.

abstract final class ParametrosRemoteConfig {
  /// Boolean. Liga e desliga a missão surpresa.
  static const missaoAtiva = 'missao_ativa';

  /// JSON com a lista de códigos, por exemplo ["E02","E03"].
  static const missaoEstandesIds = 'missao_estandes_ids';

  /// String ISO 8601 com fuso, por exemplo 2026-11-20T15:00:00-03:00.
  /// Vazio: missão sem prazo.
  static const missaoInicio = 'missao_inicio';

  /// Number. Duração da missão em minutos; zero ou menos: sem prazo.
  static const missaoDuracaoMin = 'missao_duracao_min';

  /// Padrões locais, usados antes do primeiro fetch ou sem conexão.
  static const padroes = <String, Object>{
    missaoAtiva: false,
    missaoEstandesIds: '[]',
    missaoInicio: '',
    missaoDuracaoMin: 0,
  };
}
