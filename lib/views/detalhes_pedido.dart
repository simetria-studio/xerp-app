import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalhesPedido extends StatelessWidget {
  final dynamic orcamento;

  const DetalhesPedido({Key? key, required this.orcamento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF043259),
        title:  Text('Detalhes do Pedido #${orcamento['numero_pedido']}',
            style: const TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.person_outline, color: Color(0xFF043259)),
                      title:
                          Text('Nome do Cliente: ${orcamento['cliente']['nome_fantasia']}'),
                      subtitle: Text('Código: ${orcamento['codigo_cliente']}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.credit_card, color: Color(0xFF043259)),
                      title: Text(
                          'CPF/CNPJ: ${orcamento['cliente']?['cnpj_cpf'] ?? 'Não disponível'}'),
                      subtitle:
                          Text('Telefone: ${orcamento['telefone_contato']}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Color(0xFF043259)),
                      title: Text(
                          'Condição de Pagamento: ${orcamento['condipag']?['descricao'] ?? 'Não disponível'}'),
                      subtitle: Text(
                          'Tipo documento: ${orcamento['tipodocumento']?['descricao_tipodoc'] ?? 'Não disponível'}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading:
                          const Icon(Icons.local_shipping, color: Color(0xFF043259)),
                      title: Text(
                          'Transportador: ${orcamento['transportadora']?['descricao_transportador'] ?? 'Não disponível'}'),
                      subtitle: Text(
                          'Código: ${orcamento['transportadora']?['codigo_transportador'] ?? 'Não disponível'}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.money_off, color: Color(0xFF043259)),
                      title: Text(
                          'Valor Total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(orcamento['valor_total'])}'),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              orcamento['itens_pedido'].length,
              (index) {
                final item = orcamento['itens_pedido'][index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: ListTile(
                    leading:
                        const Icon(Icons.shopping_cart, color: Color(0xFF043259)),
                    title: Text(
                      item['descricao_produto'],
                      style: const TextStyle(
                        color: Color(0xFF043259),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Preço Unitário: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(item['preco_unitario'])}'),
                        Text('Quantidade: ${item['quantidade']}'),
                        Text(
                            'Preço Total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(item['preco_unitario'] * item['quantidade'])}'),
                        const Divider(),
                        Text('Numero do lote: ${item['numero_lote']}'),
                        Text('Descrição: ${item['descricao_produto']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
