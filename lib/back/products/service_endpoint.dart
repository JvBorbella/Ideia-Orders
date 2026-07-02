import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';

class ServiceEndpoint {
  late String produtoId;
  late String nome;
  late String codigo;
  late int flagexcluido;
  late dynamic precofinal;

  ServiceEndpoint({
    required this.produtoId,
    required this.nome,
    required this.codigo,
    required this.flagexcluido,
    required this.precofinal,
  });

  factory ServiceEndpoint.fromJson(Map<String, dynamic> json) {
    return ServiceEndpoint(
      produtoId: json['produto_id'] ?? '',
      nome: json['nome'] ?? '',
      codigo: json['codigo'] ?? '',
      flagexcluido: json['flagexcluido'] ?? 0,
      precofinal: json['precofinal'] is int
          ? (json['precofinal'] as int).toDouble()
          : json['precofinal'] is double
              ? json['precofinal'] as double
              : 0.0,
    );
  }
}

class DataServiceServices {
  static Future<List<ServiceEndpoint>?> fetchDataSevices(
      BuildContext context,
      String urlBasic,
      String token,
      String searchController,
      String tabelaprecoId) async {
    List<ServiceEndpoint>? services;

    try {
      var rawQuery =
          '''produto%20p%20LEFT%20JOIN%20produtotabelapreco%20pt%20ON%20p.produto_id%20=%20pt.produto_id%20AND%20pt.tabelapreco_id%20=%20'$tabelaprecoId'%20WHERE%20p.flagservico%20=%201%20AND%20p.flagexcluido%20%3C%3E%201%20AND%20p.flagativo%20=%201%20AND%20(p.codigo%20LIKE%20'$searchController%25'%20OR%20p.nome%20LIKE%20'$searchController%25')%20LIMIT%20100/''';
      // var endpointQuery =
      //     "produto p LEFT JOIN produtotabelapreco pt ON p.produto_id = pt.produto_id AND pt.tabelapreco_id = '$tabelapreco_id' WHERE p.flagservico = 1 AND p.flagexcluido <> 1 AND p.flagativo = 1 AND p.codigo LIKE ''$searchController%''/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      var response = await http.get(urlPost, headers: {
        'Accept': 'text/html',
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;

          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            services =
                dataList.map((e) => ServiceEndpoint.fromJson(e)).toList();

            services =
                services.where((service) => service.precofinal != 0.0).toList();
          } else {
            Message.showReturnOverlay(
                context, ColorsApp.errorColor, Icons.error, response.body);
          }
        } else {
          Message.showReturnOverlay(
              context, ColorsApp.errorColor, Icons.error, response.body);
        }
      } else {
        Message.showReturnOverlay(
            context, ColorsApp.errorColor, Icons.error, response.body);
      }
    } catch (e) {
      Message.showReturnOverlay(
          context, ColorsApp.errorColor, Icons.error, '$e');
    }

    return services;
  }
}

class ServiceEndpoint2 {
  late String nome;

  ServiceEndpoint2({
    required this.nome,
  });

  factory ServiceEndpoint2.fromJson(Map<String, dynamic> json) {
    return ServiceEndpoint2(
      nome: json['nome'] ?? '',
    );
  }
}

class Service2 {
  static Future<Map<String?, String?>> fetchDataProductDetails2(
      String urlBasic, String produtoId) async {
    String? nome;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/produto/$produtoId');

      var response = await http.get(urlPost, headers: {
        'Accept': 'text/html',
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('produto') &&
            jsonData['data']['produto'].isNotEmpty) {
          var serviceData = jsonData['data']['produto'][0];
          nome = serviceData['nome'];
        } else {
          log('Dados não encontrados');
        }
      } else {
        log('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição: $e');
    }

    return {
      'nome': nome,
    };
  }
}
