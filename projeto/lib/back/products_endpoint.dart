import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

class ProductsEndpoint {
  late String produtoid;
  late String nome;
  late String codigo;
  late String codigoean;
  late String unidade;
  late int flagunidadefracionada;
  late double precopromocional;
  late double precotabela;

  ProductsEndpoint({
    required this.produtoid,
    required this.nome,
    required this.codigo,
    required this.codigoean,
    required this.unidade,
    required this.flagunidadefracionada,
    required this.precopromocional,
    required this.precotabela,
  });

  factory ProductsEndpoint.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint(
      produtoid: json['produto_id'] ?? '',
      nome: json['nome'] ?? '',
      codigo: json['codigo'] ?? '',
      codigoean: json['codigoean'] ?? '',
      unidade: json['unidade'] ?? '',
      flagunidadefracionada: json['flagunidadefracionada'] ?? 0,
      precopromocional: (json['precopromocional'] as num).toDouble(),
      precotabela: (json['precotabela'] as num).toDouble(),
    );
  }
}

class DataServiceProducts {
  static Future<List<ProductsEndpoint>?> fetchDataProducts(
      BuildContext context, String urlBasic, String token, String text) async {
    List<ProductsEndpoint>? products;

    try {
      var urlPost =
          Uri.parse('$urlBasic/ideia/prevenda/listaprodutos?busca=$text');

      var response = await http.get(urlPost);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('produtos') &&
            jsonData['data']['produtos'].isNotEmpty) {
          products = (jsonData['data']['produtos'] as List)
              .map((e) => ProductsEndpoint.fromJson(e))
              .toList();

          products =
              products.where((product) => product.precotabela > 0.0).toList();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Produto não encontrado',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.errorColor,
            ),
          );
          print(
              'Dados não encontrados ProductsEndpoints - ${response.statusCode} ${response.body}');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return products;
  }
}

class ProductsEndpoint2 {
  late String nome;

  ProductsEndpoint2({
    required this.nome,
  });

  factory ProductsEndpoint2.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint2(
      nome: json['nome'] ?? '',
    );
  }
}

class ProductsService2 {
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
          var prevendaData = jsonData['data']['produto'][0];

          nome = prevendaData['nome'];
        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return {
      'nome': nome,
    };
  }
}
