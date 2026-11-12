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

/// Destaque da missão num cartão ainda não visitado: com a faixa
/// "Missão surpresa" no início ou com o chip "Falta visitar" na tela da missão.
enum DestaqueMissao { faixa, faltaVisitar }

/// Cartão do estande (StandCard, estados `normal`, `visitado` e `missao`).
class EstandeCard extends StatelessWidget {
  const EstandeCard({
    super.key,
    required this.estande,
    required this.visitado,
    this.visitadoEm,
    this.destaque,
    this.tempoMissao,
    required this.aoTocar,
  });

  final Estande estande;
  final bool visitado;
  final DateTime? visitadoEm;

  /// Ignorado quando o estande já foi visitado.
  final DestaqueMissao? destaque;

  /// "Faltam 25 min" na faixa; nulo para missão sem prazo.
  final String? tempoMissao;

  final VoidCallback aoTocar;

  @override
  Widget build(BuildContext context) {
    final destaque = visitado ? null : this.destaque;
    final missao = destaque != null;
    final borda = missao ? AppBordas.missao : AppBordas.fina;
    final forma = RoundedRectangleBorder(
      side: BorderSide(
        color: missao ? AppCores.missao : AppCores.line,
        width: borda,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(AppRaios.lg)),
    );
    final faixa = destaque == DestaqueMissao.faixa;

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: forma,
        shadows: missao ? AppSombras.md : AppSombras.sm,
      ),
      child: Material(
        color: missao ? AppCores.missaoSoft : AppCores.surface,
        shape: forma,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: aoTocar,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (faixa) _FaixaMissao(tempo: tempoMissao, borda: borda),
              Padding(
                // Borda + padding de 16px; abaixo da faixa, só os 16px.
                padding: EdgeInsets.fromLTRB(
                  AppEspacos.s4 + borda,
                  faixa ? AppEspacos.s4 : AppEspacos.s4 + borda,
                  AppEspacos.s4 + borda,
                  AppEspacos.s4 + borda,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: AvatarEstande(
                          estande: estande,
                          visitado: visitado,
                          missao: missao,
                        ),
                      ),
                      const SizedBox(width: AppEspacos.s3),
                      Expanded(child: _Textos(this, destaque)),
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Faixa amarela no topo do cartão: "⚡ MISSÃO SURPRESA" centralizado no
/// espaço livre e o tempo à direita.
class _FaixaMissao extends StatelessWidget {
  const _FaixaMissao({required this.tempo, required this.borda});

  final String? tempo;
  final double borda;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppForaDaEscala.faixaMissao + borda,
      color: AppCores.missao,
      // A borda de cima é pintada por cima da faixa.
      padding: EdgeInsets.fromLTRB(
        AppEspacos.s4 + borda,
        borda,
        AppEspacos.s4 + borda,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Symbols.bolt_rounded,
                  fill: 1,
                  size: AppIcones.sm,
                  color: AppCores.onMissao,
                ),
                const SizedBox(width: AppForaDaEscala.iconeTexto),
                Flexible(
                  child: Text(
                    'MISSÃO SURPRESA',
                    overflow: TextOverflow.ellipsis,
                    style: AppTipografia.faixaMissao.copyWith(
                      color: AppCores.onMissao,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (tempo case final tempo?) ...[
            const SizedBox(width: AppEspacos.s3),
            Text(
              tempo,
              style: AppTipografia.selo.copyWith(color: AppCores.onMissao),
            ),
          ],
        ],
      ),
    );
  }
}

class _Textos extends StatelessWidget {
  const _Textos(this.cartao, this.destaque);

  final EstandeCard cartao;
  final DestaqueMissao? destaque;

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
        ] else if (destaque == DestaqueMissao.faltaVisitar) ...[
          const SizedBox(height: AppEspacos.s2),
          const _ChipFaltaVisitar(),
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

/// Chip "Falta visitar": borda de 1,5px e texto em missao-ink.
class _ChipFaltaVisitar extends StatelessWidget {
  const _ChipFaltaVisitar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppForaDaEscala.alturaEtiqueta,
      padding: const EdgeInsets.only(
        left: AppForaDaEscala.iconeTexto,
        right: AppForaDaEscala.etiqueta,
      ),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(
          side: BorderSide(color: AppCores.missaoInk, width: AppBordas.media),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Symbols.radio_button_unchecked_rounded,
            size: AppIcones.xs,
            color: AppCores.missaoInk,
          ),
          const SizedBox(width: AppEspacos.s1),
          Text(
            'Falta visitar',
            style: AppTipografia.selo.copyWith(color: AppCores.missaoInk),
          ),
        ],
      ),
    );
  }
}
