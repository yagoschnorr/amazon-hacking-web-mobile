import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../app/theme/app_medidas.dart';
import '../../../app/theme/app_tipografia.dart';
import '../../../core/widgets/abertura.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/rodape_fixo.dart';
import '../../../core/widgets/tela_estado.dart';
import '../../../core/widgets/tela_sem_conexao.dart';
import '../../../core/widgets/topo_app.dart';
import '../../checkin/data/checkin_repository.dart';
import '../../checkin/presentation/scanner_page.dart';
import '../data/estande.dart';
import '../data/estande_repository.dart';
import 'estande_card.dart';
import 'estande_detalhe_page.dart';

/// Início (docs/design/mobile/02, 12 e 13): estandes ativos em tempo real,
/// com os já visitados marcados.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.visitanteId});

  final String visitanteId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _estandeRepository = EstandeRepository();
  final _checkinRepository = CheckinRepository();
  late Stream<List<Estande>> _estandes;
  late Stream<Map<String, DateTime?>> _visitas;

  @override
  void initState() {
    super.initState();
    _assinar();
  }

  void _assinar() {
    _estandes = _estandeRepository.estandesAtivos();
    _visitas = _checkinRepository.visitas(widget.visitanteId);
  }

  void _recarregar() => setState(_assinar);

  void _abrirDetalhe(Estande estande) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EstandeDetalhePage(
          estande: estande,
          visitas: _checkinRepository.visitas(widget.visitanteId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Estande>>(
      stream: _estandes,
      builder: (context, estandes) {
        if (estandes.hasError) {
          return TelaSemConexao(aoTentarDeNovo: _recarregar);
        }
        final lista = estandes.data;
        if (lista == null) return const Abertura();
        if (lista.isEmpty) return ListaVazia(aoAtualizar: _recarregar);

        return StreamBuilder<Map<String, DateTime?>>(
          stream: _visitas,
          builder: (context, visitas) {
            // Sem os check-ins (erro de leitura), a lista aparece sem marcas.
            if (!visitas.hasData && !visitas.hasError) return const Abertura();
            return ListaEstandes(
              estandes: lista,
              visitas: visitas.data ?? const {},
              aoTocar: _abrirDetalhe,
            );
          },
        );
      },
    );
  }
}

/// Início com a lista (docs/design/mobile/02-inicio-missao-desligada.png).
class ListaEstandes extends StatelessWidget {
  const ListaEstandes({
    super.key,
    required this.estandes,
    required this.visitas,
    required this.aoTocar,
  });

  final List<Estande> estandes;
  final Map<String, DateTime?> visitas;
  final ValueChanged<Estande> aoTocar;

  @override
  Widget build(BuildContext context) {
    final total = estandes.length;
    final visitados = estandes.where((e) => visitas.containsKey(e.id)).length;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopoApp(
            linha: Row(
              children: [
                const Icon(
                  Symbols.check_circle_rounded,
                  fill: 1,
                  size: AppIcones.sm,
                ),
                const SizedBox(width: AppForaDaEscala.iconeTexto),
                Expanded(
                  child: Text(
                    '$visitados de $total '
                    '${total == 1 ? 'estande visitado' : 'estandes visitados'}',
                    style: const TextStyle(fontFeatures: AppTipografia.tabular),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppEspacos.s4,
                AppEspacos.s5,
                AppEspacos.s4,
                AppEspacos.s4,
              ),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: Text(
                        'Estandes',
                        style: AppTipografia.subtitle.copyWith(
                          color: AppCores.ink,
                        ),
                      ),
                    ),
                    Text(
                      total == 1 ? '1 aberto agora' : '$total abertos agora',
                      style: AppTipografia.caption.copyWith(
                        color: AppCores.inkMuted,
                        fontFeatures: AppTipografia.tabular,
                      ),
                    ),
                  ],
                ),
                for (final estande in estandes) ...[
                  const SizedBox(height: AppEspacos.s3),
                  EstandeCard(
                    estande: estande,
                    visitado: visitas.containsKey(estande.id),
                    visitadoEm: visitas[estande.id],
                    aoTocar: () => aoTocar(estande),
                  ),
                ],
              ],
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
  }
}

/// "Nenhum estande ativo no momento" (docs/design/mobile/12).
class ListaVazia extends StatelessWidget {
  const ListaVazia({super.key, required this.aoAtualizar});

  final VoidCallback aoAtualizar;

  @override
  Widget build(BuildContext context) {
    return TelaEstado(
      linhaTopo: const Text('Nenhum estande aberto agora'),
      icone: Symbols.storefront_rounded,
      corCirculo: AppCores.primarySoft,
      corIcone: AppCores.primaryPressed,
      titulo: 'Nenhum estande ativo no momento.',
      mensagem:
          'Os estandes aparecem aqui assim que a organização abrir a '
          'visitação. Volte em alguns minutos.',
      rotuloBotao: 'Atualizar lista',
      iconeBotao: Symbols.refresh_rounded,
      aoPressionar: aoAtualizar,
    );
  }
}
