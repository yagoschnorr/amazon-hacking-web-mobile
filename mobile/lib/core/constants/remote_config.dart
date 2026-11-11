// Parâmetros do Remote Config (docs/contrato-de-dados.md).
// Publicados pela organização no console do Firebase.

abstract final class ParametrosRemoteConfig {
  /// Boolean. Liga e desliga a missão surpresa.
  static const missaoAtiva = 'missao_ativa';

  /// JSON com a lista de códigos, por exemplo ["E02","E03"].
  static const missaoEstandesIds = 'missao_estandes_ids';

  /// Padrões locais, usados antes do primeiro fetch ou sem conexão.
  static const padroes = <String, Object>{
    missaoAtiva: false,
    missaoEstandesIds: '[]',
  };
}
