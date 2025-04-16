class Endereco {
  String? id;
  final String cep;
  final String logradouro;
  String complemento;
  String numero;
  String apartamento;
  final String bairro;
  final String localidade;
  final String uf;

  Endereco({
    this.id,
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.numero,
    required this.apartamento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      id: json['id'], // mantém null se não vier
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      numero: json['numero'] ?? '',
      apartamento: json['apartamento'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'cep': cep,
      'logradouro': logradouro,
      'complemento': complemento,
      'numero': numero,
      'apartamento': apartamento,
      'bairro': bairro,
      'localidade': localidade,
      'uf': uf,
    };
  }

  Endereco copyWith({
    String? id,
    String? complemento,
    String? numero,
    String? apartamento,
  }) {
    return Endereco(
      id: id ?? this.id,
      cep: this.cep,
      logradouro: this.logradouro,
      complemento: complemento ?? this.complemento,
      numero: numero ?? this.numero,
      apartamento: apartamento ?? this.apartamento,
      bairro: this.bairro,
      localidade: this.localidade,
      uf: this.uf,
    );
  }
}
