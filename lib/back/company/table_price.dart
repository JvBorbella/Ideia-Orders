import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class TablePrice {
  String? tabelaprecoId;

  TablePrice({
    required this.tabelaprecoId,
  });

  factory TablePrice.fromJson(Map<String, dynamic> json) {
    return TablePrice(
      tabelaprecoId: (json['tabelapreco_id'] ?? '').toString(),
    );
  }
}

class DataServiceTablePrice {
  static Future<Map<String, String>?> fetchDataTablePrice(
      BuildContext context, String urlBasic, String empresaid) async {
    String? tabelaprecoId;

    try {
      var rawQuery = '''empresa%20e%20WHERE%20e.empresa_id=%20'$empresaid'/''';
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
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

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              tabelaprecoId = tablePrice['tabelapreco_id']?.toString();
            } else {
              log('Nenhum item encontrado na lista.');
            }
          } else {
            log('Mapa de dados está vazio.');
          }
        } else {
          log('Chave "data" não encontrada no JSON.');
        }
      } else {
        log('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição Ocorrencia: $e');
    }
    return {'tabelapreco_id': tabelaprecoId ?? ''};
  }
}

class DataServiceTablePriceId {
  static Future<Map<String, String>?> fetchDataTablePriceId(
      BuildContext context,
      String urlBasic,
      String tableprice,
      // tableprice_id
      ) async {
    String? tabelaprecoId;

    try {
      var rawQuery = '''tabelapreco%20WHERE%20(tabelapreco_id=%20'$tableprice'%20OR%20nome%20=%20'$tableprice')/''';
      // var endpointQuery = "tabelapreco WHERE nome = '$tableprice'/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

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

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              tabelaprecoId = tablePrice['tabelapreco_id']?.toString();

              // tableprice_id = tabelapreco_id;
            } else {
              log('Nenhum item encontrado na lista.');
            }
          } else {
            log('Mapa de dados está vazio.');
          }
        } else {
          log('Chave "data" não encontrada no JSON.');
        }
      } else {
        log('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição Ocorrencia: $e');
    }
    return {'tabelapreco_id': tabelaprecoId ?? ''};
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

            var tablePriceList = dataMap[dynamicKey] as List;
            if (tablePriceList.isNotEmpty) {
              var tablePrice = tablePriceList.first;
              nome = tablePrice['nome']?.toString();

            } else {
              log('Nenhum item encontrado na lista.');
            }
          } else {
            log('Mapa de dados está vazio.');
          }
        } else {
          log('Chave "data" não encontrada no JSON.');
        }
      } else {
        log('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição Ocorrencia: $e');
    }
    return {'nome': nome ?? ''};
  }
}
