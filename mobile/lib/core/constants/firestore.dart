// Nomes do Firestore usados pelo app (docs/contrato-de-dados.md).
// Não renomear sem acordo: o painel web usa os mesmos.

abstract final class Colecoes {
  static const estandes = 'estandes';
  static const checkins = 'checkins';
}

/// estandes/{codigo}, por exemplo estandes/E03.
abstract final class CamposEstande {
  static const nome = 'nome';
  static const descricao = 'descricao';
  static const localizacao = 'localizacao';
  static const ativo = 'ativo';
  static const criadoEm = 'criadoEm';
  static const atualizadoEm = 'atualizadoEm';
}

/// checkins/{visitanteId}_{estandeId}: uma visita por visitante e estande.
abstract final class CamposCheckin {
  static const visitanteId = 'visitanteId';
  static const estandeId = 'estandeId';
  static const criadoEm = 'criadoEm';
}
