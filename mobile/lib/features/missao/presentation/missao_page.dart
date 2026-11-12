import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/rodape_fixo.dart';
import '../../checkin/presentation/scanner_page.dart';
import '../../estandes/data/estande.dart';
import '../../estandes/presentation/estande_card.dart';
import '../data/missao.dart';
import '../data/missao_controller.dart';

/// Aviso no início quando a missão acaba com a tela da missão aberta.
void avisarMissaoEncerrada(ScaffoldMessengerState mensageiro) {
  mensageiro.showSnackBar(
    SnackBar(
      backgroundColor: AppCores.surfaceInverse,
      content: Row(
        children: [
          const Icon(
            Symbols.bolt_rounded,
            fill: 1,
            size: AppIcones.sm,
            color: AppCores.missao,
          ),
          const SizedBox(width: AppEspacos.s2),
          Text(
            'Missão encerrada',
            style: AppTipografia.body.copyWith(color: AppCores.onInverse),
          ),
        ],
      ),
    ),
  );
}

/// Tela da missão (docs/design/mobile/04-missao-surpresa.png): estandes
/// participantes e quais já foram visitados. Fecha sozinha, com o aviso
/// "Missão encerrada", quando a missão é desligada ou acaba o prazo.
class MissaoPage extends StatefulWidget {
  const MissaoPage({
    super.key,
    required this.missao,
    required this.estandes,
    required this.estandesIniciais,
    required this.visitas,
    required this.visitasIniciais,
    required this.aoAbrirEstande,
  });

  final MissaoController missao;

  /// Estandes ativos (EstandeRepository.estandesAtivos).
  final Stream<List<Estande>> estandes;

  /// Check-ins do visitante (CheckinRepository.visitas).
  final Stream<Map<String, DateTime?>> visitas;

  /// O que o início já mostrava: evita tela vazia até o primeiro evento e
  /// segura a lista se a leitura falhar.
  final List<Estande> estandesIniciais;
  final Map<String, DateTime?> visitasIniciais;

  final ValueChanged<Estande> aoAbrirEstande;

  @override
  State<MissaoPage> createState() => _MissaoPageState();
}

class _MissaoPageState extends State<MissaoPage> {
  var _encerrada = false;

  void _encerrar() {
    if (_encerrada || !mounted) return;
    _encerrada = true;
    final rota = ModalRoute.of(context);
    final navegador = Navigator.of(context);
    avisarMissaoEncerrada(ScaffoldMessenger.of(context));
    if (rota == null) return;
    // Com o leitor ou o detalhe por cima, tira só esta tela da pilha.
    if (rota.isCurrent) {
      navegador.pop();
    } else {
      navegador.removeRoute(rota);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.missao,
      builder: (context, _) => StreamBuilder<List<Estande>>(
        stream: widget.estandes,
        initialData: widget.estandesIniciais,
        builder: (context, estandes) => StreamBuilder<Map<String, DateTime?>>(
          stream: widget.visitas,
          initialData: widget.visitasIniciais,
          builder: (context, visitas) {
            final resumo = ResumoMissao.calcular(
              widget.missao.missao,
              estandes.data ?? widget.estandesIniciais,
              widget.missao.agora,
            );
            if (resumo == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _encerrar());
              return const Scaffold();
            }
            return _Conteudo(
              resumo: resumo,
              visitas: visitas.data ?? widget.visitasIniciais,
              aoAbrirEstande: widget.aoAbrirEstande,
              aoLerQrCode: () => abrirLeitor(context, missao: widget.missao),
            );
          },
        ),
      ),
    );
  }
}

class _Conteudo extends StatelessWidget {
  const _Conteudo({
    required this.resumo,
    required this.visitas,
    required this.aoAbrirEstande,
    required this.aoLerQrCode,
  });

  final ResumoMissao resumo;
  final Map<String, DateTime?> visitas;
  final ValueChanged<Estande> aoAbrirEstande;
  final VoidCallback aoLerQrCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Topo(resumo: resumo, visitas: visitas),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppEspacos.s4,
                AppEspacos.s5,
                AppEspacos.s4,
                AppEspacos.s4,
              ),
              children: [
                Text(
                  'Estandes participantes',
                  style: AppTipografia.subtitle.copyWith(color: AppCores.ink),
                ),
                for (final estande in resumo.ordenar(
                  resumo.participantes,
                  visitas,
                )) ...[
                  const SizedBox(height: AppEspacos.s3),
                  EstandeCard(
                    estande: estande,
                    visitado: visitas.containsKey(estande.id),
                    visitadoEm: visitas[estande.id],
                    destaque: DestaqueMissao.faltaVisitar,
                    aoTocar: () => aoAbrirEstande(estande),
                  ),
                ],
              ],
            ),
          ),
          RodapeFixo(
            child: AppButton(
              label: 'Ler QR code',
              icon: Symbols.qr_code_scanner_rounded,
              onPressed: aoLerQrCode,
            ),
          ),
        ],
      ),
    );
  }
}

