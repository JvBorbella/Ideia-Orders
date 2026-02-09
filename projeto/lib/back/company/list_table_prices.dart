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
  
  Map<String, dynamic> toJson() {
    return {
      'tabelapreco_id': tabelapreco_id,
      'nome': nome,
      'codigo': codigo,
    };
  }
}

class DataServiceListTablePrices {
  static Future<List<ListTablePrices>?> fetchDataListTablePrices(
    BuildContext context,
    String urlBasic,
    String empresa_id,
    String token
  ) async {
    List<ListTablePrices>? tablePrices;

    try {
      var urlPost =
          Uri.parse('''$urlBasic/ideia/core/getdata/tabelapreco%20t%20LEFT%20JOIN%20tabelaprecoempresa%20te%20ON%20te.tabelapreco_id%20=%20t.tabelapreco_id%20WHERE%20te.empresa_id%20=%20'$empresa_id'%20AND%20COALESCE(t.flagexcluido,%200)%20<>%201%20AND%20te.flagativo%20=%201/''');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      print('List table prices ${response.statusCode}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;
          print('Chave dinâmica encontrada: $dynamicKey');

          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            tablePrices = dataList.map((e) => ListTablePrices.fromJson(e)).toList();

            print('A chave dinâmica contém uma lista válida.');
            //print(response.body);
          } else {
            print('A chave dinâmica não contém uma lista válida.');
          }
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição PaymentsCondition: $e');
    }
    return tablePrices;
  }
}
