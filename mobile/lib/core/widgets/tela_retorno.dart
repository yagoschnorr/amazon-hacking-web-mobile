import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_cores.dart';
import '../../app/theme/app_medidas.dart';
import '../../app/theme/app_tipografia.dart';
import 'app_button.dart';

/// Tela de retorno (FeedbackScreen do design, em tela cheia): fundo surface,
/// padding de 48px 16px 16px, círculo de 112px com ícone de 64px,
/// sobretítulo, título, mensagem, conteúdo opcional e dois botões no pé.
class TelaRetorno extends StatelessWidget {
  const TelaRetorno({
    super.key,
    required this.icone,
    this.iconePreenchido = false,
    required this.corCirculo,
    required this.corIcone,
    required this.sobretitulo,
    required this.corSobretitulo,
    required this.titulo,
    required this.mensagem,
    this.conteudo,
    required this.rotuloPrincipal,
    this.iconePrincipal,
    required this.aoPrincipal,
    required this.rotuloSecundario,
    required this.aoSecundario,
  });

  final IconData icone;
  final bool iconePreenchido;
  final Color corCirculo;
  final Color corIcone;
  final String sobretitulo;
  final Color corSobretitulo;
  final String titulo;
  final String mensagem;

  /// Bloco abaixo da mensagem, como a lista de passos da permissão.
  final Widget? conteudo;

  final String rotuloPrincipal;
  final IconData? iconePrincipal;
  final VoidCallback aoPrincipal;
  final String rotuloSecundario;
  final VoidCallback aoSecundario;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppCores.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppEspacos.s4,
              AppEspacos.s12,
              AppEspacos.s4,
              AppEspacos.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: AppForaDaEscala.circuloRetorno,
                            height: AppForaDaEscala.circuloRetorno,
                            decoration: BoxDecoration(
                              color: corCirculo,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icone,
                              fill: iconePreenchido ? 1 : 0,
                              size: AppIcones.retorno,
                              color: corIcone,
                            ),
                          ),
                          const SizedBox(height: AppEspacos.s6),
                          Text(
                            sobretitulo,
                            textAlign: TextAlign.center,
                            style: AppTipografia.sobretituloRetorno.copyWith(
                              color: corSobretitulo,
                            ),
                          ),
                          const SizedBox(height: AppEspacos.s4),
                          Text(
                            titulo,
                            textAlign: TextAlign.center,
                            style: AppTipografia.tituloRetorno.copyWith(
                              color: AppCores.ink,
                            ),
                          ),
                          const SizedBox(height: AppEspacos.s4),
                          Text(
                            mensagem,
                            textAlign: TextAlign.center,
                            style: AppTipografia.bodyLg.copyWith(
                              color: AppCores.inkMuted,
                            ),
                          ),
                          if (conteudo case final conteudo?) ...[
                            const SizedBox(height: AppEspacos.s6),
                            conteudo,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                AppButton(
                  label: rotuloPrincipal,
                  icon: iconePrincipal,
                  onPressed: aoPrincipal,
                ),
                const SizedBox(height: AppEspacos.s3),
                AppButton(
                  label: rotuloSecundario,
                  onPressed: aoSecundario,
                  variante: AppButtonVariante.tonal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
