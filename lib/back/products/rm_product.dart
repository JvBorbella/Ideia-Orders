import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';

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

    var headers = {
      'auth-token': token,
      // 'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'prevenda_id': prevendaid,
      'prevendaproduto_id': prevendaprodutoid,
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
          Message.showReturnOverlay(context, ColorsApp.sucefullColor,
              Icons.check_circle, responseBody['message']);
        } else {
          // Message.showReturnOverlay(context, ColorsApp.errorColor,
          //     Icons.check_circle, responseBody['message']);
        }
      } else {
        log('Resposta do servidor: ${response.body}');
      }
    } catch (e) {
      log('Erro durante a requisição: $e');
    }
  }
}
