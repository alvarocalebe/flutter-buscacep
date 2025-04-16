import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/endereco.dart';

class ViaCepService {
  static const _mockApiUrl = 'https://67f9145b094de2fe6ea06319.mockapi.io/endereco';

  static Future<Endereco?> buscarEnderecoPorCep(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody.containsKey('erro')) {
        return null; // CEP não encontrado
      }

      final endereco = Endereco.fromJson(jsonBody);

      // Persistir na API externa e retornar com ID
      final enderecoComId = await _salvarEnderecoNaApi(endereco);

      return enderecoComId;
    } else {
      throw Exception('Erro ao buscar endereço');
    }
  }

  static Future<Endereco> _salvarEnderecoNaApi(Endereco endereco) async {
    final url = Uri.parse(_mockApiUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(endereco.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      return Endereco.fromJson(jsonResponse);
    } else {
      throw Exception('Erro ao salvar endereço na API externa');
    }
  }

  static Future<List<Endereco>> buscarTodosEnderecos() async {
    final url = Uri.parse(_mockApiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Endereco.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar endereços da API');
    }
  }

  static Future<void> atualizarEndereco(Endereco endereco) async {
    if (endereco.id == null || endereco.id!.isEmpty) {
      throw Exception('Endereço sem ID. Não é possível atualizar.');
    }

    final url = Uri.parse('$_mockApiUrl/${endereco.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(endereco.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar endereço na API externa');
    }
  }

  static Future<void> deletarEndereco(String id) async {
    final url = Uri.parse('$_mockApiUrl/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar endereço da API externa');
    }
  }
}
