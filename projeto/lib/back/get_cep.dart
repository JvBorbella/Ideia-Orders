import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCep {
  static Future<void> getcep(TextEditingController cepController, TextEditingController logradouroController,
      TextEditingController complementoController, TextEditingController bairroController, TextEditingController ufController) async {
    try {
      var cep = cepController.text;
      var authorization = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      var response = await http.get(authorization);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var logradouro = responseBody['logradouro'];
        var complemento = responseBody['complemento'];
        var bairro = responseBody['bairro'];
        var uf = responseBody['uf'];

        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('logradouro', logradouro);
        await sharedPreferences.setString('complemento', complemento);
        await sharedPreferences.setString('bairro', bairro);
        await sharedPreferences.setString('uf', uf);

        // Atualiza os controllers
        logradouroController.text = logradouro ?? '';
        complementoController.text = complemento ?? '';
        bairroController.text = bairro ?? '';
        ufController.text = uf ?? '';
      } else {
        print('Erro ao consultar o CEP. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a solicitação HTTP: $e');
    }
  }
}
