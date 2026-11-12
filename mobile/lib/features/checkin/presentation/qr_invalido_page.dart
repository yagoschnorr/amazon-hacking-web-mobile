import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../core/widgets/tela_retorno.dart';

/// "QR code inválido" (docs/design/mobile/09-qr-code-invalido.png).
/// Fecha com `true` quando o visitante escolhe voltar ao início e sem valor
/// quando quer ler de novo.
class QrInvalidoPage extends StatelessWidget {
  const QrInvalidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TelaRetorno(
      icone: Symbols.qr_code_scanner_rounded,
      corCirculo: AppCores.errorSoft,
      corIcone: AppCores.error,
      sobretitulo: 'NÃO RECONHECIDO',
      corSobretitulo: AppCores.error,
      titulo: 'QR code inválido.',
      mensagem:
          'Este código não é de um estande do Circuito de Descobertas. '
          'Aponte para o QR code impresso no estande.',
      rotuloPrincipal: 'Ler de novo',
      iconePrincipal: Symbols.qr_code_scanner_rounded,
      aoPrincipal: () => Navigator.of(context).pop(),
      rotuloSecundario: 'Voltar ao início',
      aoSecundario: () => Navigator.of(context).pop(true),
    );
  }
}
