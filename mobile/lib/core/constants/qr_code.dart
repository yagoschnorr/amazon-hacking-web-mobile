// Conteúdo do QR code (docs/contrato-de-dados.md), gerado pelo painel web.

abstract final class QrCode {
  /// O QR carrega circuito-descobertas:estande:{estandeId}.
  /// Qualquer leitura fora desse formato é QR inválido.
  static const prefixo = 'circuito-descobertas:estande:';

  /// Formato do ID do estande (código curto), o mesmo das regras do Firestore.
  static final formatoId = RegExp(r'^[A-Z0-9]{2,12}$');
}
