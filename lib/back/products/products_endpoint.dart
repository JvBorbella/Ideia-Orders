import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsEndpoint {
  late String produtounidademedidaId;
  late String produtoid;
  late String nome;
  //late String complemento;
  late String codigo;
  // late String codigo_2;
  late String codigoean;
  late String unidade;
  late String imagem;
  late int flagunidadefracionada;
  //late double precopromocional;
  late double precofinal;
  late String aliquotaacrescimodesconto;
  late String quantidadeEstq;
  late String quantidadeUnMedida;

  ProductsEndpoint({
    required this.produtoid,
    required this.produtounidademedidaId,
    required this.nome,
    //required this.complemento,
    required this.codigo,
    // required this.codigo_2,
    required this.codigoean,
    required this.unidade,
    required this.imagem,
    required this.flagunidadefracionada,
    //required this.precopromocional,
    required this.precofinal,
    required this.aliquotaacrescimodesconto,
    required this.quantidadeEstq,
    required this.quantidadeUnMedida,
  });

  factory ProductsEndpoint.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint(
      produtounidademedidaId: json['coluna_produtounidademedida_id'] ?? '',
      produtoid: json['produto_id'] ?? '',
      // produtoid_2: json['produto_id_2'] ?? '',
      nome: json['nome'] ?? '',
      //complemento: json['coluna_complemento'] ?? '',
      codigo: json['codigo'] ?? json['eantributavel'] ?? '',
      // codigo_2: json['codigo_2'] ?? '',
      codigoean: json['eantributavel'] ?? '',
      unidade: json['unidade'] ?? '',
      imagem: json['imagem'] ?? '',
      flagunidadefracionada: json['flagunidadefracionada'] ?? 0,
      //precopromocional: (json['precopromocional'] as num).toDouble(),
      precofinal: (json['precofinal'] ?? 0.0 as num).toDouble(),
      aliquotaacrescimodesconto: json['coluna_aliquotaacrescimodesconto'] ==
              'coluna_aliquotaacrescimodesconto'
          ? '0.0'
          : (json['coluna_aliquotaacrescimodesconto'] ?? '0.0'),
      quantidadeEstq:
          json['quantidade'] == '' ? '0.0' : json['quantidade'] ?? '0.0',
      quantidadeUnMedida: json['coluna_quantidade'] == 'coluna_quantidade'
          ? '0.0'
          : json['coluna_quantidade'] ?? '0.0',
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
      BuildContext context,
      String urlBasic,
      String token,
      String text,
      String tabelaprecoId,
      String empresaId) async {
    List<ProductsEndpoint>? products;

    final treatedText = Uri.encodeComponent(_prepareText(text));

    try {
      var urlPost = Uri.parse(
          "$urlBasic/ideia/core/getdata/(SELECT%20'coluna_produtounidademedida_id',%20p.produto_id,%20p.codigo,%20p.eantributavel,%20p.nome,%20u.abreviacao%20AS%20unidade,%20u.flagunidadefracionada,%20pt.precofinal,%20p.imagem_id%20AS%20imagem,%20pe.quantidade,%20'coluna_aliquotaacrescimodesconto',%20'coluna_quantidade'%20FROM%20produto%20p%20INNER%20JOIN%20produtotabelapreco%20pt%20ON%20p.produto_id%20=%20pt.produto_id%20AND%20pt.tabelapreco_id%20=%20'$tabelaprecoId'%20INNER%20JOIN%20unidademedida%20u%20ON%20u.unidademedida_id%20=%20p.unidademedida_id%20INNER%20JOIN%20produtoestoque%20pe%20ON%20pe.produto_id%20=%20p.produto_id%20INNER%20JOIN%20empresa%20e%20ON%20e.empresa_id%20=%20'$empresaId'%20WHERE%20COALESCE(p.flagexcluido,%200)%20<>%201%20AND%20pe.empresa_id%20=%20'$empresaId'%20AND%20pe.estoque_id%20=%20e.estoque_id%20and%20pt.precofinal%20IS%20NOT%20NULL%20AND%20(p.codigo%20LIKE%20'$treatedText'%20OR%20p.eantributavel%20LIKE%20'$treatedText'%20OR%20p.nome%20LIKE%20'$treatedText')%20UNION%20SELECT%20pu.produtounidademedida_id,%20pu.produto_id,%20pu.codigo,%20pu.eancomercial,%20concat(p.nome,' ',pu.complemento),%20um.abreviacao%20AS%20unidade,%20um.flagunidadefracionada,%20Cast((pu.quantidade%20*%20pt.precofinal)%20+%20((pu.quantidade%20*%20pt.precofinal)%20*%20pu.aliquotaacrescimodesconto)*0.01%20as%20decimal(15,2))%20precofinal,%20p.imagem_id%20AS%20imagem,%20'',%20pu.aliquotaacrescimodesconto,%20pu.quantidade%20FROM%20produtounidademedida%20pu%20INNER%20JOIN%20produto%20p%20ON%20p.produto_id%20=%20pu.produto_id%20LEFT%20JOIN%20unidademedida%20um%20ON%20um.unidademedida_id%20=%20pu.unidademedida_id%20INNER%20JOIN%20produtotabelapreco%20pt%20ON%20pt.produto_id%20=%20pu.produto_id%20INNER%20JOIN%20tabelapreco%20t%20ON%20t.tabelapreco_id%20=%20pt.tabelapreco_id%20WHERE%20t.tabelapreco_id%20=%20'$tabelaprecoId'%20AND%20pt.precofinal%20IS%20NOT%20NULL%20AND%20(pu.codigo%20LIKE%20'$treatedText'%20OR%20pu.eancomercial%20LIKE%20'$treatedText'%20OR%20p.codigo%20LIKE%20'$treatedText'%20OR%20p.eantributavel%20LIKE%20'$treatedText'%20OR%20p.nome%20LIKE%20'$treatedText')%20LIMIT%2050)%20AS%20p/"
          //produto%20p%20INNER%20JOIN%20produtotabelapreco%20pt%20ON%20p.produto_id%20=%20pt.produto_id%20AND%20pt.tabelapreco_id%20=%20'$tabelapreco_id'%20INNER%20JOIN%20unidademedida%20u%20ON%20u.unidademedida_id%20=%20p.unidademedida_id%20INNER%20JOIN%20produtoempresa%20pe%20ON%20pe.produto_id%20=%20p.produto_id%20WHERE%20COALESCE(p.flagexcluido,%200)%20%3C%3E%201%20AND%20(p.codigo%20LIKE%20'$treatedText'%20OR%20p.eantributavel%20LIKE%20'$treatedText'%20OR%20p.nome%20LIKE%20'$treatedText')%20AND%20pe.empresa_id='$empresaId'%20AND%20pt.precofinal%20IS%20NOT%20NULL%20LIMIT%2050/"
          );

      // var urlProdutoUnMedida = Uri.parse(
      //     "$urlBasic/ideia/core/getdata/produtounidademedida%20pu%20INNER%20JOIN%20produto%20p%20ON%20(%20p.produto_id%20=%20pu.produto_id%20)%20LEFT%20JOIN%20unidademedida%20um%20ON%20(um.unidademedida_id%20=%20pu.unidademedida_id)%20INNER%20JOIN%20produtotabelapreco%20pt%20ON%20(%20pt.produto_id%20=%20pu.produto_id%20)%20INNER%20JOIN%20tabelapreco%20t%20ON%20(t.tabelapreco_id%20=%20pt.tabelapreco_id)%20WHERE%20(1=1)%20AND%20t.tabelapreco_id%20=%20'$tabelapreco_id'%20AND%20(pu.codigo%20LIKE%20'$treatedText'%20OR%20pu.eancomercial%20LIKE%20'$treatedText'%20OR%20p.codigo%20LIKE%20'$treatedText'%20OR%20p.eantributavel%20LIKE%20'$treatedText'%20OR%20p.nome%20LIKE%20'$treatedText')%20ORDER%20BY%20um.codigo/");

      var responses = await Future.wait([
        http.get(urlPost, headers: {'Accept': 'text/html'}),
        // http.get(urlProdutoUnMedida, headers: {'Accept': 'text/html'}),
      ]);

      var responseProdutos = responses[0];
      //    var responseUnidade = responses[1];

      if (responseProdutos.statusCode ==
              200 /*&&
          responseUnidade.statusCode == 200*/
          ) {
        List<ProductsEndpoint> listaFinal = [];
        List<ProductsEndpoint> listaPrincipal = []; // primeira requisição
        //List<ProductsEndpoint> listaUnidades = []; // segunda requisição

        // -------------------------
        // PRIMEIRA REQUISIÇÃO
        // -------------------------
        var jsonData1 = json.decode(responseProdutos.body);

        if (jsonData1.containsKey('data') && jsonData1['data'] is Map) {
          var dynamicKey = jsonData1['data'].keys.first;
          var dataList = jsonData1['data'][dynamicKey];

          if (dataList != null && dataList is List) {
            listaPrincipal =
                dataList.map((e) => ProductsEndpoint.fromJson(e)).toList();
            listaFinal.addAll(listaPrincipal);
          }
        }

        // -------------------------
        // SEGUNDA REQUISIÇÃO
        // -------------------------
        // var jsonData2 = json.decode(responseUnidade.body);

        // if (jsonData2.containsKey('data') && jsonData2['data'] is Map) {
        //   var dynamicKey = jsonData2['data'].keys.first;
        //   var dataList = jsonData2['data'][dynamicKey];

        //   if (dataList != null && dataList is List) {
        //     listaUnidades =
        //         dataList.map((e) => ProductsEndpoint.fromJson(e)).toList();
        //     listaFinal.addAll(listaUnidades);
        //   }
        // }

        // if (listaPrincipal.isEmpty) {
        //   for (var unidade in listaUnidades) {
        //     final valorTotalUnMed = unidade.quantidadeUnMedida * unidade.precofinal;
        //     final valorProdUnMedida =
        //         (valorTotalUnMed * (unidade.aliquotaacrescimodesconto / 100)) +
        //             valorTotalUnMed;
        //     listaFinal.add(
        //       ProductsEndpoint(
        //         produtoid: unidade.produtoid,
        //         produtoid_2: unidade.produtoid_2,
        //         nome: '${unidade.nome} ${unidade.complemento}',
        //         complemento: unidade.complemento,
        //         codigo: unidade.codigo,
        //         codigo_2: unidade.codigo_2,
        //         codigoean: unidade.codigoean,
        //         unidade: unidade.unidade,
        //         flagunidadefracionada: unidade.flagunidadefracionada,
        //         precofinal: valorProdUnMedida,
        //         aliquotaacrescimodesconto: unidade.aliquotaacrescimodesconto,
        //         quantidadeEstq: unidade.quantidadeEstq,
        //         quantidadeUnMedida: unidade.quantidadeUnMedida,
        //       ),
        //     );
        //   }
        // }

        // for (var produto in listaPrincipal) {
        //   final unidades = listaUnidades
        //       .where((u) => u.produtoid == produto.produtoid)
        //       .toList();

        //   if (unidades.isEmpty) {
        //     listaFinal.add(produto);
        //   } else {
        //     for (var unidade in unidades) {
        //       final valorProdUnMedida = ((produto.precofinal *
        //               (unidade.aliquotaacrescimodesconto / 100)) +
        //           produto.precofinal);
        //       listaFinal.add(
        //         ProductsEndpoint(
        //           produtoid: produto.produtoid,
        //           produtoid_2: produto.produtoid_2,
        //           nome: unidade.produtoid == produto.produtoid
        //               ? '${produto.nome} ${unidade.complemento}'
        //               : produto.nome,
        //           complemento: unidade.complemento,
        //           codigo: unidade.complemento != null
        //               ? unidade.codigo
        //               : produto.codigo,
        //           codigo_2: produto.codigo_2,
        //           codigoean: produto.codigoean,
        //           unidade: produto.unidade,
        //           flagunidadefracionada: produto.flagunidadefracionada,
        //           precofinal: unidade.complemento != null
        //               ? valorProdUnMedida
        //               : produto.precofinal,
        //           aliquotaacrescimodesconto: produto.aliquotaacrescimodesconto,
        //           quantidadeEstq: produto.quantidadeEstq,
        //           quantidadeUnMedida: unidade.quantidadeUnMedida,
        //         ),
        //       );
        //     }
        //   }
        // }
        products = listaFinal;
      } else {
        log('${responseProdutos.body}');
      }
    } catch (e) {
      log('Erro durante a requisição: $e');
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
