import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../data/estande.dart';
import 'avatar_estande.dart';

/// Horário da visita no formato das telas: "10h42".
String horaVisita(DateTime horario) {
  final local = horario.toLocal();
  return '${local.hour}h${local.minute.toString().padLeft(2, '0')}';
}

/// Cartão do estande no início (StandCard, estados `normal` e `visitado`).
class EstandeCard extends StatelessWidget {
  const EstandeCard({
    super.key,
    required this.estande,
    required this.visitado,
    this.visitadoEm,
    required this.aoTocar,
  });

  final Estande estande;
  final bool visitado;
  final DateTime? visitadoEm;
  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    const forma = RoundedRectangleBorder(
      side: BorderSide(color: AppCores.line),
      borderRadius: BorderRadius.all(Radius.circular(AppRaios.lg)),
    );
    return DecoratedBox(
      decoration: const ShapeDecoration(shape: forma, shadows: AppSombras.sm),
      child: Material(
        color: AppCores.surface,
        shape: forma,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: aoTocar,
          child: Padding(
            // 1px da borda + padding de 16px
            padding: const EdgeInsets.all(AppEspacos.s4 + 1),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: AvatarEstande(estande: estande, visitado: visitado),
                  ),
                  const SizedBox(width: AppEspacos.s3),
                  Expanded(child: _Textos(this)),
                  const SizedBox(width: AppEspacos.s3),
                  const Icon(
                    Symbols.chevron_right_rounded,
                    size: AppIcones.md,
                    color: AppCores.inkMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Textos extends StatelessWidget {
  const _Textos(this.cartao);

  final EstandeCard cartao;

  @override
  Widget build(BuildContext context) {
    final estande = cartao.estande;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          estande.nome,
          style: AppTipografia.subtitle.copyWith(color: AppCores.ink),
        ),
        const SizedBox(height: AppForaDaEscala.textoCartao),
        Text(
          estande.descricao,
          style: AppTipografia.body.copyWith(color: AppCores.inkMuted),
        ),
        const SizedBox(height: AppForaDaEscala.textoCartao),
        Row(
          children: [
            const Icon(
              Symbols.location_on_rounded,
              size: AppIcones.xs,
              color: AppCores.inkMuted,
            ),
            const SizedBox(width: AppEspacos.s1),
            Expanded(
              child: Text(
                estande.localizacao,
                style: AppTipografia.caption.copyWith(color: AppCores.inkMuted),
              ),
            ),
          ],
        ),
        if (cartao.visitado) ...[
          const SizedBox(height: AppEspacos.s2),
          _SeloVisitado(cartao.visitadoEm),
        ],
      ],
    );
  }
}

/// Selo "Visitado às 10h42": success-soft, check_circle preenchido.
class _SeloVisitado extends StatelessWidget {
  const _SeloVisitado(this.horario);

  final DateTime? horario;

  @override
  Widget build(BuildContext context) {
    final texto = horario == null
        ? 'Visitado'
        : 'Visitado às ${horaVisita(horario!)}';
    return Container(
      height: AppForaDaEscala.alturaEtiqueta,
      padding: const EdgeInsets.only(
        left: AppForaDaEscala.iconeTexto,
        right: AppForaDaEscala.etiqueta,
      ),
      decoration: const ShapeDecoration(
        color: AppCores.successSoft,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Symbols.check_circle_rounded,
            fill: 1,
            size: AppIcones.sm,
            color: AppCores.success,
          ),
          const SizedBox(width: AppEspacos.s1),
          Text(
            texto,
            style: AppTipografia.selo.copyWith(color: AppCores.success),
          ),
        ],
      ),
    );
  }
}
