import 'package:flutter/material.dart';

class ClientesDetalhes extends StatelessWidget {
  final dynamic cliente;

  const ClientesDetalhes({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF043259),
        title: const Text(
          'Detalhes do cliente',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 245, 248, 250), // fundo mais suave
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            _buildCard([
              _sectionTitle('Dados Gerais'),
              _infoItem(Icons.info, 'Código do cliente:',
                  cliente['codigo_cliente'].toString()),
              _infoItem(
                  Icons.business, 'Razão social:', cliente['razao_social']),
              _infoItem(
                  Icons.store, 'Nome Fantasia:', cliente['nome_fantasia']),
              // ... Adicione os outros campos aqui da mesma maneira
              _sectionTitle('Endereço Completo'),
              _infoItem(Icons.location_on, 'Endereço:', cliente['endereco'],
                  cliente['numero']),
              _infoItem(Icons.map, 'CEP:', cliente['cep']),
              _infoItem(Icons.location_city, 'Bairro:', cliente['bairro']),
              _infoItem(Icons.location_city, 'Cidade/UF:', cliente['cidade'],
                  cliente['uf']),
              _infoItem(
                Icons.location_city,
                'Pais:',
                cliente['pais'],
              ),
              // ... Continuação
            ]),
            const SizedBox(height: 15),
            _buildCard([
              _sectionTitle('Contatos'),
              _infoItem(Icons.phone, 'Telefone:', cliente['telefone'],
                  cliente['telefone2']),
              _infoItem(Icons.phone_iphone, 'Celular:', cliente['celular1'],
                  cliente['celular2']),
              _infoItem(Icons.mail, 'E-mail:', cliente['e_mail']),
              // ... Continuação
            ]),
            const SizedBox(height: 15),
            _buildCard([
              _sectionTitle('Crédito'),
              _infoItem(Icons.account_balance, 'Limite de crédito:',
                  cliente['limite_credito'].toString()),
              _infoItem(Icons.account_balance, 'Saldo devedor:',
                  cliente['saldo_devedor_atual'].toString()),
              // ... Continuação
            ]),
            const SizedBox(height: 25),
            // _actionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF043259),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String label, String value,
      [String? secondValue]) {
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
                  if (secondValue != null) ...[
                    TextSpan(text: ', $secondValue'), // Exibe após uma vírgula
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.receipt),
        label: const Text('Ver Pedidos'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Aviso'),
                content: const Text('Nenhum pedido encontrado!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Fechar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF043259),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}
