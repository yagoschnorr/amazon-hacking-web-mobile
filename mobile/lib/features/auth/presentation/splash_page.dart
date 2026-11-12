import 'package:flutter/material.dart';

import '../../../core/widgets/abertura.dart';
import '../../../core/widgets/tela_sem_conexao.dart';

/// Abertura do app (docs/design/mobile/01-abertura.png). Fica na tela
/// enquanto a sessão anônima é criada; se falhar, mostra a tela sem conexão.
class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.garantirSessao,
    required this.destino,
  });

  final Future<void> Function() garantirSessao;

  /// Tela aberta depois que a sessão existe.
  final WidgetBuilder destino;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var _falhou = false;

  @override
  void initState() {
    super.initState();
    _iniciarSessao();
  }

  Future<void> _iniciarSessao() async {
    try {
      await widget.garantirSessao();
    } catch (erro) {
      debugPrint('Falha ao criar a sessão anônima: $erro');
      if (mounted) setState(() => _falhou = true);
      return;
    }
    if (!mounted) return;
    // Sem animação: o destino continua mostrando a abertura até ter dados.
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (contexto, _, _) => widget.destino(contexto),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  void _tentarDeNovo() {
    setState(() => _falhou = false);
    _iniciarSessao();
  }

  @override
  Widget build(BuildContext context) {
    if (_falhou) return TelaSemConexao(aoTentarDeNovo: _tentarDeNovo);

    return const Abertura();
  }
}
