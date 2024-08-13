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
  static Future<void> sendDataOrder(
    BuildContext context,
      String urlBasic,
      String token,
      String prevendaid,
      String produtoid,
      String complementoController,
      String quantidadeController,
      ) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novoitemprevenda');

    print(urlPost);
    print(token);

      var headers = {
      'auth-token': token,
      // 'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'prevenda_id': prevendaid,
      'produto_id': produtoid,
      'complemento': complementoController,
      'quantidade': double.parse(quantidadeController),
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
        print('Dados enviados com sucesso');
        print('Resposta do servidor: ${response.body}');
        }
        else {
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
