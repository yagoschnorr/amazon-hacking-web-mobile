import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';

/// Chamada da missão no início (MissionBanner,
/// docs/design/mobile/03-inicio-missao-ligada.png).
class MissaoBanner extends StatelessWidget {
  const MissaoBanner({
    super.key,
    required this.titulo,
    required this.mensagem,
    this.tempo,
    required this.aoVerMissao,
  });

  final String titulo;
  final String mensagem;

  /// "Faltam 25 min"; nulo para missão sem prazo.
  final String? tempo;

  final VoidCallback aoVerMissao;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppEspacos.s4),
      decoration: BoxDecoration(
        color: AppCores.missao,
        borderRadius: BorderRadius.circular(AppRaios.lg),
        boxShadow: AppSombras.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppForaDaEscala.circuloBanner,
                height: AppForaDaEscala.circuloBanner,
                decoration: const BoxDecoration(
                  color: AppCores.ink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Symbols.bolt_rounded,
                  fill: 1,
                  size: AppIcones.banner,
                  color: AppCores.missao,
                ),
              ),
              const SizedBox(width: AppEspacos.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MISSÃO SURPRESA',
                      style: AppTipografia.sobretituloMissao.copyWith(
                        color: AppCores.onMissao,
                      ),
                    ),
                    Text(
                      titulo,
                      style: AppTipografia.tituloBanner.copyWith(
                        color: AppCores.onMissao,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppEspacos.s3),
          Text(
            mensagem,
            style: AppTipografia.bodyLg.copyWith(color: AppCores.onMissao),
          ),
          const SizedBox(height: AppEspacos.s3),
          Row(
            children: [
              if (tempo case final tempo?) ...[
                const Icon(
                  Symbols.schedule_rounded,
                  size: AppIcones.sm,
                  color: AppCores.onMissao,
                ),
                const SizedBox(width: AppForaDaEscala.iconeTexto),
                Expanded(
                  child: Text(
                    tempo,
                    style: AppTipografia.tempoMissao.copyWith(
                      color: AppCores.onMissao,
                    ),
                  ),
                ),
                const SizedBox(width: AppEspacos.s3),
              ] else
                const Spacer(),
              FilledButton.icon(
                onPressed: aoVerMissao,
                icon: const Icon(Symbols.arrow_forward_rounded),
                label: const Text('Ver missão'),
                iconAlignment: IconAlignment.end,
                style: FilledButton.styleFrom(
                  backgroundColor: AppCores.ink,
                  foregroundColor: AppCores.surface,
                  minimumSize: const Size(0, AppAlturas.touchMin),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppEspacos.s5,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: AppTipografia.label,
                  iconSize: AppIcones.md,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
