import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class ListTablePrices {
  String? tabelaprecoId;
  String? nome;
  String? codigo;

  ListTablePrices({
    required this.tabelaprecoId,
    required this.nome,
    required this.codigo,
  });

  factory ListTablePrices.fromJson(Map<String, dynamic> json) {
    return ListTablePrices(
      tabelaprecoId: (json['tabelapreco_id'] ?? '').toString(),
      nome: (json['nome'] ?? '').toString(),
      codigo: (json['codigo'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tabelapreco_id': tabelaprecoId,
      'nome': nome,
      'codigo': codigo,
    };
  }
}

class DataServiceListTablePrices {
  static Future<List<ListTablePrices>?> fetchDataListTablePrices(
      BuildContext context,
      String urlBasic,
      String empresaId,
      String token) async {
    List<ListTablePrices>? tablePrices;

    try {
      var urlPost = Uri.parse(
          '''$urlBasic/ideia/core/getdata/tabelapreco%20t%20LEFT%20JOIN%20tabelaprecoempresa%20te%20ON%20te.tabelapreco_id%20=%20t.tabelapreco_id%20WHERE%20te.empresa_id%20=%20'$empresaId'%20AND%20COALESCE(t.flagexcluido,%200)%20<>%201%20AND%20te.flagativo%20=%201/''');

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;
          //
          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            tablePrices =
                dataList.map((e) => ListTablePrices.fromJson(e)).toList();
          } else {
            log('A chave dinâmica não contém uma lista válida.');
          }
        }
      } else {
        log('Erro ao carregar dados (list_table_prices.dart): ${response.body}');
      }
    } catch (e) {
      log('Erro durante a requisição PaymentsCondition: $e');
    }
    return tablePrices;
  }
}
