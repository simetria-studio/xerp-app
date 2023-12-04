import 'package:flutter/material.dart';
import 'package:xerpapp/views/orcamento_view.dart';
import 'package:xerpapp/views/pedidos.dart';
import 'package:xerpapp/views/produtos.view.dart';

import 'clientes.view.dart';

class MenuEscolha extends StatefulWidget {
  const MenuEscolha({super.key});

  @override
  State<MenuEscolha> createState() => _MenuEscolhaState();
}

class _MenuEscolhaState extends State<MenuEscolha> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('X-ERP'),
        backgroundColor: const Color(0xFF043259),
      ),
      body: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 250, 251, 255),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          padding: const EdgeInsets.all(20),
          children: [
            menuButton(
              icon: Icons.receipt_long,
              label: 'Orçamentos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Orcamento(),
                  ),
                );
              },
            ),
            menuButton(
              icon: Icons.shopping_bag,
              label: 'Pedidos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Pedido(),
                  ),
                );
              },
            ),
            menuButton(
              icon: Icons.group,
              label: 'Clientes',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Clientes(),
                  ),
                );
              },
            ),
            menuButton(
              icon: Icons.inventory_2,
              label: 'Produtos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Produtos(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget menuButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 5.0, // Adiciona sombra ao card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Arredonda os cantos do card
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF043259),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Arredonda os cantos do botão
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16, // Aumentado o tamanho da fonte
                fontFamily: 'Outfit',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
