import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore.dart';

/// Estande ativo como o visitante vê. O ID é o código curto (ex.: E03).
class Estande {
  const Estande({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.localizacao,
  });

  factory Estande.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final dados = doc.data() ?? const {};
    return Estande(
      id: doc.id,
      nome: dados[CamposEstande.nome] as String? ?? '',
      descricao: dados[CamposEstande.descricao] as String? ?? '',
      localizacao: dados[CamposEstande.localizacao] as String? ?? '',
    );
  }

  final String id;
  final String nome;
  final String descricao;
  final String localizacao;

  /// Iniciais do avatar: primeira letra da primeira e da última palavra
  /// ("Trilha Verde" → "TV"); com uma palavra só, as duas primeiras letras.
  String get iniciais {
    final palavras = nome.trim().split(RegExp(r'\s+'));
    final primeira = palavras.first;
    if (primeira.isEmpty) return id.substring(0, 2);
    if (palavras.length == 1) {
      return primeira.substring(0, primeira.length < 2 ? 1 : 2).toUpperCase();
    }
    return (primeira[0] + palavras.last[0]).toUpperCase();
  }
}
