import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetCliente {
  static Future<void> getcliente(
    BuildContext context,
    String urlBasic, 
    TextEditingController nomeController, 
    TextEditingController cpfController,
    TextEditingController telefonecontatoController, 
    TextEditingController cepController, 
    TextEditingController logradouroController, 
    TextEditingController ufController, 
    TextEditingController bairroController, 
    TextEditingController complementoController,
  ) async {
    try {
      var cpf = cpfController.text;
      var authorization = Uri.parse('$urlBasic/ideia/core/pessoa/$cpf');
      var response = await http.get(
        authorization,
        headers: {
          'Accept': 'text/html', // Solicita JSON
        },
      );

      if (response.statusCode == 200) {

        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('pessoa') &&
            jsonData['data']['pessoa'].isNotEmpty) {
          
          var pessoaData = jsonData['data']['pessoa'][0]; // Alterado para acessar o primeiro item da lista

          // Garantindo que os dados são convertidos para String
          var nome = pessoaData['nome']?.toString() ?? '';
          var telefonecontato = pessoaData['telefonecontato']?.toString() ?? '';
          var cpfcliente = pessoaData['cpf']?.toString() ?? '';
          var endereco = pessoaData['endereco']?.toString() ?? '';
          var enderecocep = pessoaData['enderecocep']?.toString() ?? '';
          var uf = pessoaData['uf']?.toString() ?? '';
          var enderecobairro = pessoaData['enderecobairro']?.toString() ?? '';
          var enderecocomplemento = pessoaData['enderecocomplemento']?.toString() ?? '';

          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString('nome', nome);
          await sharedPreferences.setString('cpf', cpfcliente);
          await sharedPreferences.setString('telefonecontato', telefonecontato);
          await sharedPreferences.setString('enderecocep', enderecocep);
          await sharedPreferences.setString('endereco', endereco);
          await sharedPreferences.setString('uf', uf);
          await sharedPreferences.setString('enderecobairro', enderecobairro);
          await sharedPreferences.setString('enderecocomplemento', enderecocomplemento);

          // Atualiza os controllers
          nomeController.text = nome;
          cpfController.text = cpfcliente;
          telefonecontatoController.text = telefonecontato;
          cepController.text = enderecocep;
          logradouroController.text = endereco;
          ufController.text = uf;
          bairroController.text = enderecobairro;
          complementoController.text = enderecocomplemento;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Cliente não cadastrado',
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
        print('Erro ao consultar o CPF. Status Code: ${response.statusCode}');
        print('Resposta: ${response.body}'); // Verifique a resposta em caso de erro
      }
    } catch (e) {
      print('Erro durante a solicitação HTTP: $e');
    }
  }
}
