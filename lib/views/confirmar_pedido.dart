import 'package:flutter/material.dart';
import 'package:xerpapp/views/orcamento_view.dart';

import 'home_view.dart';

class ConfirmarPedido extends StatefulWidget {
  final List<Map<String, dynamic>> orcamento;

  const ConfirmarPedido({Key? key, required this.orcamento}) : super(key: key);

  @override
  State<ConfirmarPedido> createState() => _ConfirmarPedidoState();
}

class _ConfirmarPedidoState extends State<ConfirmarPedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Ícone de seta para a esquerda
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage())),
        ),
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'CONFIRMAR PEDIDO',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumo do Orçamento:',
                style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: ListView.separated(
                itemCount: widget.orcamento.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (context, index) {
                  var item = widget.orcamento[index];
                  return ListTile(
                    leading:
                        const Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Produto: ${item['codigo_produto']}'),
                    subtitle: Text('Quantidade: ${item['quantidade']}'),
                    trailing: Text(
                      'R\$${item['total']}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Centraliza os botões
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Orcamento()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF043259),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
