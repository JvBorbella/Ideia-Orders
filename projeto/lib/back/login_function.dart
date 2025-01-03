import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Código da função de login

class LoginFunction {
  static Future<void> login(
    //BuildContext para permitir que sejam criadas mensagens de alerta conforme as tentativas e erros nesta classe.
    BuildContext context,
    //Recebendo os dados armazenados que serão necessário para efetuar a função.
    String url,
    TextEditingController userController,
    TextEditingController passwordController,
  ) async {

    //Tentando fazer a requisição ao servidor.
    try {
      //Definindo variáveis que serão utilizadas na requisição

      var username = userController.text;
      //username: recebe o valor digitado no input de usuário na tela de login.
      var password = passwordController.text;
      // //password: recebe o valor digitado no input de senha na tela de login.
      // var md5Password = md5.convert(utf8.encode(password)).toString();
      //md5Password: criptografa a senha digitada em md5 Hash pois o servidor só aceita requisição com a senha já criptografada.
      var authorization = Uri.parse('$url/ideia/secure/login');
      //authorization: define a url que fará a requisição post ao servidor.

      //response: variável definida para receber a resposta da requisição post do servidor.
      var response = await http.post(
        authorization, //passando a url da requisição
        headers: {
          //passando os parâmetros na header da requisição.
          'auth-user': username,
          'auth-pass': password,
        },
      );
      print(password);
      print(response.body);

      //Caso o servidor aceite a conexão, o token será resgatado no json e armazenado no sharedpreferences.
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          var usuario_id = responseBody['data']['id'];
          var token = responseBody['data']['token'];
          var login = responseBody['data']['login'];
          var image = responseBody['data']['image'];
          var email = responseBody['data']['email'];
          var empresaid = responseBody['data']['empresa_id'] ?? '';
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          await sharedPreferences.setString('usuario_id', usuario_id);
          await sharedPreferences.setString('token', token);
          await sharedPreferences.setString('login', login);
          await sharedPreferences.setString('image', image);
          await sharedPreferences.setString('url', '$url/ideia/secure');
          await sharedPreferences.setString('urlBasic', url);
          await sharedPreferences.setString('email', email);
          await sharedPreferences.setString('empresa_id', empresaid);
          print(token);
        
        // Feito o processo acima, a função redireciona para a página Home(), passando para ela os dados que serão utilizados.
       Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const Home(),
            ),
          );
        } else {
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
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Sem conexão com o servidor!',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      } else if (response.statusCode == 408) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Não foi possível conectar-se dentro do tempo limite!',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      } else if (response.statusCode == 419) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Não foi possível conectar-se dentro do tempo limite!',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Ocorreu um erro inesperado com o servidor!',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Não foi possível iniciar a sessão! - ${response.statusCode}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      }
      //Caso a tentativa de requisição não retorne o status 200, será exibida essa mensagem
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            'Não foi possível iniciar a sessão - $e',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
              color: Style.tertiaryColor,
            ),
          ),
          backgroundColor: Style.errorColor,
        ),
      );
      //Exibindo no console o tipo de erro retornado.
      print('Erro durante a solicitação HTTP: $e');
    }
  }
}
