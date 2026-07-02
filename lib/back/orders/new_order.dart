import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/orders/finish_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class NewOrder {
  late String nome;
  late String cpf;
  late String telefone;
  late String tabelaprecoId;

  NewOrder({
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.tabelaprecoId,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'telefone': telefone,
      'nomepessoa': nome,
      'tabelapreco_id': tabelaprecoId
    };
  }

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      cpf: json['cpf'],
      telefone: json['telefone'],
      nome: json['nomepessoa'],
      tabelaprecoId: json['tabelapreco_id'],
    );
  }
}

class DataServiceNewOrder {
  static Future<Map<String, dynamic>?> sendDataOrder(
    BuildContext context,
    String urlBasic,
    String token,
    String cpfController,
    String telefonecontatoController,
    String nomeController,
    String pessoaid,
    String tabelaprecoId,
    String empresaId,
    String localId, {
    bool isBackground = false,
  }) async {
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
      'tabelapreco_id': tabelaprecoId,
      'empresa_id': empresaId,
      'local_id': localId,
    });

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        bool flagGerarPedido = prefs.getBool('flagGerarPedido') ?? false;

        var urlReturnOrder = Uri.parse(
            "$urlBasic/ideia/core/getdata/prevenda%20p%20WHERE%20p.local_id%20=%20'$localId'/");
        var responseReturnOrder =
            await http.get(urlReturnOrder, headers: {"Accept": "text/html"});
        final data = jsonDecode(responseReturnOrder.body);

        var dynamicKey = data['data'].keys.first;

        await Functions.justFinish(
            context,
            urlBasic,
            token,
            data['data'][dynamicKey][0]['prevenda_id'],
            data['data'][dynamicKey][0]['numero'].toString(),
            flagGerarPedido);
        return {
          'prevenda_id': data['data'][dynamicKey][0]['prevenda_id'],
          'numero': data['data'][dynamicKey][0]['numero'],
          'local_id': localId,
        };
      } else {
        if (!isBackground && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                'Erro ao abrir pedido: ${response.statusCode} - ${response.body}',
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      log('Erro durante a requisição: $e');
    }
    return null;
  }
}
