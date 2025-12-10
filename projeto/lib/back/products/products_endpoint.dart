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
  //late double precopromocional;
  late double precofinal;

  ProductsEndpoint({
    required this.produtoid,
    required this.nome,
    required this.codigo,
    required this.codigoean,
    required this.unidade,
    required this.flagunidadefracionada,
    //required this.precopromocional,
    required this.precofinal,
  });

  factory ProductsEndpoint.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint(
      produtoid: json['produto_id'] ?? '',
      nome: json['nome'] ?? '',
      codigo: json['codigo'] ?? '',
      codigoean: json['eantributavel'] ?? '',
      unidade: json['nome_1'] ?? '',
      flagunidadefracionada: json['flagunidadefracionada'] ?? 0,
      //precopromocional: (json['precopromocional'] as num).toDouble(),
      precofinal: (json['precofinal'] as num).toDouble(),
    );
  }
}

String _prepareText(String input) {
  // Remove espaços extras nas pontas
  input = input.trim();

  // Divide em palavras ignorando múltiplos espaços
  final words = input.split(RegExp(r'\s+'));

  // Envolve cada palavra entre %
  final wrapped = words.map((w) => '%$w%').join(' ');

  return wrapped;
}

class DataServiceProducts {
  static Future<List<ProductsEndpoint>?> fetchDataProducts(
      BuildContext context, String urlBasic, String token, String text, String tabelapreco_id) async {
    List<ProductsEndpoint>? products;

    final treatedText = _prepareText(text);

    try {
      var urlPost = Uri.parse(
        '''$urlBasic/ideia/core/getdata/produto%20p%20LEFT%20JOIN%20produtotabelapreco%20pt%20ON%20p.produto_id%20=%20pt.produto_id%20AND%20pt.tabelapreco_id%20=%20'$tabelapreco_id'%20LEFT%20JOIN%20unidademedida%20u%20ON%20u.unidademedida_id%20=%20p.unidademedida_id%20LEFT%20JOIN%20produtounidademedida%20pu%20ON%20pu.produto_id%20=%20p.produto_id%20WHERE%20p.flagexcluido%20%3C%3E%201%20AND%20(p.codigo%20LIKE%20'$treatedText'%20OR%20p.eantributavel%20LIKE%20'$treatedText'%20OR%20p.nome%20LIKE%20'$treatedText'%20OR%20pu.codigo%20LIKE%20'$treatedText'%20OR%20pu.eancomercial%20LIKE%20'$treatedText')%20AND%20pt.precofinal%20IS%20NOT%20NULL%20LIMIT%2050/'''
       // '$urlBasic/ideia/prevenda/listaprodutos?busca=$text'
      );

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      print('URL de requisição: $urlPost');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;
          print('Chave dinâmica encontrada: $dynamicKey');

          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            products = dataList.map((e) => ProductsEndpoint.fromJson(e)).toList();

            products = products.where((product) => product.precofinal != 0.0).toList();

            print('A chave dinâmica contém uma lista válida.');
          } else {
            print('A chave dinâmica não contém uma lista válida.');
          }
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
