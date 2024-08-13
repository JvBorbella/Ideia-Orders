import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto/front/components/style.dart';

class NewCustomer {
  static Future<void> getcliente(
    BuildContext context,
    String urlBasic,
    String token,
    String nomeController,
    String cpfController,
    String telefonecontatoController,
    String cepController,
    String bairroController,
    String logradouroController,
    String complementoController,
    String numeroController,
    String ibge,
    String uf
  ) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novocliente');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'cpf': cpfController,
      'nome': nomeController,
      'telefone': telefonecontatoController,
      'cep': cepController,
      'endereco': logradouroController,
      'endereconumero': numeroController,
      'complemento': complementoController,
      'bairro': bairroController,
      'codigocidade': ibge,
      'uf': uf,
    });

    print(body);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Cliente cadastrado com sucesso!',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Não foi possível cadastrar o cliente',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.errorColor,
            ),
          );
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }
}
