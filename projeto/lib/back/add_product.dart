import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

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
        'quantidade': double.parse(substituirVirgulaPorPonto(quantidadeController)),
        'expedicao_id': expedicaoId,
      });

      try {
        var response = await http.post(
          urlPost,
          headers: headers,
          body: body,
        );

        print(body); // Debug: Imprime o corpo da requisição

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
    return false; // Retorna false quando o produto não é inserido
  }
}
