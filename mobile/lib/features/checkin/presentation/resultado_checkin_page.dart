import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../app/theme/app_cores.dart';
import '../../../core/widgets/tela_retorno.dart';
import '../../estandes/presentation/estande_card.dart';
import '../../missao/data/missao.dart';
import '../data/checkin_service.dart';

/// O que o visitante escolheu na tela de retorno. Fechar pelo voltar do
/// sistema equivale a `lerOutro`.
enum AcaoRetorno { lerOutro, voltarAoInicio, tentarDeNovo }

/// Mensagem de progresso do retorno de sucesso.
String mensagemFaltam(int faltam) => switch (faltam) {
  0 => 'Você completou o circuito.',
  1 => 'Falta 1 estande para completar o circuito.',
  _ => 'Faltam $faltam estandes para completar o circuito.',
};

/// Retorno do check-in (docs/design/mobile/08 a 11). Fecha com a
/// [AcaoRetorno] escolhida. O check-in que conclui a missão usa o tipo
/// `missao` do FeedbackScreen (missao-soft e missao-ink).
class ResultadoCheckinPage extends StatelessWidget {
  const ResultadoCheckinPage({super.key, required this.resultado});

  final ResultadoCheckin resultado;

  @override
  Widget build(BuildContext context) {
    void fechar(AcaoRetorno acao) => Navigator.of(context).pop(acao);
    final estande = resultado.estande;
    final detalhe = estande == null
        ? null
        : '${estande.nome} · ${estande.localizacao}';

    final missaoConcluidaCom = resultado.missaoConcluidaCom;

    return switch (resultado.tipo) {
      TipoResultado.sucesso when missaoConcluidaCom != null => TelaRetorno(
        icone: Symbols.bolt_rounded,
        iconePreenchido: true,
        corCirculo: AppCores.missaoSoft,
        corIcone: AppCores.missaoInk,
        sobretitulo: 'MISSÃO CONCLUÍDA',
        corSobretitulo: AppCores.missaoInk,
        titulo: 'Parabéns, você completou a missão!',
        mensagem: mensagemConcluida(missaoConcluidaCom),
        detalhe: detalhe,
        rotuloPrincipal: 'Ler outro QR code',
        iconePrincipal: Symbols.qr_code_scanner_rounded,
        aoPrincipal: () => fechar(AcaoRetorno.lerOutro),
        rotuloSecundario: 'Ver estandes',
        aoSecundario: () => fechar(AcaoRetorno.voltarAoInicio),
      ),
      TipoResultado.sucesso => TelaRetorno(
        icone: Symbols.check_circle_rounded,
        iconePreenchido: true,
        corCirculo: AppCores.successSoft,
        corIcone: AppCores.success,
        sobretitulo: 'CHECK-IN FEITO',
        corSobretitulo: AppCores.success,
        titulo: 'Visita registrada.',
        mensagem: switch (resultado.faltam) {
          final faltam? => mensagemFaltam(faltam),
          null => null,
        },
        detalhe: detalhe,
        rotuloPrincipal: 'Ler outro QR code',
        iconePrincipal: Symbols.qr_code_scanner_rounded,
        aoPrincipal: () => fechar(AcaoRetorno.lerOutro),
        rotuloSecundario: 'Ver estandes',
        aoSecundario: () => fechar(AcaoRetorno.voltarAoInicio),
      ),
      TipoResultado.qrInvalido => TelaRetorno(
        icone: Symbols.qr_code_scanner_rounded,
        corCirculo: AppCores.errorSoft,
        corIcone: AppCores.error,
        sobretitulo: 'NÃO RECONHECIDO',
        corSobretitulo: AppCores.error,
        titulo: 'QR code inválido.',
        mensagem:
            'Este código não é de um estande do Circuito de Descobertas. '
            'Aponte para o QR code impresso no estande.',
        rotuloPrincipal: 'Ler de novo',
        iconePrincipal: Symbols.qr_code_scanner_rounded,
        aoPrincipal: () => fechar(AcaoRetorno.lerOutro),
        rotuloSecundario: 'Voltar ao início',
        aoSecundario: () => fechar(AcaoRetorno.voltarAoInicio),
      ),
      TipoResultado.estandeInativo => TelaRetorno(
        icone: Symbols.pause_circle_rounded,
        iconePreenchido: true,
        corCirculo: AppCores.surfaceSunken,
        corIcone: AppCores.inkMuted,
        sobretitulo: 'ESTANDE INATIVO',
        corSobretitulo: AppCores.inkMuted,
        titulo: 'Este estande não está ativo.',
        mensagem:
            'A visita não pode ser registrada agora. Fale com a equipe do '
            'estande ou tente mais tarde.',
        detalhe: detalhe,
        rotuloPrincipal: 'Ver estandes ativos',
        aoPrincipal: () => fechar(AcaoRetorno.voltarAoInicio),
        rotuloSecundario: 'Ler outro QR code',
        aoSecundario: () => fechar(AcaoRetorno.lerOutro),
      ),
      TipoResultado.jaRegistrado => TelaRetorno(
        icone: Symbols.history_rounded,
        iconePreenchido: true,
        corCirculo: AppCores.warningSoft,
        corIcone: AppCores.warning,
        sobretitulo: 'JÁ REGISTRADO',
        corSobretitulo: AppCores.warning,
        titulo: 'Você já registrou esta visita.',
        mensagem: switch (resultado.registradoEm) {
          final horario? =>
            'Sua visita foi registrada às ${horaVisita(horario)} e conta '
                'uma vez só.',
          null => 'Sua visita já foi registrada e conta uma vez só.',
        },
        detalhe: detalhe,
        rotuloPrincipal: 'Ver estandes',
        aoPrincipal: () => fechar(AcaoRetorno.voltarAoInicio),
        rotuloSecundario: 'Ler outro QR code',
        aoSecundario: () => fechar(AcaoRetorno.lerOutro),
      ),
      TipoResultado.erro => TelaRetorno(
        icone: Symbols.error_rounded,
        iconePreenchido: true,
        corCirculo: AppCores.errorSoft,
        corIcone: AppCores.error,
        sobretitulo: 'NÃO REGISTRADO',
        corSobretitulo: AppCores.error,
        titulo: 'Não foi possível registrar.',
        mensagem: 'Confira a conexão e tente de novo.',
        rotuloPrincipal: 'Tentar de novo',
        iconePrincipal: Symbols.refresh_rounded,
        aoPrincipal: () => fechar(AcaoRetorno.tentarDeNovo),
        rotuloSecundario: 'Voltar ao início',
        aoSecundario: () => fechar(AcaoRetorno.voltarAoInicio),
      ),
    };
  }
}
