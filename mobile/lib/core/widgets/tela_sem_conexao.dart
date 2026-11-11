import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';
import 'app_button.dart';
import 'rodape_fixo.dart';
import 'topo_app.dart';

/// Tela "Sem conexão" (docs/design/mobile/13-erro-de-conexao.png), com o
/// botão "Tentar de novo" no rodapé fixo.
class TelaSemConexao extends StatelessWidget {
  const TelaSemConexao({super.key, required this.aoTentarDeNovo});

  final VoidCallback aoTentarDeNovo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TopoApp(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppEspacos.s6),
                child: Column(
                  children: [
                    Container(
                      width: AppForaDaEscala.circuloEstado,
                      height: AppForaDaEscala.circuloEstado,
                      decoration: const BoxDecoration(
                        color: AppCores.errorSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Symbols.wifi_off_rounded,
                        size: AppIcones.estado,
                        color: AppCores.error,
                      ),
                    ),
                    const SizedBox(height: AppEspacos.s6),
                    Text(
                      'SEM CONEXÃO',
                      textAlign: TextAlign.center,
                      style: AppTipografia.overline.copyWith(
                        color: AppCores.error,
                      ),
                    ),
                    const SizedBox(height: AppEspacos.s4),
                    Text(
                      'Não foi possível carregar os estandes.',
                      textAlign: TextAlign.center,
                      style: AppTipografia.title.copyWith(color: AppCores.ink),
                    ),
                    const SizedBox(height: AppEspacos.s4),
                    Text(
                      'Confira o Wi-Fi ou os dados móveis e tente de novo. '
                      'Suas visitas já registradas continuam salvas.',
                      textAlign: TextAlign.center,
                      style: AppTipografia.bodyLg.copyWith(
                        color: AppCores.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          RodapeFixo(
            child: AppButton(
              label: 'Tentar de novo',
              icon: Symbols.refresh_rounded,
              onPressed: aoTentarDeNovo,
            ),
          ),
        ],
      ),
    );
  }
}
