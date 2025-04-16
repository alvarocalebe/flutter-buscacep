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
      if (endereco != null) {
        final enderecoAtualizado = endereco.copyWith(
          complemento: _complementoController.text,
          numero: _numeroController.text,
          apartamento: _apartamentoController.text,
        );

        if (_enderecoEditando != null) {
          final atualizado = enderecoAtualizado.copyWith(id: _enderecoEditando!.id);
          await ViaCepService.atualizarEndereco(atualizado);
          setState(() {
            _enderecos[_enderecos.indexOf(_enderecoEditando!)] = atualizado;
            _enderecoEditando = null;
          });
        } else {
          setState(() {
            _enderecos.add(enderecoAtualizado);
          });
        }

        _limparCampos();
      } else {
        setState(() {
          _erro = 'CEP não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao buscar o CEP';
      });
    }
  }

  void _limparCampos() {
    _cepController.clear();
    _complementoController.clear();
    _numeroController.clear();
    _apartamentoController.clear();
    _erro = null;
  }

  void _deletarEndereco(String? id) async {
    if (id == null) return;

    try {
      await ViaCepService.deletarEndereco(id);
      setState(() {
        _enderecos.removeWhere((e) => e.id == id);
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao deletar o endereço';
      });
    }
  }

  void _editarEndereco(Endereco endereco) {
    setState(() {
      _cepController.text = endereco.cep.replaceAll('-', '');
      _complementoController.text = endereco.complemento ?? '';
      _numeroController.text = endereco.numero ?? '';
      _apartamentoController.text = endereco.apartamento ?? '';
      _enderecoEditando = endereco;
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarEnderecosSalvos();
  }

  Future<void> _carregarEnderecosSalvos() async {
    try {
      final enderecos = await ViaCepService.buscarTodosEnderecos();
      setState(() {
        _enderecos = enderecos;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar endereços salvos';
      });
    }
  }

  /// ✅ AGORA está no lugar certo!
  String _formatarCep(String cep) {
    if (cep.length == 8) {
      return '${cep.substring(0, 5)}-${cep.substring(5)}';
    }
    return cep;
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
            _buildTextField(_cepController, 'Digite o CEP', Icons.pin_drop, TextInputType.number),
            _buildTextField(_complementoController, 'Complemento', Icons.note_add),
            _buildTextField(_numeroController, 'Número ou Lote', Icons.format_list_numbered),
            _buildTextField(_apartamentoController, 'Número do Apartamento', Icons.apartment),
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
                          Text("📮 CEP: ${_formatarCep(endereco.cep)}"),
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
                                onPressed: () => _deletarEndereco(endereco.id),
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

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, [TextInputType? keyboard]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboard ?? TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
