import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../data/estande.dart';

/// Avatar do estande: iniciais em primary-pressed sobre primary-soft, ou
/// `check` em success sobre success-soft quando já foi visitado.
/// 52px no cartão e 64px (iniciais de 22px) no detalhe.
class AvatarEstande extends StatelessWidget {
  const AvatarEstande({
    super.key,
    required this.estande,
    this.visitado = false,
    this.grande = false,
  });

  final Estande estande;
  final bool visitado;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final lado = grande ? AppForaDaEscala.avatarGrande : AppForaDaEscala.avatar;
    return Container(
      width: lado,
      height: lado,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: visitado ? AppCores.successSoft : AppCores.primarySoft,
        borderRadius: BorderRadius.circular(AppRaios.md),
      ),
      child: visitado
          ? const Icon(
              Symbols.check_rounded,
              size: AppIcones.lg,
              color: AppCores.success,
            )
          : Text(
              estande.iniciais,
              style:
                  (grande
                          ? AppTipografia.iniciaisGrande
                          : AppTipografia.iniciais)
                      .copyWith(color: AppCores.primaryPressed),
            ),
    );
  }
}
