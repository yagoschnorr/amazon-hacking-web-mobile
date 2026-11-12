import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';

/// Topo do app: faixa primary-deep com cantos inferiores radius-xl,
/// sobretítulo "AMAZON HACKING", o nome do app e uma linha opcional
/// (progresso ou aviso). Ocupa também a área da barra de status.
class TopoApp extends StatelessWidget {
  const TopoApp({super.key, this.linha});

  /// Linha abaixo do nome, em 15/22 e on-primary.
  final Widget? linha;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppCores.primaryDeep,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRaios.xl),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspacos.s4,
              AppForaDaEscala.topoApp,
              AppEspacos.s4,
              AppEspacos.s5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'AMAZON HACKING',
                  style: AppTipografia.overline.copyWith(
                    color: AppCores.onPrimary,
                  ),
                ),
                const SizedBox(height: AppEspacos.s1),
                Text(
                  'Circuito de Descobertas',
                  style: AppTipografia.title.copyWith(
                    color: AppCores.onPrimary,
                  ),
                ),
                if (linha case final linha?) ...[
                  const SizedBox(height: AppEspacos.s2),
                  DefaultTextStyle(
                    style: AppTipografia.body.copyWith(
                      color: AppCores.onPrimary,
                    ),
                    child: IconTheme.merge(
                      data: const IconThemeData(color: AppCores.onPrimary),
                      child: linha,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
