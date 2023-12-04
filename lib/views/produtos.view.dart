import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xerpapp/views/produto_detalhes.dart';

import '../class/api_config.dart';

class Produtos extends StatefulWidget {
  const Produtos({super.key});

  @override
  State<Produtos> createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> {
  List<dynamic> orcamentos = [];
  List<dynamic> filteredOrcamentos = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // loadProducts();
    sendRequest('');

    // Adiciona um ouvinte para detectar mudanças no texto
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        // Se o texto estiver vazio, redefina a pesquisa
        sendRequest('');
      } else {
        // Caso contrário, faça a pesquisa normal
        searchProducts(searchController.text);
      }
    });
  }

  void searchProducts(String searchText) {
    sendRequest(searchText);
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      // Se a consulta estiver vazia, mostre todos os produtos
      setState(() {
        filteredOrcamentos = List.from(orcamentos);
      });
      return;
    }

    final filteredProducts = orcamentos.where((product) {
      // Adapte isso de acordo com a estrutura dos seus produtos
      final productName = product['descricao_produto'].toString().toLowerCase();
      return productName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredOrcamentos = filteredProducts;
    });
  }

  Future<void> sendRequest(String searchText) async {
    final prefs = await SharedPreferences.getInstance();
    final codigoEmpresa = prefs.getString('codigo_empresa') ?? 0;
    final codigoRegiao = prefs.getString('codigo_regiao') ?? 0;
      print(codigoRegiao);
    const String url = '${ApiConfig.apiUrl}/get-all-produtos';
     // Agora, você pode imprimir o texto de pesquisa

    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        "codigo_empresa": codigoEmpresa,
        "search_text": searchText,
        "codigo_regiao": codigoRegiao,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> result = json.decode(response.body);
      print(result);
      setState(() {
        orcamentos = result;
        filteredOrcamentos =
            result; // Atualize filteredOrcamentos com os resultados da pesquisa
        // Convertendo os dados em uma string JSON e salvando em SharedPreferences
        prefs.setString('produtos', json.encode(orcamentos));
      });
    } else {
      throw Exception(
          'Erro na solicitação: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 246),
      appBar: AppBar(
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'PRODUTOS',
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
                            onChanged: (text) {
                              // Chame a função sendRequest sempre que o texto mudar
                              sendRequest(text);
                            },
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
                          'Descrição',
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
                          'Estoque',
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
            child: ListView.builder(
              itemCount:
                  filteredOrcamentos.length, // Mude para a lista filtrada
              itemBuilder: (BuildContext context, int index) {
                final orcamento = filteredOrcamentos[index];
                final valorNumerico =
                    double.tryParse(orcamento['preco_tabela'].toString()) ??
                        0.0;
                final valorFormatado = NumberFormat.currency(
                  locale: 'pt_BR',
                  symbol: 'R\$',
                ).format(valorNumerico);
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProdutoDetalhes(produto: orcamento),
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
                                  '${orcamento['codigo_produto']}',
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
                                  orcamento['descricao_produto'] ?? 'N/A',
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
                              Text(
                                valorFormatado.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
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
                              Text(
                                orcamento['saldo_atual'] ??
                                    'S/N', // ou qualquer valor padrão ou mesmo deixar em branco
                                style: const TextStyle(
                                  color: Color(0xFF404040),
                                  fontSize: 12,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.w400,
                                  height: 1.33,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
