import 'package:flutter/material.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';
import 'app_button.dart';
import 'rodape_fixo.dart';
import 'topo_app.dart';

/// Estado de tela inteira do início: topo do app, círculo com ícone,
/// sobretítulo opcional, título, mensagem e um AppButton no rodapé fixo.
/// Usado em "Nenhum estande ativo" (12) e "Sem conexão" (13).
class TelaEstado extends StatelessWidget {
  const TelaEstado({
    super.key,
    this.linhaTopo,
    required this.icone,
    required this.corCirculo,
    required this.corIcone,
    this.sobretitulo,
    required this.titulo,
    required this.mensagem,
    required this.rotuloBotao,
    required this.iconeBotao,
    required this.aoPressionar,
  });

  final Widget? linhaTopo;
  final IconData icone;
  final Color corCirculo;

  /// Cor do ícone e do sobretítulo.
  final Color corIcone;
  final String? sobretitulo;
  final String titulo;
  final String mensagem;
  final String rotuloBotao;
  final IconData iconeBotao;
  final VoidCallback aoPressionar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopoApp(linha: linhaTopo),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppEspacos.s6),
                child: Column(
                  children: [
                    Container(
                      width: AppForaDaEscala.circuloEstado,
                      height: AppForaDaEscala.circuloEstado,
                      decoration: BoxDecoration(
                        color: corCirculo,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icone,
                        size: AppIcones.estado,
                        color: corIcone,
                      ),
                    ),
                    const SizedBox(height: AppEspacos.s6),
                    if (sobretitulo case final sobretitulo?) ...[
                      Text(
                        sobretitulo,
                        textAlign: TextAlign.center,
                        style: AppTipografia.overline.copyWith(color: corIcone),
                      ),
                      const SizedBox(height: AppEspacos.s4),
                    ],
                    Text(
                      titulo,
                      textAlign: TextAlign.center,
                      style: AppTipografia.title.copyWith(color: AppCores.ink),
                    ),
                    const SizedBox(height: AppEspacos.s4),
                    Text(
                      mensagem,
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
              label: rotuloBotao,
              icon: iconeBotao,
              onPressed: aoPressionar,
            ),
          ),
        ],
      ),
    );
  }
}
