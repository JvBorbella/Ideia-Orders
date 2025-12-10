import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class TablePrice {
  String? tabelapreco_id;

  TablePrice({
    required this.tabelapreco_id,
  });

  factory TablePrice.fromJson(Map<String, dynamic> json) {
    return TablePrice(
      tabelapreco_id: (json['tabelapreco_id'] ?? '').toString(),
    );
  }
}

class DataServiceTablePrice {
  static Future<Map<String, String>?> fetchDataTablePrice(
      BuildContext context, String urlBasic, String empresaid) async {
    String? tabelapreco_id;

    try {
      var rawQuery = '''empresa%20e%20WHERE%20e.empresa_id=%20'$empresaid'/''';
      var endpointQuery = "empresa e WHERE e.empresa_id = '$empresaid'/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data')) {
          // Obter a primeira chave dentro de 'data'
          var dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.isNotEmpty) {
            var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
            print('Chave dinâmica encontrada: $dynamicKey');

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              tabelapreco_id = tablePrice['tabelapreco_id']?.toString();
              print('TABELAPRECO: $tabelapreco_id');
            } else {
              print('Nenhum item encontrado na lista.');
            }
          } else {
            print('Mapa de dados está vazio.');
          }
        } else {
          print('Chave "data" não encontrada no JSON.');
        }
      } else {
        print('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição Ocorrencia: $e');
    }
    return {'tabelapreco_id': tabelapreco_id ?? ''};
  }
}

class DataServiceTablePriceId {
  static Future<Map<String, String>?> fetchDataTablePriceId(
      BuildContext context,
      String urlBasic,
      String tableprice,
      // tableprice_id
      ) async {
    String? tabelapreco_id;

    try {
      var rawQuery = '''tabelapreco%20WHERE%20nome=%20'$tableprice'/''';
      // var endpointQuery = "tabelapreco WHERE nome = '$tableprice'/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data')) {
          // Obter a primeira chave dentro de 'data'
          var dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.isNotEmpty) {
            var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
            print('Chave dinâmica encontrada: $dynamicKey');

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              tabelapreco_id = tablePrice['tabelapreco_id']?.toString();
              print('TABELAPRECO: $tabelapreco_id');

              // tableprice_id = tabelapreco_id;
            } else {
              print('Nenhum item encontrado na lista.');
            }
          } else {
            print('Mapa de dados está vazio.');
          }
        } else {
          print('Chave "data" não encontrada no JSON.');
        }
      } else {
        print('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição Ocorrencia: $e');
    }
    return {'tabelapreco_id': tabelapreco_id ?? ''};
  }
}

class DataServiceTablePriceName {
  static Future<Map<String, String>?> fetchDataTablePriceName(
      BuildContext context,
      String urlBasic,
      String tableprice,
      // tableprice_id
      ) async {
    String? nome;

    try {
      var rawQuery = '''tabelapreco%20WHERE%20tabelapreco_id=%20'$tableprice'/''';
      // var endpointQuery = "tabelapreco WHERE nome = '$tableprice'/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data')) {
          // Obter a primeira chave dentro de 'data'
          var dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.isNotEmpty) {
            var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
            print('Chave dinâmica encontrada: $dynamicKey');

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              nome = tablePrice['nome']?.toString();
              print('TABELAPRECO: $nome');

              // tableprice_id = tabelapreco_id;
            } else {
              print('Nenhum item encontrado na lista.');
            }
          } else {
            print('Mapa de dados está vazio.');
          }
        } else {
          print('Chave "data" não encontrada no JSON.');
        }
      } else {
        print('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição Ocorrencia: $e');
    }
    return {'nome': nome ?? ''};
  }
}
