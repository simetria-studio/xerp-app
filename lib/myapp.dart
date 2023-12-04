import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xerpapp/views/home_view.dart';
import 'package:xerpapp/views/login_view.dart';
import 'package:xerpapp/views/orcamento_view.dart';

import 'class/get_user_info.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  _fetchUserData() async {
    try {
      user = await fetchUserData();
      setState(
          () {}); // Atualiza o estado para refletir a obtenção dos dados do usuário
    } catch (e) {
      print('Erro ao buscar os dados do usuário: $e');
      // Adicione a manipulação de erros conforme necessário
    }
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(), // Verifica se o usuário está logado
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Se a verificação estiver em andamento, exiba um indicador de carregamento
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data!) {
            // Se o usuário estiver logado, redirecione para a tela Home
            return MaterialApp(
              title: 'X-ERP',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const HomePage(),
            );
          } else {
            // Se o usuário não estiver logado, exiba a tela de login
            return MaterialApp(
              title: 'XERP',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const LoginPage(),
              routes: {
                // '/': (context) => const HomePage(),
                '/orcamento': (context) => const Orcamento(),
              },
            );
          }
        }
      },
    );
  }

  Future<bool> _isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token != null;
  }
}
