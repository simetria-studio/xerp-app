import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/get_user_info.dart';

class LancamentosPage extends StatefulWidget {
  const LancamentosPage({super.key});

  @override
  State<LancamentosPage> createState() => _LancamentosPageState();
}

class _LancamentosPageState extends State<LancamentosPage> {
  User? userData;
  String? user;
  String? razao_social;
  String? codigo_empresa;
  final StreamController _reloadController = StreamController.broadcast();
  Timer? _timer;
  // Contador de reconstrução
  int _rebuildCounter = 0;

  void getFetchData() async {
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

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userNome = prefs.getString('nome_usuario');
    String? codigoEmpresa = prefs.getString('codigo_empresa');
    String? razaoSocial = prefs.getString('razao_social');
    print(razaoSocial);
    setState(() {
      user = userNome;
      razao_social = razaoSocial;
      codigo_empresa = codigoEmpresa;

      // Incrementa o contador para forçar a reconstrução
      _rebuildCounter++;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getFetchData();

    _reloadController.stream.listen((event) {
      getFetchData();
      getUserData();
    });

    // Configuração do Timer para emitir um evento a cada 4 segundos
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _reloadController.add(true);
    });
  }

  @override
  void dispose() {
    _reloadController.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Bem-vindo ao X-ERP')),
        backgroundColor: const Color(0xFF043259),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF043259),
                    size: 50,
                  ),
                  title: Text(
                    'Olá, $user 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF043259),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Empresa atual:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF043259),
                        ),
                      ),
                      Text(
                        '$razao_social',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF043259),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Código:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF043259),
                        ),
                      ),
                      Text(
                        '$codigo_empresa',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF043259),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
