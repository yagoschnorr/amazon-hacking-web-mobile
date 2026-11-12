import 'dart:convert';

import '../../estandes/data/estande.dart';

/// Missão surpresa como publicada no Remote Config
/// (docs/contrato-de-dados.md).
class Missao {
  const Missao({
    required this.ligada,
    required this.estandesIds,
    this.inicio,
    this.duracao,
  });

  static const desligada = Missao(ligada: false, estandesIds: []);

  /// Lê os valores crus dos parâmetros. JSON malformado vira lista vazia;
  /// início vazio ou inválido, ou duração menor ou igual a zero, deixa a
  /// missão sem prazo.
  factory Missao.ler({
    required bool ativa,
    required String estandesIdsJson,
    required String inicio,
    required int duracaoMin,
  }) {
    final dataInicio = DateTime.tryParse(inicio.trim());
    final temPrazo = dataInicio != null && duracaoMin > 0;
    return Missao(
      ligada: ativa,
      estandesIds: _lerIds(estandesIdsJson),
      inicio: temPrazo ? dataInicio : null,
      duracao: temPrazo ? Duration(minutes: duracaoMin) : null,
    );
  }

  final bool ligada;
  final List<String> estandesIds;
  final DateTime? inicio;
  final Duration? duracao;

  DateTime? get fim => switch ((inicio, duracao)) {
    (final inicio?, final duracao?) => inicio.add(duracao),
    _ => null,
  };

  /// Ligada e, se tiver prazo, entre o início e o fim.
  bool emVigor(DateTime agora) => switch ((inicio, fim)) {
    (final inicio?, final fim?) =>
      ligada && !agora.isBefore(inicio) && agora.isBefore(fim),
    _ => ligada,
  };

  /// Minutos que faltam, arredondados para cima ("Faltam 25 min").
  int? minutosRestantes(DateTime agora) {
    final fim = this.fim;
    if (fim == null) return null;
    final restante = fim.difference(agora);
    if (restante <= Duration.zero) return 0;
    return (restante.inMicroseconds / Duration.microsecondsPerMinute).ceil();
  }

  static List<String> _lerIds(String json) {
    try {
      final valor = jsonDecode(json);
      if (valor is! List) return const [];
      return [
        for (final id in valor)
          if (id is String && id.trim().isNotEmpty) id.trim(),
      ];
    } on FormatException {
      return const [];
    }
  }
}

/// O que as telas mostram da missão: só os estandes participantes que estão
/// ativos agora. Nulo quando a missão não está em vigor ou não tem nenhum
/// estande ativo, e então ela é tratada como desligada.
class ResumoMissao {
  const ResumoMissao({
    required this.participantes,
    this.duracaoMin,
    this.minutosRestantes,
  });

  static ResumoMissao? calcular(
    Missao missao,
    List<Estande> ativos,
    DateTime agora,
  ) {
    if (!missao.emVigor(agora)) return null;
    final ids = missao.estandesIds.toSet();
    final participantes = [
      for (final estande in ativos)
        if (ids.contains(estande.id)) estande,
    ];
    if (participantes.isEmpty) return null;
    return ResumoMissao(
      participantes: participantes,
      duracaoMin: missao.duracao?.inMinutes,
      minutosRestantes: missao.minutosRestantes(agora),
    );
  }

  /// Na ordem da lista de estandes ativos.
  final List<Estande> participantes;
  final int? duracaoMin;
  final int? minutosRestantes;

  bool participa(Estande estande) =>
      participantes.any((participante) => participante.id == estande.id);

  List<Estande> faltando(Map<String, DateTime?> visitas) => [
    for (final estande in participantes)
      if (!visitas.containsKey(estande.id)) estande,
  ];

  /// Os que ainda faltam na missão sobem para o topo, como nas telas 03 e 04;
  /// o resto mantém a ordem.
  List<Estande> ordenar(
    List<Estande> estandes,
    Map<String, DateTime?> visitas,
  ) {
    final pendentes = faltando(visitas).map((e) => e.id).toSet();
    return [
      ...estandes.where((e) => pendentes.contains(e.id)),
      ...estandes.where((e) => !pendentes.contains(e.id)),
    ];
  }

  /// "Visite 2 estandes em 30 min"; sem prazo, "Visite 2 estandes".
  String get titulo {
    final total = participantes.length;
    final estandes = total == 1 ? '1 estande' : '$total estandes';
    return duracaoMin == null
        ? 'Visite $estandes'
        : 'Visite $estandes em $duracaoMin min';
  }

  /// "Faltam 25 min"; nulo sem prazo.
  String? get tempo => switch (minutosRestantes) {
    null => null,
    1 => 'Falta 1 min',
    final minutos => 'Faltam $minutos min',
  };

  String mensagemBanner(Map<String, DateTime?> visitas) {
    final faltam = faltando(visitas);
    return switch (faltam) {
      [] => 'Você visitou todos os estandes da missão.',
      [final estande] => 'Falta ${estande.nome}, no ${estande.localizacao}.',
      _ => 'Faltam ${faltam.length} estandes da missão.',
    };
  }
}
