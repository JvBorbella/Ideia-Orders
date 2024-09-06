import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

class NewOrder {
  late String nome;
  late String cpf;
  late String telefone;

  NewOrder({
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'telefone': telefone,
      'nomepessoa': nome,
    };
  }

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      cpf: json['cpf'],
      telefone: json['telefone'],
      nome: json['nomepessoa'],
    );
  }
}

class DataServiceNewOrder {
  static Future<void> sendDataOrder(
    BuildContext context,
    String urlBasic,
    String token,    
    String cpfController,
    String telefonecontatoController,
    String nomeController,
    String pessoaid,
  ) async {
    String getUnmaskedText(String maskedText) {
      // Remove todos os caracteres não numéricos
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var telDefault = getUnmaskedText(telefonecontatoController);

    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novopedido');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'pessoa_id': pessoaid,
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
    });

    print(headers);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        print('Resposta do servidor: ${response.body}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Erro ao abrir pedido: ${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
        print('Erro ao enviar dados: ${response.statusCode}');
        print('Resposta do servidor: ${response.body}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }
}
