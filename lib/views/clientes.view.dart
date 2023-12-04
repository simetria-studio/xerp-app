// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xerpapp/views/clientes_detalhes.dart';
import 'package:xerpapp/views/produto_detalhes.dart';

import '../class/api_config.dart';
import '../class/get_user_info.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final GlobalKey _listKey = GlobalKey();
  bool isLoading = true;
  List<dynamic> clientes = [];
  List<dynamic> filteredOrcamentos =
      []; // Nova lista para os orçamentos filtrados
  int codigo_empresa = 0;
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    _loadDataFromPrefs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        print('chegou ao final da lista');
        _loadMoreData();
      }
    });
    sendRequest();
    // Inicializando o controller
    searchController.addListener(
        _filterOrcamentos); // Adicionando listener para chamada da função de filtro
  }

  Future<void> _loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? clientesData = prefs.getString('clientes');

    if (clientesData != null && clientesData.isNotEmpty) {
      List<dynamic> savedClientes = json.decode(clientesData);
      clientes.addAll(savedClientes);
      filteredOrcamentos.addAll(savedClientes);

      setState(() {
        isLoading = false;
      });
    } else {
      // Carregar dados da API se não houver dados no SharedPreferences
      sendRequest();
    }
  }

  Future<void> _loadMoreData() async {
    print('Carregando mais dados...');
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    currentPage++;
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final codigoRegiao = prefs.getString('codigo_regiao') ?? 0;

    const url = '${ApiConfig.apiUrl}/get-all-clientes';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "codigo_empresa": codigoEmpresa,
        "codigo_regiao": codigoRegiao, // substitua com o código da empresa real
        "page": currentPage
      }),
    );

    if (response.statusCode == 200) {
      var newClientes = json.decode(response.body);

      if (newClientes.isNotEmpty) {
        setState(() {
          clientes.addAll(newClientes);
          filteredOrcamentos.addAll(newClientes);
          isLoading = false;
        });
        print(
            'Dados carregados com sucesso. Total de clientes: ${clientes.length}');
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('Erro na solicitação: ${response.statusCode} ${response.body}');
    }
  }

  void _filterOrcamentos() {
    sendRequest();
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendRequest() async {
    setState(() {
      isLoading = true;
    });

    // Limpe os dados antigos de clientes e filteredOrcamentos
    clientes.clear();
    filteredOrcamentos.clear();

    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? '0';
    final codigoRegiao = prefs.getString('codigo_regiao') ?? '0';
    const String url = '${ApiConfig.apiUrl}/get-all-clientes';
    final search = searchController.text.toLowerCase();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "codigo_empresa": codigoEmpresa,
        "codigo_regiao": codigoRegiao,
        "search_text": search
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var newClientes = json.decode(response.body);

      // Salve os novos dados no SharedPreferences somente quando a pesquisa estiver vazia
      if (searchController.text.isEmpty) {
        prefs.setString('clientes', json.encode(newClientes));
      }

      clientes.addAll(newClientes);
      filteredOrcamentos.addAll(newClientes);

      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception(
          'Erro na solicitação: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _refreshData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('clientes');
    clientes.clear();
    filteredOrcamentos.clear();
    sendRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 246),
      appBar: AppBar(
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'CLIENTES',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFAFAFA),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 0.50,
                          color: Color(0xFFF2F2F2),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.tune, size: 20, color: Color(0xFF7F7979)),
                        Text(
                          'Filtros',
                          style: TextStyle(
                            color: Color(0xFF7F7979),
                            fontSize: 20,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    margin: const EdgeInsets.only(left: 16),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFAFAFA),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 0.50,
                          color: Color(0xFFF2F2F2),
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Pesquisar',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFFEEEEEE),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 16,
                    padding: const EdgeInsets.only(left: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Código',
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w900,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 16,
                    padding: const EdgeInsets.only(left: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Razão Social',
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w900,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 16,
                    padding: const EdgeInsets.only(left: 16),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: Color(0xFFEEEEEE)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Nome Fantasia',
                          style: TextStyle(
                            color: Color(0xFF404040),
                            fontSize: 12,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w900,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: filteredOrcamentos.length +
                    (isLoading
                        ? 1
                        : 0), // +1 para o indicador de progresso// Mude para a lista filtrada
                itemBuilder: (BuildContext context, int index) {
                  if (index < filteredOrcamentos.length) {
                    final clientes = filteredOrcamentos[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClientesDetalhes(cliente: clientes),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.only(left: 16),
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFEEEEEE)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    // Adiciona o Flexible aqui
                                    child: Text(
                                      '${clientes['codigo_cliente']}',
                                      style: const TextStyle(
                                        color: Color(0xFF404040),
                                        fontSize: 12,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.w400,
                                        height: 1.33,
                                      ),
                                      overflow: TextOverflow
                                          .ellipsis, // Adiciona overflow
                                      maxLines: 1, // Limita o número de linhas
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.only(left: 16),
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFEEEEEE)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    // Adicionado para evitar overflow de texto
                                    child: Text(
                                      clientes['razao_social'] ?? 'N/A',
                                      style: const TextStyle(
                                        color: Color(0xFF404040),
                                        fontSize: 12,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.w400,
                                        height: 1.33,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              height: 80,
                              padding: const EdgeInsets.only(left: 16),
                              clipBehavior: Clip.antiAlias,
                              decoration:
                                  const BoxDecoration(color: Color(0xFFEEEEEE)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    // Adicionado para evitar overflow de texto
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Text(
                                        clientes['nome_fantasia'] ?? 'N/A',
                                        style: const TextStyle(
                                          color: Color(0xFF404040),
                                          fontSize: 12,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.w400,
                                          height: 1.33,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines:
                                            2, // Aumente este valor conforme necessário
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Estoque removido pois não há dado de estoque na resposta da API
                        ],
                      ),
                    );
                  } else {
                    // Exiba o indicador de progresso circular no final
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
