// [Modelo de Exemplo de Nota Fiscal]
// /Não retorna todos os dados por segurança/
// !!! --- NÃO USAR EM PRODUÇÃO --- !!!

class NotaFiscal {
  final String chaveAcesso;
  final String numero;
  final String dataEmissao;
  final double valorTotal;
  final Emitente emitente;
  final Destinatario destinatario;
  final List<Item> itens;
  final String? tipoNota;

  NotaFiscal({
    required this.chaveAcesso,
    required this.numero,
    required this.dataEmissao,
    required this.valorTotal,
    required this.emitente,
    required this.destinatario,
    required this.itens,
    this.tipoNota,
  });

  factory NotaFiscal.fromJson(Map<String, dynamic> json) {
    return NotaFiscal(
      chaveAcesso: json['chaveAcesso'],
      numero: json['numero'],
      dataEmissao: json['dataEmissao'],
      valorTotal: json['valorTotal']?.toDouble(),
      emitente: Emitente.fromJson(json['emitente']),
      destinatario: Destinatario.fromJson(json['destinatario']),
      itens: List<Item>.from(json['itens'].map((x) => Item.fromJson(x))),
      tipoNota: json['tipoNota'],
    );
  }
}

class Emitente {
  final String nome;
  final String cnpj;
  final String endereco;
  final String? nomeFantasia;
  final String? municipio;
  final String? uf;

  Emitente({
    required this.nome,
    required this.cnpj,
    required this.endereco,
    this.nomeFantasia,
    this.municipio,
    this.uf,
  });

  factory Emitente.fromJson(Map<String, dynamic> json) {
    return Emitente(
      nome: json['nome'],
      cnpj: json['cnpj'],
      endereco: json['endereco'],
      nomeFantasia: json['nomeFantasia'],
      municipio: json['municipio'],
      uf: json['uf'],
    );
  }
}

class Destinatario {
  final String nome;
  final String cpfCnpj;

  Destinatario({
    required this.nome,
    required this.cpfCnpj,
  });

  factory Destinatario.fromJson(Map<String, dynamic> json) {
    return Destinatario(
      nome: json['nome'],
      cpfCnpj: json['cpfCnpj'],
    );
  }
}

class Item {
  final String descricao;
  final int quantidade;
  final double valorUnitario;
  final double valorTotalItem;

  Item({
    required this.descricao,
    required this.quantidade,
    required this.valorUnitario,
    required this.valorTotalItem,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      descricao: json['descricao'],
      quantidade: json['quantidade'],
      valorUnitario: json['valorUnitario']?.toDouble(),
      valorTotalItem: json['valorTotalItem']?.toDouble(),
    );
  }
}
