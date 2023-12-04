import 'package:flutter/material.dart';
import 'package:xerpapp/views/cadastro_orcemento_view.dart';
import 'package:xerpapp/views/lancamentos.dart';
import 'package:xerpapp/views/menu_escolha_view.dart';
import 'package:xerpapp/views/user_view.dart';

import '../class/get_user_info.dart';
import 'menu_bottom.dart'; // Importe o widget de menu personalizado

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  final _pages = [
    const LancamentosPage(),
    const MenuEscolha(),
    const CadastroOrcamento(),
    const LancamentosPage(),
    const UserPage(),
  ];

  User? userData;

  void getUserData() async {
    try {
      userData = await fetchUserData();
      if (userData != null) {
        print(userData);
      } else {
        print('Dados do usuário não encontrados.');
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _page,
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: Container(
        color: const Color.fromARGB(255, 250, 251, 255),
        margin: const EdgeInsets.only(bottom: 0),
        child: _pages[_page],
      ),
    );
  }
}
