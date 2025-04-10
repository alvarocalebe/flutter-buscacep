class Endereco {
  final String cep;
  final String logradouro;
  String complemento;
  String numero;  // Agora o número é mutável
  String apartamento;  // Agora o apartamento é mutável
  final String bairro;
  final String localidade;
  final String uf;

  Endereco({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.numero,
    required this.apartamento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  // Método para criar um objeto Endereco a partir de um JSON
  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      complemento: json['complemento'] ?? '',
      numero: json['numero'] ?? '',  // Pode ser vazio inicialmente
      apartamento: json['apartamento'] ?? '',  // Pode ser vazio inicialmente
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  // Método copyWith para permitir alterações nos campos
  Endereco copyWith({
    String? complemento,
    String? numero,
    String? apartamento,
  }) {
    return Endereco(
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
