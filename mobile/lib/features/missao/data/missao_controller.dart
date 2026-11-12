import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/remote_config.dart';
import 'missao.dart';

/// Estado da missão surpresa, vindo do Remote Config. Avisa os ouvintes
/// quando a organização publica uma mudança e quando o prazo muda de minuto,
/// começa ou acaba.
class MissaoController extends ChangeNotifier {
  MissaoController({DateTime Function()? relogio})
    : _relogio = relogio ?? DateTime.now;

  final DateTime Function() _relogio;
  Missao _missao = Missao.desligada;
  StreamSubscription<RemoteConfigUpdate>? _atualizacoes;
  Timer? _proximaMudanca;

  Missao get missao => _missao;
  DateTime get agora => _relogio();

  /// Padrões locais, busca inicial e escuta em tempo real. Sem rede, a missão
  /// fica como estava na última abertura ou, na primeira, desligada.
  Future<void> iniciar() async {
    final config = FirebaseRemoteConfig.instance;
    try {
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          // Zero só em debug; em release a mudança chega pelo tempo real.
          minimumFetchInterval: kDebugMode
              ? Duration.zero
              : const Duration(hours: 1),
        ),
      );
      await config.setDefaults(ParametrosRemoteConfig.padroes);
      _ler(config);

      _atualizacoes = config.onConfigUpdated.listen(
        (_) async {
          try {
            await config.activate();
            _ler(config);
          } catch (erro) {
            debugPrint('Falha ao ativar o Remote Config: $erro');
          }
        },
        onError: (Object erro) {
          debugPrint('Remote Config em tempo real indisponível: $erro');
        },
      );

      await config.fetchAndActivate();
      _ler(config);
    } catch (erro) {
      debugPrint('Falha ao buscar o Remote Config: $erro');
    }
  }

  void _ler(FirebaseRemoteConfig config) {
    atualizar(
      Missao.ler(
        ativa: config.getBool(ParametrosRemoteConfig.missaoAtiva),
        estandesIdsJson: config.getString(
          ParametrosRemoteConfig.missaoEstandesIds,
        ),
        inicio: config.getString(ParametrosRemoteConfig.missaoInicio),
        duracaoMin: config.getInt(ParametrosRemoteConfig.missaoDuracaoMin),
      ),
    );
  }

  /// Troca a missão e agenda o próximo aviso do prazo.
  void atualizar(Missao missao) {
    _missao = missao;
    _agendar();
    notifyListeners();
  }

  /// Um único timer até a próxima mudança visível: o início, a virada do
  /// minuto na contagem ou o fim.
  void _agendar() {
    _proximaMudanca?.cancel();
    final inicio = _missao.inicio;
    final fim = _missao.fim;
    if (!_missao.ligada || inicio == null || fim == null) return;

    final agora = this.agora;
    Duration espera;
    if (agora.isBefore(inicio)) {
      espera = inicio.difference(agora);
    } else if (agora.isBefore(fim)) {
      final restante = fim.difference(agora);
      espera = Duration(
        microseconds: restante.inMicroseconds % Duration.microsecondsPerMinute,
      );
      if (espera == Duration.zero) espera = const Duration(minutes: 1);
    } else {
      return;
    }
    // Pequena folga para o arredondamento já ter mudado ao disparar.
    _proximaMudanca = Timer(espera + const Duration(milliseconds: 50), () {
      _agendar();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _proximaMudanca?.cancel();
    unawaited(_atualizacoes?.cancel());
    super.dispose();
  }
}
