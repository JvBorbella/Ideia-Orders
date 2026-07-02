import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/check_internet.dart';
import 'package:projeto/back/save_products.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';

class AddProduct {
  late String prevendaid;
  late String empresaId;
  late String produtoid;
  late String complemento;
  late int quantidade;
  late String expedicaoId;

  AddProduct({
    required this.prevendaid,
    required this.empresaId,
    required this.produtoid,
    required this.complemento,
    required this.quantidade,
    required this.expedicaoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'prevenda_id': prevendaid,
      'empresa_id': empresaId,
      'produto_id': produtoid,
      'complemento': complemento,
      'quantidade': quantidade,
    };
  }

  factory AddProduct.fromJson(Map<String, dynamic> json) {
    return AddProduct(
      prevendaid: json['prevenda_id'],
      empresaId: json['empresa_id'],
      produtoid: json['produto_id'],
      complemento: json['complemento'],
      quantidade: json['quantidade'],
      expedicaoId: json['expedicao_id'],
    );
  }
}

class DataServiceAddProduct {
  static Future<bool> sendDataOrder(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String empresaId,
    String produtoid,
    String complementoController,
    String quantidadeController,
    int flagunidadefracionada,
    int flagservico,
    String expedicaoId,
  ) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novoitemprevenda');

    String substituirVirgulaPorPonto(String texto) {
      return texto.replaceAll(',', '.');
    }

    if (flagunidadefracionada == 1) {
      var headers = {
        'auth-token': token,
      };
      var body = jsonEncode({
        'prevenda_id': prevendaid,
        'empresa_id': empresaId,
        'produto_id': produtoid,
        'complemento': complementoController,
        'quantidade':
            double.parse(substituirVirgulaPorPonto(quantidadeController)),
        'expedicao_id': expedicaoId,
      });
      var bodyMap = {
        'prevenda_id': prevendaid,
        'empresa_id': empresaId,
        'produto_id': produtoid,
        'complemento': complementoController,
        'quantidade':
            double.parse(substituirVirgulaPorPonto(quantidadeController)),
        'expedicao_id': expedicaoId,
      };

      final hasInternet = await hasInternetConnection();

      if (!hasInternet) {
        final SharedListService produtosStorage =
            SharedListService('produtos_list');
        await produtosStorage.addItem(bodyMap);
        Message.showReturnOverlay(
            context,
            ColorsApp.sucefullColor,
            Icons.check_circle,
            'Produto armazenado localmente devido à falta de conexão com a internet.');
        return true;
      } else {
        try {
          var response = await http.post(
            urlPost,
            headers: headers,
            body: body,
          );

          if (response.statusCode == 200) {
            var responseBody = jsonDecode(response.body);
            if (responseBody['success'] == true) {
              Message.showReturnOverlay(context, ColorsApp.sucefullColor,
                  Icons.check_circle, '${responseBody['message']}');
              return true; // Retorna true quando o produto é inserido com sucesso
            } else {
              Message.showReturnOverlay(context, ColorsApp.errorColor,
                  Icons.check_circle, '${responseBody['message']}');
            }
          } else {
            Message.showReturnOverlay(context, ColorsApp.errorColor,
                Icons.check_circle, response.body);
          }
        } catch (e) {
          Message.showReturnOverlay(
              context, ColorsApp.errorColor, Icons.check_circle, '$e');
        }
      }

      // List<Map<String, dynamic>> dataOrder = [bodyMap];
      // await salvarListaProdutos(dataOrder);
      // List<Map<String, dynamic>> listaSalva = await recuperarListaProduto();
      // if (listaSalva != []) {
      //   adicionarItemProduto(bodyMap);
      // }
      // print('sem Internet - $listaSalva');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     behavior: SnackBarBehavior.floating,
      //     padding: EdgeInsets.all(Responsive.h(context, 8)),
      //     content: Text(
      //       'Produto armazenado localmente devido à falta de conexão com a internet.',
      //       style: TextStyle(
      //         fontSize: Responsive.h(context, 10),
      //         color: ColorsApp.tertiaryColor,
      //       ),
      //     ),
      //     backgroundColor: ColorsApp.warningColor,
      //   ),
      // );
    } else if (flagunidadefracionada == 0) {
      if (quantidadeController.contains(',') ||
          quantidadeController.contains('.') ||
          quantidadeController.contains('-') ||
          quantidadeController.contains('_')) {
        Message.showReturnOverlay(context, ColorsApp.errorColor,
            Icons.check_circle, 'Este produto não pode ser vendido fracionado');
      } else {
        var headers = {
          'auth-token': token,
        };
        var body = jsonEncode({
          'prevenda_id': prevendaid,
          'produto_id': produtoid,
          'complemento': complementoController,
          'quantidade': int.parse(quantidadeController),
          'expedicao_id': expedicaoId,
          // 'flagservico': flagservico
        });
        var bodyMap = {
          'prevenda_id': prevendaid,
          'produto_id': produtoid,
          'complemento': complementoController,
          'quantidade': int.parse(quantidadeController),
          'expedicao_id': expedicaoId,
          // 'flagservico': flagservico
        };

        final hasInternet = await hasInternetConnection();

        if (!hasInternet) {
          final SharedListService produtosStorage =
              SharedListService('produtos_list');
          await produtosStorage.addItem(bodyMap);
          Message.showReturnOverlay(
              context,
              ColorsApp.warningColor,
              Icons.check_circle,
              'Produto armazenado localmente devido à falta de conexão com a internet.');
        } else {
          try {
            var response = await http.post(
              urlPost,
              headers: headers,
              body: body,
            );

            if (response.statusCode == 200) {
              var responseBody = jsonDecode(response.body);
              if (responseBody['success'] == true) {
                Message.showReturnOverlay(context, ColorsApp.sucefullColor,
                    Icons.check_circle, '${responseBody['message']}');
                return true; // Retorna true quando o produto é inserido com sucesso
              } else {
                Message.showReturnOverlay(context, ColorsApp.errorColor,
                    Icons.check_circle, '${responseBody['message']}');
              }
            } else {
              Message.showReturnOverlay(context, ColorsApp.errorColor,
                  Icons.check_circle, response.body);
            }
          } catch (e) {
            Message.showReturnOverlay(
                context, ColorsApp.errorColor, Icons.check_circle, '$e');
          }
        }

        // List<Map<String, dynamic>> dataOrder = [bodyMap];
        // await salvarListaProdutos(dataOrder);
        // List<Map<String, dynamic>> listaSalva = await recuperarListaProduto();
        // if (listaSalva != []) {
        //   adicionarItemProduto(bodyMap);
        // }
        // print('sem Internet - $listaSalva');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     behavior: SnackBarBehavior.floating,
        //     padding: EdgeInsets.all(Responsive.h(context, 8)),
        //     content: Text(
        //       'Produto armazenado localmente devido à falta de conexão com a internet.',
        //       style: TextStyle(
        //         fontSize: Responsive.h(context, 10),
        //         color: ColorsApp.tertiaryColor,
        //       ),
        //     ),
        //     backgroundColor: ColorsApp.warningColor,
        //   ),
        // );
      }
    }
    return false; // Retorna false quando o produto não é inserido
  }
}
