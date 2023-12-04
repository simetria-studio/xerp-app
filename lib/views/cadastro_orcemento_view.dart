import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../class/api_config.dart';
import '../class/get_user_info.dart';
import 'cad_produto_view.dart';

class CadastroOrcamento extends StatefulWidget {
  const CadastroOrcamento({super.key});

  @override
  State<CadastroOrcamento> createState() => _CadastroOrcamentoState();
}

class _CadastroOrcamentoState extends State<CadastroOrcamento> {
  bool userDataLoaded = false;

  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _condipagController = TextEditingController();
  final TextEditingController _tipoDocController = TextEditingController();
  final TextEditingController _codigoEmpresaController =
      TextEditingController();
  final TextEditingController _tipoFreteController = TextEditingController();
  final TextEditingController _transportadorController =
      TextEditingController();
  final TextEditingController _codigoCliente = TextEditingController();

  String apiUrl = ApiConfig.apiUrl;
  String _selectedOption = 'Opção 1';
  String _selectedCpfCnpj = ''; // Adicione esta linha
  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> pagamentos = [];
  List<Map<String, dynamic>> documentos = [];
  String token = "teste";
  int codigo_empresa =
      0; // Adicione esta linha// Add a type or use 'var' keyword

  Future<void> initializeData() async {
    getUserData();
    setState(() {
      userDataLoaded = true;
    });
    await _fetchClientes('');
    await _fetchCondpag('');
    await _fetchTipoDoc('');
    await _fetchTipoFrete('');
    await _fetchTransportador('');
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  User? userData;

  void getUserData() async {
    try {
      userData = await fetchUserData();
      if (userData != null) {
        codigo_empresa = userData?.codigo_empresa as int? ?? 0;
        await _fetchClientes('');
      } else {
        print('Dados do usuário não encontrados.');
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchClientes(String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;

    final response = await http.post(
      Uri.parse(
          '${ApiConfig.apiUrl}/get-clientes'), // Remova o parâmetro 'page' da URL
      body: json
          .encode({"codigo_empresa": codigoEmpresa, "search_text": searchText}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        final List<Map<String, dynamic>> clientes =
            List<Map<String, dynamic>>.from(responseData);
        return clientes; // Retorne a lista de sugestões
      } else {
        throw Exception(
            "Falha ao carregar os clientes: dados não são uma lista");
      }
    } else {
      throw Exception("Falha ao carregar os clientes");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchCondpag(String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final response = await http.post(
      Uri.parse("${ApiConfig.apiUrl}/get-condpag"),
      body: json
          .encode({"codigo_empresa": codigoEmpresa, "search_text": searchText}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        final List<Map<String, dynamic>> clientes =
            List<Map<String, dynamic>>.from(responseData);
        return clientes; // Retorne a lista de sugestões
      } else {
        throw Exception(
            "Falha ao carregar os clientes: dados não são uma lista");
      }
    } else {
      throw Exception("Falha ao carregar os clientes");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTipoDoc(String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final response = await http.post(
      Uri.parse("${ApiConfig.apiUrl}/get-tipodoc"),
      body: json
          .encode({"codigo_empresa": codigoEmpresa, "search_text": searchText}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        final List<Map<String, dynamic>> clientes =
            List<Map<String, dynamic>>.from(responseData);
        return clientes; // Retorne a lista de sugestões
      } else {
        throw Exception(
            "Falha ao carregar os clientes: dados não são uma lista");
      }
    } else {
      throw Exception("Falha ao carregar os clientes");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTipoFrete(String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final response = await http.post(
      Uri.parse("${ApiConfig.apiUrl}/get-tipofrete"),
      body: json
          .encode({"codigo_empresa": codigoEmpresa, "search_text": searchText}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        final List<Map<String, dynamic>> clientes =
            List<Map<String, dynamic>>.from(responseData);
        return clientes; // Retorne a lista de sugestões
      } else {
        throw Exception(
            "Falha ao carregar os clientes: dados não são uma lista");
      }
    } else {
      throw Exception("Falha ao carregar os clientes");
    }
  }

  Future<List<Map<String, dynamic>>> _fetchTransportador(
      String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final response = await http.post(
      Uri.parse("${ApiConfig.apiUrl}/get-transportadora"),
      body: json
          .encode({"codigo_empresa": codigoEmpresa, "search_text": searchText}),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is List<dynamic>) {
        final List<Map<String, dynamic>> clientes =
            List<Map<String, dynamic>>.from(responseData);
        return clientes; // Retorne a lista de sugestões
      } else {
        throw Exception(
            "Falha ao carregar os clientes: dados não são uma lista");
      }
    } else {
      throw Exception("Falha ao carregar os clientes");
    }
  }

  Future<http.Response> enviarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    // Substitua pela URL da sua API
    var url = Uri.parse('${ApiConfig.apiUrl}/store-orcamentos');

    // Dados a serem enviados no corpo da requisição POST
    var corpo = jsonEncode({
      "codigo_empresa": codigoEmpresa,
      "razao_social": _clienteController.text,
      "valor_total": 0.0,
      "cond_pag": _condipagController.text,
      "tipo_doc": _tipoDocController.text,
      "codigo_transportador": _transportadorController.text ?? ' ',
      "tipo_frete": _tipoFreteController.text,
      "codigo_cliente": _codigoCliente.text,
    });
    try {
      var resposta = await http.post(
        url,
        body: corpo,
        headers: {"Content-Type": "application/json"},
      );

      if (resposta.statusCode == 200) {
        print('Dados enviados com sucesso!');
        return resposta; // Retorna a resposta para que possamos usá-la depois
      } else {
        print(
            'Falha ao enviar dados: ${resposta.statusCode} - ${resposta.body}');
        throw Exception('Falha ao enviar dados');
      }
    } catch (e) {
      print('Erro ao enviar dados: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF043259),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Text(
                    'NOVO ORÇAMENTO',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: const Text(
                            'Orçamento #00000001',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                              height: 0.06,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Text(
                            'Situação: Em aberto',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 14,
                              fontFamily: 'Arial',
                              fontWeight: FontWeight.w400,
                              height: 0.08,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: const [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                  height: 0.04,
                                ),
                              ),
                              TextSpan(
                                text: 'R\$ 0,00',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w700,
                                  height: 0.04,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cliente',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          TypeAheadField<Map<String, dynamic>>(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _clienteController,
                              enabled: userDataLoaded,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                            suggestionsCallback: (pattern) async {
                              final suggestions = await _fetchClientes(
                                  pattern); // Faz a chamada à API com o texto de pesquisa
                              return suggestions;
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _selectedOption = suggestion['value'] ?? '';
                                _selectedCpfCnpj = suggestion['cnpj_cpf'] ?? '';
                                _cpfCnpjController.text = _selectedCpfCnpj;
                                _clienteController.text =
                                    suggestion['razao_social'] ?? '';
                                _telefoneController.text =
                                    suggestion['telefone'] ?? '';
                                _codigoEmpresaController.text =
                                    suggestion['codigo_empresa'] ?? '';
                                _codigoCliente.text =
                                    suggestion['codigo_cliente'] ?? '';
                              });
                            },
                            itemBuilder:
                                (context, Map<String, dynamic> suggestion) {
                              // Renderize a sugestão aqui
                              return ListTile(
                                title: Text(suggestion['razao_social'] ?? ''),
                                subtitle: Row(
                                  children: [
                                    Text(suggestion['cnpj_cpf'] ?? ''),
                                    const SizedBox(width: 10),
                                    Text(suggestion['cidade'] ?? ''),
                                  ],
                                ),
                              );
                            },
                          ),

                          // Exibe o valor selecionado no campo de input
                        ]),
                  ),

                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CPF/CNPJ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextFormField(
                                controller:
                                    _cpfCnpjController, // Adicione esta linha

                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Telefone',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextFormField(
                                controller:
                                    _telefoneController, // Adicione esta linha
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )
                              // Exibir o cliente selecionado:
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Condição Pagamento',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TypeAheadField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _condipagController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final suggestions = await _fetchCondpag(
                                pattern); // Faz a chamada à API com o texto de pesquisa
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title:
                                  Text(suggestion['codigo_condicao_pagamento']),
                              subtitle: Text(suggestion['value']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              // _selectedOption = suggestion['value'];
                              // _selectedCpfCnpj = suggestion['cnpj_cpf'];
                              _condipagController.text =
                                  suggestion['codigo_condicao_pagamento'];
                            });
                          },
                        ),
                        // Exibir o cliente selecionado:
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo Documento',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TypeAheadField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _tipoDocController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final suggestions = await _fetchTipoDoc(
                                pattern); // Faz a chamada à API com o texto de pesquisa
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['codigo_tipodoc']),
                              subtitle: Text(suggestion['value']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _tipoDocController.text =
                                  suggestion['codigo_tipodoc'];
                            });
                          },
                        ),
                        // Exibir o cliente selecionado:
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipo Frete',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TypeAheadField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _tipoFreteController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final suggestions = await _fetchTipoFrete(
                                pattern); // Faz a chamada à API com o texto de pesquisa
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['codigo']),
                              subtitle: Text(suggestion['value']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _tipoFreteController.text = suggestion['codigo'];
                            });
                          },
                        ),
                        // Exibir o cliente selecionado:
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Transportador',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        TypeAheadField<Map<String, dynamic>>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _transportadorController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            final suggestions = await _fetchTransportador(
                                pattern); // Faz a chamada à API com o texto de pesquisa
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion['codigo_transportador']),
                              subtitle: Text(suggestion['value']),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            setState(() {
                              _transportadorController.text =
                                  suggestion['codigo_transportador'];
                            });
                          },
                        ),
                        // Exibir o cliente selecionado:
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Observação',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              )
                              // Exibir o cliente selecionado:
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //salvar
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.3,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 204, 5, 5),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        Container(
                          width: screenWidth * 0.3,
                          height: 50,
                          margin: const EdgeInsets.only(left: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              enviarDados().then((resposta) {
                                var dados = jsonDecode(resposta.body);
                                var numeroPedido = dados[
                                    'numero_pedido']; // Adapte conforme a estrutura da sua resposta
                                var id = dados[
                                    'id']; // Adapte conforme a estrutura da sua resposta

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CadProduto(
                                        numeroPedido: numeroPedido, id: id),
                                  ),
                                );
                              }).catchError((erro) {
                                print('Erro ao enviar os dados: $erro');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF043259),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: const Text('Salvar'),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
