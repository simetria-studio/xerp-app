import 'package:flutter/material.dart';

class FormProvider extends ChangeNotifier {
  String leitura = '';
  String produto = '';
  String quantidade = '';
  String precoUnitario = '';
  String saldoAtual = '';

  void updateLeitura(String value) {
    leitura = value;
    notifyListeners();
  }

  void updateProduto(String value) {
    produto = value;
    notifyListeners();
  }

  void updateQuantidade(String value) {
    quantidade = value;
    notifyListeners();
  }

  void updatePrecoUnitario(String value) {
    precoUnitario = value;
    notifyListeners();
  }

  void updateSaldoAtual(String value) {
    saldoAtual = value;
    notifyListeners();
  }
}
