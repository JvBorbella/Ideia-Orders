import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetClienteNewOrder {
  static Future<void> getcliente(
    BuildContext context,
    String urlBasic,
    TextEditingController nomeController,
    TextEditingController cpfController,
    TextEditingController telefonecontatoController,
  ) async {
    try {
      var cpf = cpfController.text;
      var authorization = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpf');
      var response = await http.get(authorization);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('pessoa') &&
            jsonData['data']['pessoa'].isNotEmpty) {
          var pessoaData = jsonData['data']['pessoa']
              [0]; // Alterado para acessar o primeiro item da lista

          // Garantindo que os dados são convertidos para String
          var nome = pessoaData['nome']?.toString() ?? '';
          var telefonecontato = pessoaData['telefone']?.toString() ?? '';
          var cpfcliente = pessoaData['cpf']?.toString() ?? '';

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString('nome', nome);
          await sharedPreferences.setString('cpf', cpfcliente);
          await sharedPreferences.setString('telefone', telefonecontato);

          // Atualiza os controllers
          nomeController.text = nome;
          cpfController.text = cpfcliente;
          telefonecontatoController.text = telefonecontato;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                'Cliente não cadastrado',
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.errorColor,
            ),
          );
        }
      } else {
        log('Resposta: ${response.body}'); // Verifique a resposta em caso de erro
      }
    } catch (e) {
      log('Erro durante a solicitação HTTP: $e');
    }
  }
}
