import '../../../core/constants/qr_code.dart';

/// Devolve o ID do estande quando o texto lido segue
/// `circuito-descobertas:estande:{id}` e o ID respeita `^[A-Z0-9]{2,12}$`.
/// Qualquer outro conteúdo devolve nulo (QR inválido), sem consultar o
/// Firestore.
String? parseQrPayload(String? texto) {
  if (texto == null || !texto.startsWith(QrCode.prefixo)) return null;
  final id = texto.substring(QrCode.prefixo.length);
  return QrCode.formatoId.hasMatch(id) ? id : null;
}
