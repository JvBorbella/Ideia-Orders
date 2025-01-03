import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

class AddProduct {
  late String prevendaid;
  late String produtoid;
  late String complemento;
  late int quantidade;

  AddProduct({
    required this.prevendaid,
    required this.produtoid,
    required this.complemento,
    required this.quantidade,
  });

  Map<String, dynamic> toMap() {
    return {
      'prevenda_id': prevendaid,
      'produto_id': produtoid,
      'complemento': complemento,
      'quantidade': quantidade,
    };
  }

  factory AddProduct.fromJson(Map<String, dynamic> json) {
    return AddProduct(
      prevendaid: json['prevenda_id'],
      produtoid: json['produto_id'],
      complemento: json['complemento'],
      quantidade: json['quantidade'],
    );
  }
}

class DataServiceAddProduct {
  static Future<bool> sendDataOrder(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String produtoid,
    String complementoController,
    String quantidadeController,
    int flagunidadefracionada,
    int flagservico
  ) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novoitemprevenda');

    print(urlPost);
    print(token);
    print('Fracao? $flagunidadefracionada');
    print(quantidadeController);

    String substituirVirgulaPorPonto(String texto) {
      return texto.replaceAll(',', '.');
    }

    if (flagunidadefracionada == 1) {
      var headers = {
        'auth-token': token,
      };
      var body = jsonEncode({
        'prevenda_id': prevendaid,
        'produto_id': produtoid,
        'complemento': complementoController,
        'quantidade':
            double.parse(substituirVirgulaPorPonto(quantidadeController)),
            // 'flagservico': flagservico
      });

      print(body);

      try {
        var response = await http.post(
          urlPost,
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          if (responseBody['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
                content: Text(
                  responseBody['message'],
                  style: TextStyle(
                    fontSize: Style.SaveUrlMessageSize(context),
                    color: Style.tertiaryColor,
                  ),
                ),
                backgroundColor: Style.sucefullColor,
              ),
            );
            print('Dados enviados com sucesso com fração 1');
            print('Resposta do servidor: ${response.body}');
            return true; // Retorna true quando o produto é inserido com sucesso
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
                content: Text(
                  responseBody['message'],
                  style: TextStyle(
                    fontSize: Style.SaveUrlMessageSize(context),
                    color: Style.tertiaryColor,
                  ),
                ),
                backgroundColor: Style.errorColor,
              ),
            );
          }
        } else {
          print('Erro ao enviar dados: ${response.statusCode}');
          print('Resposta do servidor: ${response.body}');
        }
      } catch (e) {
        print('Erro durante a requisição: $e');
      }
    } else if (flagunidadefracionada == 0) {
      if (quantidadeController.contains(',') ||
          quantidadeController.contains('.') ||
          quantidadeController.contains('-') ||
          quantidadeController.contains('_')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Este produto não pode ser vendido fracionado!',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      } else {
        var headers = {
          'auth-token': token,
        };
        var body = jsonEncode({
          'prevenda_id': prevendaid,
          'produto_id': produtoid,
          'complemento': complementoController,
          'quantidade': int.parse(quantidadeController),
          // 'flagservico': flagservico
        });

        print(body);

        try {
          var response = await http.post(
            urlPost,
            headers: headers,
            body: body,
          );

          if (response.statusCode == 200) {
            var responseBody = jsonDecode(response.body);
            if (responseBody['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
                  content: Text(
                    responseBody['message'],
                    style: TextStyle(
                      fontSize: Style.SaveUrlMessageSize(context),
                      color: Style.tertiaryColor,
                    ),
                  ),
                  backgroundColor: Style.sucefullColor,
                ),
              );
              print('Dados enviados com sucesso com fração 0');
              print('Resposta do servidor: ${response.body}');
              return true; // Retorna true quando o produto é inserido com sucesso
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
                  content: Text(
                    responseBody['message'],
                    style: TextStyle(
                      fontSize: Style.SaveUrlMessageSize(context),
                      color: Style.tertiaryColor,
                    ),
                  ),
                  backgroundColor: Style.errorColor,
                ),
              );
            }
          } else {
            print('Erro ao enviar dados: ${response.statusCode}');
            print('Resposta do servidor: ${response.body}');
          }
        } catch (e) {
          print('Erro durante a requisição: $e');
        }
      }
    }
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
    //       content: Text(
    //         'Este produto não pode ser vendido fracionado!',
    //         style: TextStyle(
    //           fontSize: Style.SaveUrlMessageSize(context),
    //           color: Style.tertiaryColor,
    //         ),
    //       ),
    //       backgroundColor: Style.errorColor,
    //     ),
    //   );
    // }
    return false; // Retorna false quando o produto não é inserido
  }
}
