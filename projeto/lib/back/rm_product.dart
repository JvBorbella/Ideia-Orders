import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

class RmProduct {
  late String prevendaid;
  late String prevendaprodutoid;

  RmProduct({
    required this.prevendaid,
    required this.prevendaprodutoid,
  });

  Map<String, dynamic> toMap() {
    return {
      'prevenda_id': prevendaid,
      'prevendaproduto_id': prevendaprodutoid,
    };
  }

  factory RmProduct.fromJson(Map<String, dynamic> json) {
    return RmProduct(
      prevendaid: json['prevenda_id'],
      prevendaprodutoid: json['prevendaproduto_id'],
    );
  }
}

class DataServiceRmProduct {
  static Future<void> sendDataOrder(
    BuildContext context,
      String urlBasic,
      String token,
      String prevendaid,
      String prevendaprodutoid,
      ) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/removeritemprevenda');

    print(urlPost);
    print(token);

      var headers = {
      'auth-token': token,
      // 'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'prevenda_id': prevendaid,
      'prevendaproduto_id': prevendaprodutoid,
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