/// Topo da missão: missao, cantos inferiores xl, shadow-md; título 28/34,
/// chip de tempo e barra de progresso de 8px.
class _Topo extends StatelessWidget {
  const _Topo({required this.resumo, required this.visitas});

  final ResumoMissao resumo;
  final Map<String, DateTime?> visitas;

  @override
  Widget build(BuildContext context) {
    final total = resumo.participantes.length;
    final visitados = total - resumo.faltando(visitas).length;
    final tempo = resumo.tempoPara(visitas);
    final String mensagem;
    if (resumo.concluida(visitas)) {
      mensagem = mensagemConcluida(total);
    } else if (tempo == null) {
      mensagem =
          'Leia o QR code dos estandes participantes. '
          'Cada visita conta uma vez.';
    } else {
      mensagem =
          'Leia o QR code dos estandes participantes antes que o tempo '
          'acabe. Cada visita conta uma vez.';
    }

    final progresso = Text(
      '$visitados de $total ${total == 1 ? 'visitado' : 'visitados'}',
      style: AppTipografia.label.copyWith(
        color: AppCores.onMissao,
        fontFeatures: AppTipografia.tabular,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        decoration: const BoxDecoration(
          color: AppCores.missao,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppRaios.xl),
          ),
          boxShadow: AppSombras.md,
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspacos.s2,
              AppEspacos.s3,
              AppEspacos.s4,
              AppEspacos.s6,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      tooltip: 'Voltar',
                      icon: const Icon(Symbols.arrow_back_rounded),
                      iconSize: AppIcones.botao,
                      color: AppCores.onMissao,
                      constraints: const BoxConstraints.tightFor(
                        width: AppAlturas.touchMin,
                        height: AppAlturas.touchMin,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(width: AppEspacos.s1),
                    const Icon(
                      Symbols.bolt_rounded,
                      fill: 1,
                      size: AppIcones.sm,
                      color: AppCores.onMissao,
                    ),
                    const SizedBox(width: AppForaDaEscala.iconeTexto),
                    Text(
                      'MISSÃO SURPRESA',
                      style: AppTipografia.sobretituloMissao.copyWith(
                        color: AppCores.onMissao,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppEspacos.s3),
                Padding(
                  padding: const EdgeInsets.only(left: AppEspacos.s2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        resumo.tituloPara(visitas),
                        style: AppTipografia.tituloMissao.copyWith(
                          color: AppCores.onMissao,
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s3),
                      Text(
                        mensagem,
                        style: AppTipografia.bodyLg.copyWith(
                          color: AppCores.onMissao,
                        ),
                      ),
                      const SizedBox(height: AppEspacos.s4),
                      Row(
                        children: [
                          if (tempo != null) ...[
                            _ChipTempo(tempo),
                            const Spacer(),
                          ],
                          progresso,
                        ],
                      ),
                      const SizedBox(height: AppEspacos.s3),
                      _BarraProgresso(total == 0 ? 0 : visitados / total),
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

/// Chip de tempo: ink com texto em missao, 36px.
class _ChipTempo extends StatelessWidget {
  const _ChipTempo(this.tempo);

  final String tempo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppAlturas.controlSm,
      padding: const EdgeInsets.only(
        left: AppForaDaEscala.etiqueta,
        right: AppForaDaEscala.etiqueta + AppEspacos.s1,
      ),
      decoration: const ShapeDecoration(
        color: AppCores.ink,
        shape: StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Symbols.schedule_rounded,
            size: AppIcones.sm,
            color: AppCores.missao,
          ),
          const SizedBox(width: AppForaDaEscala.iconeTexto),
          Text(
            tempo,
            style: AppTipografia.tempoMissao.copyWith(color: AppCores.missao),
          ),
        ],
      ),
    );
  }
}

/// Barra de 8px: trilho surface e preenchimento ink.
class _BarraProgresso extends StatelessWidget {
  const _BarraProgresso(this.fracao);

  final double fracao;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRaios.full),
      child: Container(
        height: AppForaDaEscala.barraProgresso,
        color: AppCores.surface,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: fracao,
          heightFactor: 1,
          child: const ColoredBox(color: AppCores.ink),
        ),
      ),
    );
  }
}
