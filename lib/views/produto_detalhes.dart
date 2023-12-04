import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProdutoDetalhes extends StatelessWidget {
  final dynamic produto;

  const ProdutoDetalhes({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String precoTabela = '0.0';
    if (produto['preco_produto'] != null &&
        produto['preco_produto'].isNotEmpty) {
      precoTabela =
          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(
        double.tryParse(
                produto['preco_produto'][0]['preco_tabela'].toString()) ??
            0.0,
      );
    }
    String saldoAtual = '0.0';
    if (produto['saldo'] != null && produto['saldo'].isNotEmpty) {
      saldoAtual = produto['saldo'][0]['saldo_atual'].toString();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'Detalhes do Produto',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoItem(Icons.label, 'Código do Produto:',
                        produto['codigo_produto'].toString()),
                    _infoItem(Icons.description, 'Descrição:',
                        produto['descricao_produto']),
                    _infoItem(
                        precoTabela.isNotEmpty
                            ? Icons.attach_money
                            : Icons.money_off,
                        'Preço de tabela:',
                        precoTabela),
                    _infoItem(
                      Icons.store,
                      'Estoque Atual:',
                      saldoAtual,
                    ),
                    _infoItem(Icons.straighten, 'Unidade de medida:',
                        produto['unidade_medida']),
                    _infoItem(Icons.home_filled, 'Depósito padrão:',
                        produto['deposito_padrao']),
                    // Adicione mais campos conforme necessário
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF043259), size: 20.0),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Color(0xFF043259), fontSize: 16),
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
