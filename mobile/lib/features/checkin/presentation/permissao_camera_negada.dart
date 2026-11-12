import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../../core/widgets/tela_retorno.dart';

const _configuracoes = MethodChannel('circuito_descobertas/configuracoes');

/// Abre a tela do app nas configurações do Android (MainActivity.kt).
Future<void> abrirConfiguracoesDoApp() {
  return _configuracoes.invokeMethod<void>('abrirConfiguracoesDoApp');
}

/// "Permita o acesso à câmera"
/// (docs/design/mobile/07-permissao-de-camera-negada.png).
class PermissaoCameraNegada extends StatelessWidget {
  const PermissaoCameraNegada({
    super.key,
    required this.aoAbrirConfiguracoes,
    required this.aoVoltar,
  });

  final VoidCallback aoAbrirConfiguracoes;
  final VoidCallback aoVoltar;

  @override
  Widget build(BuildContext context) {
    return TelaRetorno(
      icone: Symbols.no_photography_rounded,
      corCirculo: AppCores.primarySoft,
      corIcone: AppCores.primary,
      sobretitulo: 'CÂMERA BLOQUEADA',
      corSobretitulo: AppCores.primaryPressed,
      titulo: 'Permita o acesso à câmera.',
      mensagem:
          'O app usa a câmera só para ler os QR codes dos estandes. '
          'Nada é gravado.',
      conteudo: const _Passos([
        'Toque em Abrir configurações.',
        'Entre em Permissões e depois em Câmera.',
        'Escolha Permitir durante o uso do app.',
      ]),
      rotuloPrincipal: 'Abrir configurações',
      iconePrincipal: Symbols.settings_rounded,
      aoPrincipal: aoAbrirConfiguracoes,
      rotuloSecundario: 'Voltar ao início',
      aoSecundario: aoVoltar,
    );
  }
}

/// Lista numerada em body (15/22) sobre surface-page, com raio lg,
/// padding de 16px e 4px entre os passos.
class _Passos extends StatelessWidget {
  const _Passos(this.passos);

  final List<String> passos;

  @override
  Widget build(BuildContext context) {
    final estilo = AppTipografia.body.copyWith(color: AppCores.ink);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppEspacos.s4),
      decoration: BoxDecoration(
        color: AppCores.surfacePage,
        borderRadius: BorderRadius.circular(AppRaios.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (indice, passo) in passos.indexed) ...[
            if (indice > 0) const SizedBox(height: AppEspacos.s1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppForaDaEscala.numeroPasso,
                  child: Text(
                    '${indice + 1}.',
                    textAlign: TextAlign.right,
                    style: estilo,
                  ),
                ),
                const SizedBox(width: AppEspacos.s1),
                Expanded(child: Text(passo, style: estilo)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
