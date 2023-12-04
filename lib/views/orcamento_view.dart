import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xerpapp/class/api_config.dart';

import 'detalhes_orcamento.dart';
import 'home_view.dart';

class Orcamento extends StatefulWidget {
  const Orcamento({Key? key}) : super(key: key);

  @override
  State<Orcamento> createState() => _OrcamentoState();
}

class _OrcamentoState extends State<Orcamento> {
  final GlobalKey _listKey = GlobalKey();
  bool isLoading = true;
  List<dynamic> orcamentos = [];
  List<dynamic> filteredOrcamentos = [];
  int codigo_empresa = 0;
  late TextEditingController searchController;
  final ScrollController _scrollController = ScrollController();
  final StreamController _reloadController = StreamController.broadcast();

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _reloadController.stream
        .debounceTime(const Duration(seconds: 4))
        .listen((event) {
      sendRequest();
    });

    _loadDataFromPrefs();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        print('chegou ao final da lista');
        _loadMoreData();
      }
    });
    sendRequest();
    searchController = TextEditingController();
    searchController.addListener(_filterOrcamentos);
  }

  Future<void> _loadDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? orcamentosData = prefs.getString('orcamentos');
    if (orcamentosData != null && orcamentosData.isNotEmpty) {
      List<dynamic> savedOrcamentos = json.decode(orcamentosData);
      orcamentos.addAll(savedOrcamentos);
      filteredOrcamentos.addAll(savedOrcamentos);

      _reloadController.add(null);
      setState(() {
        isLoading = false;
      });
    } else {
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
    const url = '${ApiConfig.apiUrl}/get-orcamentos';
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "codigo_empresa": codigoEmpresa,
        "page": currentPage,
      }),
    );

    if (response.statusCode == 200) {
      var newOrcamentos = json.decode(response.body);
      if (newOrcamentos.isNotEmpty) {
        setState(() {
          orcamentos.addAll(newOrcamentos);
          filteredOrcamentos.addAll(newOrcamentos);

          isLoading = false;
        });
        _reloadController.add(null);
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
    final search = searchController.text.toLowerCase();

    setState(() {
      filteredOrcamentos = orcamentos
          .where((orcamento) =>
              orcamento['nome_cliente'].toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  void dispose() {
    _reloadController.close(); // Adicione esta linha
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendRequest() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;

    const String url = '${ApiConfig.apiUrl}/get-orcamentos';

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "codigo_empresa": codigoEmpresa,
        "page": currentPage,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      var newOrcamentos = json.decode(response.body);

      orcamentos.clear(); // Adicione esta linha para limpar a lista existente
      orcamentos.addAll(newOrcamentos);
      filteredOrcamentos
          .clear(); // Adicione esta linha para limpar a lista filtrada existente
      filteredOrcamentos.addAll(newOrcamentos);

      prefs.setString('orcamentos', json.encode(orcamentos));
      _reloadController.add(null);
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception(
          'Erro na solicitação: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _refreshData() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.remove('orcamentos');
    // orcamentos.clear();
    // filteredOrcamentos.clear();
    // sendRequest();
  }

  @override
  Widget build(BuildContext context) {
    // _sortOrcamentos();
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 246),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Ícone de seta para a esquerda
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage())),
        ),
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'ORÇAMENTOS',
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
                          'Nº Orç.',
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
                          'Cliente',
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
                          'Valor',
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
                          'Status',
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
                    final orcamento = filteredOrcamentos[index];
                    final valorString = orcamento['valor_total'].toString();
                    final valorNumerico = double.tryParse(valorString) ?? 0.0;
                    final valorFormatado = NumberFormat.currency(
                      locale: 'pt_BR',
                      symbol: 'R\$',
                    ).format(valorNumerico);

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetalhesOrcamento(orcamento: orcamento),
                        ));
                      },
                      child: Container(
                        key: ValueKey(orcamento['numero_pedido']),
                        height: 80,
                        padding: const EdgeInsets.all(16),
                        clipBehavior: Clip.antiAlias,
                        decoration:
                            const BoxDecoration(color: Color(0xFFEEEEEE)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${orcamento['numero_pedido']}\n${orcamento['data_pedido']}',
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                orcamento['nome_cliente'].isEmpty
                                    ? 'N/A'
                                    : orcamento['nome_cliente'],
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
                            Expanded(
                              child: Text(
                                valorFormatado,
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'Orçamento',
                                style: TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
                                ),
                              ),
                            ),
                          ],
                        ),
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
