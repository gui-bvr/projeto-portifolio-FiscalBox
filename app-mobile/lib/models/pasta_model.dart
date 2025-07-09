class PastaModel {
  final String id;
  final String tipo;
  final String numero;

  PastaModel({
    required this.id,
    required this.tipo,
    required this.numero,
  });

  factory PastaModel.fromMap(Map<String, dynamic> map) {
    return PastaModel(
      id: map['id'].toString(),
      tipo: map['tipo'] ?? '',
      numero: map['numero'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'numero': numero,
    };
  }
}
