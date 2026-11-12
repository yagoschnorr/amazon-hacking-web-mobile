import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../app/theme/app_cores.dart';
import 'tela_estado.dart';

/// Tela "Sem conexão" (docs/design/mobile/13-erro-de-conexao.png), com o
/// botão "Tentar de novo" no rodapé fixo.
class TelaSemConexao extends StatelessWidget {
  const TelaSemConexao({super.key, required this.aoTentarDeNovo});

  final VoidCallback aoTentarDeNovo;

  @override
  Widget build(BuildContext context) {
    return TelaEstado(
      icone: Symbols.wifi_off_rounded,
      corCirculo: AppCores.errorSoft,
      corIcone: AppCores.error,
      sobretitulo: 'SEM CONEXÃO',
      titulo: 'Não foi possível carregar os estandes.',
      mensagem:
          'Confira o Wi-Fi ou os dados móveis e tente de novo. '
          'Suas visitas já registradas continuam salvas.',
      rotuloBotao: 'Tentar de novo',
      iconeBotao: Symbols.refresh_rounded,
      aoPressionar: aoTentarDeNovo,
    );
  }
}
