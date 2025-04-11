import 'package:flutter/material.dart';
import 'models/endereco.dart';
import 'services/viacep_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Roboto',
      primarySwatch: Colors.indigo,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
    ),
    home: BuscaCepPage(),
  ));
}

class BuscaCepPage extends StatefulWidget {
  @override
  _BuscaCepPageState createState() => _BuscaCepPageState();
}

class _BuscaCepPageState extends State<BuscaCepPage> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _apartamentoController = TextEditingController();

  List<Endereco> _enderecos = [];
  String? _erro;
  Endereco? _enderecoEditando;

  Future<void> _buscarCep() async {
    final cep = _cepController.text.trim();
    if (cep.isEmpty || cep.length != 8) {
      setState(() {
        _erro = 'Digite um CEP válido com 8 dígitos';
      });
      return;
    }

    try {
      final endereco = await ViaCepService.buscarEnderecoPorCep(cep);
      setState(() {
        if (endereco != null) {
          if (_enderecoEditando != null) {
            _enderecos.remove(_enderecoEditando);
          }
          _enderecos.add(endereco.copyWith(
            complemento: _complementoController.text,
            numero: _numeroController.text,
            apartamento: _apartamentoController.text,
          ));

          _erro = null;
          _cepController.clear();
          _complementoController.clear();
          _numeroController.clear();
          _apartamentoController.clear();
          _enderecoEditando = null;
        } else {
          _erro = 'CEP não encontrado';
        }
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar o CEP';
      });
    }
  }

  void _deletarEndereco(int index) {
    setState(() {
      _enderecos.removeAt(index);
    });
  }

  void _editarEndereco(Endereco endereco) {
    setState(() {
      _cepController.text = endereco.cep;
      _complementoController.text = endereco.complemento ?? '';
      _numeroController.text = endereco.numero ?? '';
      _apartamentoController.text = endereco.apartamento ?? '';
      _enderecoEditando = endereco;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on_outlined),
            SizedBox(width: 8),
            Text('CRUD de Endereços'),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Digite o CEP',
                  prefixIcon: Icon(Icons.pin_drop),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _complementoController,
                decoration: InputDecoration(
                  labelText: 'Complemento',
                  prefixIcon: Icon(Icons.note_add),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _numeroController,
                decoration: InputDecoration(
                  labelText: 'Número ou Lote',
                  prefixIcon: Icon(Icons.format_list_numbered),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _apartamentoController,
                decoration: InputDecoration(
                  labelText: 'Número do Apartamento',
                  prefixIcon: Icon(Icons.apartment),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.search),
              onPressed: _buscarCep,
              label: Text(_enderecoEditando == null
                  ? 'Buscar e Adicionar Endereço'
                  : 'Atualizar Endereço'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 20),
            if (_erro != null)
              Text(
                _erro!,
                style: TextStyle(color: Colors.red),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _enderecos.length,
                itemBuilder: (context, index) {
                  final endereco = _enderecos[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("📮 CEP: ${endereco.cep}"),
                          Text("🏠 Logradouro: ${endereco.logradouro}"),
                          Text("🧾 Complemento: ${endereco.complemento ?? 'N/A'}"),
                          Text("🔢 Número ou Lote: ${endereco.numero ?? 'N/A'}"),
                          Text("🏢 Apartamento: ${endereco.apartamento ?? 'N/A'}"),
                          Text("📍 Bairro: ${endereco.bairro}"),
                          Text("🌆 Cidade: ${endereco.localidade}"),
                          Text("🗺️ Estado: ${endereco.uf}"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.indigo),
                                onPressed: () => _editarEndereco(endereco),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletarEndereco(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
