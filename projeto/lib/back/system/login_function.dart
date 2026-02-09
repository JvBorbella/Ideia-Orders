import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Código da função de login

class LoginFunction {
  static Future<void> login(
    //BuildContext para permitir que sejam criadas mensagens de alerta conforme as tentativas e erros nesta classe.
    BuildContext context,
    //Recebendo os dados armazenados que serão necessário para efetuar a função.
    String url,
    String userController,
    String passwordController,
  ) async {
    //Tentando fazer a requisição ao servidor.
    try {
      //Definindo variáveis que serão utilizadas na requisição

      var md5Password = md5.convert(utf8.encode(passwordController)).toString();
      //md5Password: criptografa a senha digitada em md5 Hash pois o servidor só aceita requisição com a senha já criptografada.
      var authorization = Uri.parse('$url/ideia/secure/login');
      //authorization: define a url que fará a requisição post ao servidor.

      //response: variável definida para receber a resposta da requisição post do servidor.
      var response = await http.post(
        authorization, //passando a url da requisição
        headers: {
          //passando os parâmetros na header da requisição.
          'auth-user': userController,
          'auth-pass': md5Password,
        },
      );
      print(passwordController);
      print(md5Password);

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
          ErrorHandler.showSnackBar(context, responseBody['message']);
        }
      } else {
        final msg = ErrorHandler.getMessage(null, response.statusCode);
        ErrorHandler.showSnackBar(context, msg);
      }
      //Caso a tentativa de requisição não retorne o status 200, será exibida essa mensagem
    } catch (e) {
      final msg = ErrorHandler.getMessage(e);
      ErrorHandler.showSnackBar(context, msg);
      print("Erro: $e");
    }
  }
}

class ErrorHandler {
  static String getMessage(dynamic error, [int? statusCode]) {
    if (error is Exception) {
      // Aqui você pode tratar exceções de rede
      if (error.toString().contains("SocketException")) {
        return "Sem conexão com o servidor.";
      }
      if (error.toString().contains("TimeoutException")) {
        return "Tempo de conexão excedido.";
      }
      return "Erro inesperado. Tente novamente.";
    }

    // Tratamento por código HTTP
    switch (statusCode) {
      case 400:
        return "Requisição inválida.";
      case 401:
        return "Usuário ou senha incorretos.";
      case 403:
        return "Você não tem permissão para acessar.";
      case 404:
        return "Servidor não encontrado.";
      case 408:
        return "Tempo de conexão excedido.";
      case 419:
        return "Sessão expirada. Faça login novamente.";
      case 500:
        return "Erro interno no servidor.";
      default:
        return "Não foi possível processar sua solicitação.";
    }
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
