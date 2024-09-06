import 'dart:convert';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
    TextEditingController numeroController,
    TextEditingController complementoController,
    TextEditingController cidadeController,
    TextEditingController emailController,
  ) async {
    try {
      String getUnmaskedText(String maskedText) {
        // Remove todos os caracteres não numéricos
        return maskedText.replaceAll(RegExp(r'\D'), '');
      }

      var cpf = cpfController.text;
      var cpfdefault = getUnmaskedText(cpf);
      var authorization = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpfdefault');
      var response = await http.get(
        authorization,
        headers: {
          // 'auth-token': token, // Solicita JSON
        },
      );
      print(cpfdefault);
      print(authorization);

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
          var endereco = pessoaData['endereco']?.toString() ?? '';
          var enderecocep = pessoaData['enderecocep']?.toString() ?? '';
          var uf = pessoaData['uf']?.toString() ?? '';
          var enderecobairro = pessoaData['enderecobairro']?.toString() ?? '';
          var enderecocidade = pessoaData['enderecocidade']?.toString() ?? '';
          var endereconumero = pessoaData['endereconumero']?.toString() ?? '';
          var enderecocomplemento = pessoaData['enderecocomplemento']?.toString() ?? '';
          var email = pessoaData['emailcontato']?.toString() ?? '';

          // SharedPreferences sharedPreferences =
          //     await SharedPreferences.getInstance();
          // await sharedPreferences.setString('nome', nome);
          // await sharedPreferences.setString('cpf', cpfcliente);
          // await sharedPreferences.setString('telefone', telefonecontato);
          // await sharedPreferences.setString('enderecocep', enderecocep);
          // await sharedPreferences.setString('endereco', endereco);
          // await sharedPreferences.setString('uf', uf);
          // await sharedPreferences.setString('enderecobairro', enderecobairro);
          // await sharedPreferences.setString('enderecocidade', enderecocidade);
          // await sharedPreferences.setString('endereconumero', endereconumero);
          // await sharedPreferences.setString(
          //     'enderecocomplemento', enderecocomplemento);

          var cpfFormatado = MaskedInputFormatter('###.###.###-##').formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: cpfcliente),
          ).text;

          var telFormatado = MaskedInputFormatter('(##) #####-####').formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: telefonecontato),
          ).text;

          var cepFormatado = MaskedInputFormatter('#####-###').formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: enderecocep),
          ).text;

          // Atualiza os controllers
          nomeController.text = nome;
          cpfController.text = cpfFormatado;
          telefonecontatoController.text = telFormatado;
          cepController.text = cepFormatado;
          logradouroController.text = endereco;
          ufController.text = uf;
          bairroController.text = enderecobairro;
          cidadeController.text = enderecocidade;
          numeroController.text = endereconumero;
          complementoController.text = enderecocomplemento;
          emailController.text = email;
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
        print(
            'Resposta: ${response.body}'); // Verifique a resposta em caso de erro
      }
    } catch (e) {
      print('Erro durante a solicitação HTTP: $e');
    }
  }
}

class GetCliente2 {
  late String pessoaid;
  late String nome;
  late String cpf;
  late String codigo;
  late String telefone;
  late String endereco;
  late String uf;
  late String enderecobairro;
  late String enderecocidade;
  late String endereconumero;
  late String enderecocomplemento;
  late String enderecocep;
  late String email;

  GetCliente2({
    required this.pessoaid,
    required this.nome,
    required this.cpf,
    required this.codigo,
    required this.telefone,
    required this.endereco,
    required this.uf,
    required this.enderecobairro,
    required this.enderecocidade,
    required this.endereconumero,
    required this.enderecocomplemento,
    required this.enderecocep,
    required this.email
  });

  factory GetCliente2.fromJson(Map<String, dynamic> json) {
    return GetCliente2(
      pessoaid: json['pessoa_id'] ?? '',
      nome: json['nome'] ?? '',
      codigo: json['codigo'] ?? '',
      cpf: json['cpf'] ?? '',
      telefone: json['telefone'] ?? '',
      endereco: json['endereco'] ?? '',
      enderecocep: json['enderecocep'] ?? '',
      enderecobairro: json['enderecobairro'] ?? '',
      enderecocidade: json['enderecocidade'] ?? '',
      endereconumero: json['endereconumero'] ?? '',
      enderecocomplemento: json['enderecocomplemento'] ?? '',
      uf: json['uf'] ?? '',
      email: json['emailcontato'] ?? ''
    );
  }
}

class DataServiceCliente2 {
  static Future<Map<String, String>> fetchDataCliente2(
      String urlBasic, String cpfcnpj, String token) async {
    String pessoaid = '';
    String nome = '';
    String codigo = '';
    String cpf = '';
    String telefone = '';
    String endereco = '';
    String uf = '';
    String enderecocomplemento = '';
    String enderecobairro = '';
    String enderecocidade = '';
    String endereconumero = '';
    String enderecocep = '';
    String email = '';

    try {

       String getUnmaskedText(String maskedText) {
        // Remove todos os caracteres não numéricos
        return maskedText.replaceAll(RegExp(r'\D'), '');
      }

      var cpf = cpfcnpj;
      var cpfdefault = getUnmaskedText(cpf);

      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpfdefault');
      var response = await http.get(urlPost, headers: {
        // 'Accept': 'text/html',
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('pessoa') &&
            jsonData['data']['pessoa'].isNotEmpty) {
          var pessoaData = jsonData['data']['pessoa'][0];

          pessoaid = pessoaData['pessoa_id']?.toString() ?? '';
          nome = pessoaData['nome']?.toString() ?? '';
          codigo = pessoaData['codigo']?.toString() ?? '';
          cpf = pessoaData['cpf']?.toString() ?? '';
          telefone = pessoaData['telefone']?.toString() ?? '';
          endereco = pessoaData['endereco']?.toString() ?? '';
          enderecocep = pessoaData['enderecocep']?.toString() ?? '';
          enderecobairro = pessoaData['enderecobairro']?.toString() ?? '';
          enderecocidade = pessoaData['enderecocidade']?.toString() ?? '';
          endereconumero = pessoaData['endereconumero']?.toString() ?? '';
          enderecocomplemento =
              pessoaData['enderecocomplemento']?.toString() ?? '';
          uf = pessoaData['uf']?.toString() ?? '';
          email = pessoaData['emailcontato']?.toString() ?? '';

          print(response.body);
          
        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return {
      'pessoa_id': pessoaid,
      'nome': nome,
      'codigo': codigo,
      'cpf': cpf,
      'telefone': telefone,
      'endereco': endereco,
      'enderecocep': enderecocep,
      'enderecobairro': enderecobairro,
      'enderecocidade': enderecocidade,
      'endereconumero': endereconumero,
      'enderecocomplemento': enderecocomplemento,
      'uf': uf,
      'emailcontato': email
    };
  }
}
