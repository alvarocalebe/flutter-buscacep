import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';

class ViaCepService {
  static Future<Endereco?> buscarEnderecoPorCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (jsonBody.containsKey('erro')) {
        return null; // CEP não encontrado
      }
      return Endereco.fromJson(jsonBody);
    } else {
      throw Exception('Erro ao buscar endereço');
    }
  }
}
