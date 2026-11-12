import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/rodape_fixo.dart';
import '../../checkin/presentation/scanner_page.dart';
import '../data/estande.dart';
import 'avatar_estande.dart';
import 'estande_card.dart';

/// Detalhe do estande (docs/design/mobile/05-detalhe-do-estande.png).
class EstandeDetalhePage extends StatelessWidget {
  const EstandeDetalhePage({
    super.key,
    required this.estande,
    required this.visitas,
  });

  final Estande estande;

  /// Check-ins do visitante (CheckinRepository.visitas).
  final Stream<Map<String, DateTime?>> visitas;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, DateTime?>>(
      stream: visitas,
      builder: (context, visitas) {
        final mapa = visitas.data ?? const <String, DateTime?>{};
        final visitado = mapa.containsKey(estande.id);
        final horario = mapa[estande.id];

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Topo(estande: estande),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppEspacos.s4,
                    AppEspacos.s6,
                    AppEspacos.s4,
                    AppEspacos.s6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOBRE O PROJETO',
                        style: AppTipografia.overline.copyWith(
                          color: AppCores.inkMuted,
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s2),
                      Text(
                        estande.descricao,
                        style: AppTipografia.descricaoDetalhe.copyWith(
                          color: AppCores.ink,
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s5),
                      _CartaoInfo(
                        estande: estande,
                        visitado: visitado,
                        horario: horario,
                      ),
                      const SizedBox(height: AppEspacos.s5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Symbols.qr_code_2_rounded,
                            size: AppIcones.botao,
                            color: AppCores.inkMuted,
                          ),
                          const SizedBox(width: AppForaDaEscala.iconeInstrucao),
                          Expanded(
                            child: Text(
                              'Procure o QR code impresso no estande e leia '
                              'com o botão abaixo para registrar sua visita.',
                              style: AppTipografia.bodyLg.copyWith(
                                color: AppCores.inkMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RodapeFixo(
                child: AppButton(
                  label: 'Ler QR code',
                  icon: Symbols.qr_code_scanner_rounded,
                  onPressed: () => abrirLeitor(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Topo do detalhe: voltar + "ESTANDE", avatar de 64px e o nome em title-lg.
class _Topo extends StatelessWidget {
  const _Topo({required this.estande});

  final Estande estande;

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
            // O botão voltar tem 48px de área de toque: o ícone de 24px
            // fica alinhado à margem de 16px e ao padding superior de 28px.
            padding: const EdgeInsets.fromLTRB(
              AppEspacos.s2,
              AppEspacos.s3,
              AppEspacos.s4,
              AppForaDaEscala.topoApp,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Voltar',
                      icon: const Icon(Symbols.arrow_back_rounded),
                      iconSize: AppIcones.botao,
                      color: AppCores.onPrimary,
                      constraints: const BoxConstraints.tightFor(
                        width: AppAlturas.touchMin,
                        height: AppAlturas.touchMin,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: AppEspacos.s1),
                    Text(
                      'ESTANDE',
                      style: AppTipografia.overline.copyWith(
                        color: AppCores.onPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspacos.s4),
                Padding(
                  padding: const EdgeInsets.only(left: AppEspacos.s2),
                  child: Row(
                    children: [
                      AvatarEstande(estande: estande, grande: true),
                      const SizedBox(width: AppEspacos.s4),
                      Expanded(
                        child: Text(
                          estande.nome,
                          style: AppTipografia.titleLg.copyWith(
                            color: AppCores.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cartão com a localização e a situação da visita.
class _CartaoInfo extends StatelessWidget {
  const _CartaoInfo({
    required this.estande,
    required this.visitado,
    required this.horario,
  });

  final Estande estande;
  final bool visitado;
  final DateTime? horario;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppEspacos.s4),
      decoration: BoxDecoration(
        color: AppCores.surface,
        border: Border.all(color: AppCores.line),
        borderRadius: BorderRadius.circular(AppRaios.lg),
        boxShadow: AppSombras.sm,
      ),
      child: Column(
        children: [
          _LinhaInfo(
            icone: Symbols.location_on_rounded,
            corCirculo: AppCores.primarySoft,
            corIcone: AppCores.primary,
            rotulo: 'Localização',
            valor: estande.localizacao,
          ),
          const SizedBox(height: AppEspacos.s4),
          const Divider(height: 1, thickness: 1, color: AppCores.line),
          const SizedBox(height: AppEspacos.s4),
          if (visitado)
            _LinhaInfo(
              icone: Symbols.check_circle_rounded,
              preenchido: true,
              corCirculo: AppCores.successSoft,
              corIcone: AppCores.success,
              rotulo: 'Sua visita',
              valor: horario == null
                  ? 'Registrada'
                  : 'Registrada às ${horaVisita(horario!)}',
            )
          else
            const _LinhaInfo(
              icone: Symbols.radio_button_unchecked_rounded,
              corCirculo: AppCores.surfaceSunken,
              corIcone: AppCores.inkMuted,
              rotulo: 'Sua visita',
              valor: 'Ainda não registrada',
            ),
        ],
      ),
    );
  }
}

class _LinhaInfo extends StatelessWidget {
  const _LinhaInfo({
    required this.icone,
    this.preenchido = false,
    required this.corCirculo,
    required this.corIcone,
    required this.rotulo,
    required this.valor,
  });

  final IconData icone;
  final bool preenchido;
  final Color corCirculo;
  final Color corIcone;
  final String rotulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppForaDaEscala.circuloInfo,
          height: AppForaDaEscala.circuloInfo,
          decoration: BoxDecoration(color: corCirculo, shape: BoxShape.circle),
          child: Icon(
            icone,
            fill: preenchido ? 1 : 0,
            size: AppIcones.md,
            color: corIcone,
          ),
        ),
        const SizedBox(width: AppEspacos.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rotulo,
                style: AppTipografia.caption.copyWith(color: AppCores.inkMuted),
              ),
              Text(
                valor,
                style: AppTipografia.valorInfo.copyWith(
                  color: AppCores.ink,
                  fontFeatures: AppTipografia.tabular,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
