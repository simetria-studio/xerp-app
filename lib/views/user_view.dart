import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_view.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<bool> _confirmLogout() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmação'),
            content: const Text('Deseja realmente sair?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(
                    false), // Retorna "false" para o showDialog para indicar que não deseja sair
                child: const Text('CANCELAR'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(
                    true), // Retorna "true" para o showDialog para indicar que deseja sair
                child: const Text('SAIR'),
              ),
            ],
          ),
        ) ??
        false; // O "??" garante que, se nada for retornado do showDialog (por exemplo, se o usuário simplesmente clicar fora da caixa de diálogo para fechá-la), retornaremos "false" por padrão.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF83848B),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(
            child: Text(
              'Pagina do usuário',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                bool confirm = await _confirmLogout();
                if (confirm) {
                  await _logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Cor do texto
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Borda arredondada
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12), // Espaçamento interno
                textStyle: const TextStyle(
                  fontSize: 18, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Espessura da fonte
                ),
                elevation: 5, // Sombra
              ),
              child: const Text('SAIR'),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _logout() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
