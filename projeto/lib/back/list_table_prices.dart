import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


//Código onde serão acessados os dados de vendas do dia.

class ListTablePrices {
  String? tabelapreco_id;
  String? nome;
  String? codigo;

  ListTablePrices({
    required this.tabelapreco_id,
    required this.nome,
    required this.codigo,
  });

  factory ListTablePrices.fromJson(Map<String, dynamic> json) {
    return ListTablePrices(
      tabelapreco_id: (json['tabelapreco_id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      codigo: (json['codigo'] ?? '').toString(),
    );
  }
}

class DataServiceListTablePrices {
  static Future<List<ListTablePrices>?> fetchDataListTablePrices(
    BuildContext context,
    String urlBasic,
    String token
  ) async {
    List<ListTablePrices>? tablePrices;

    try {
      var urlPost =
          Uri.parse('$urlBasic/ideia/prevenda/listatabelaprecos');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'auth-token': token,
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        print(response.body);

        if (jsonData.containsKey('data') && jsonData['data'].isNotEmpty) {
          tablePrices = (jsonData['data']['tabelapreco'] as List)
              .map((e) => ListTablePrices.fromJson(e))
              .toList();

          // paymentsCondition = paymentsCondition
          //     .where((payments) => payments.codigo == '0')
          //     .toList();

          // print(response.body);
        } else {
          print('Dados ausentes no JSON. PaymentsCondition');
        }
      }
    } catch (e) {
      print('Erro durante a requisição PaymentsCondition: $e');
    }
    return tablePrices;
  }
}
