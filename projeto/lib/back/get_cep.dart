import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCep {
  static Future<void> getcep(
      String cepController,
      TextEditingController logradouroController,
      TextEditingController complementoController,
      TextEditingController bairroController,
      TextEditingController ufController,
      TextEditingController localidadeController,
      TextEditingController ibgeController,
      String ibge) async {
    try {
      var cep = cepController;
      var authorization = Uri.parse('https://viacep.com.br/ws/$cep/json/');
      var response = await http.get(authorization);

      print(authorization);

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var logradouro = responseBody['logradouro'];
        var complemento = responseBody['complemento'];
        var bairro = responseBody['bairro'];
        var localidade = responseBody['localidade'];
        var ibge = responseBody['ibge'];
        var uf = responseBody['uf'];

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('logradouro', logradouro);
        await sharedPreferences.setString('complemento', complemento);
        await sharedPreferences.setString('bairro', bairro);
        await sharedPreferences.setString('localidade', localidade);
        await sharedPreferences.setString('ibge', ibge);
        await sharedPreferences.setString('uf', uf);

        // Atualiza os controllers
        logradouroController.text = logradouro ?? '';
        complementoController.text = complemento ?? '';
        bairroController.text = bairro ?? '';
        localidadeController.text = localidade ?? '';
        ibgeController.text = ibge ?? '';
        ufController.text = uf ?? '';
        ibge = ibge ?? '';

        print(response.body);
      } else {
        print('Erro ao consultar o CEP. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a solicitação HTTP: $e');
    }
  }
}
