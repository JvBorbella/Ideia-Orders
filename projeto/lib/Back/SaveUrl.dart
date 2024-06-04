import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Código da função para salvar a URL digitada na tela Config().

class SaveUrlService {
  Future<void> saveUrl(BuildContext context, String url) async {
    //Salvando o texto digitado no input por meio da biblioteca SharedPreferences.
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('saveUrl', url); //Referenciando o texto armazenado através de 'saveUrl'.
    //Ao efetuar o processo acima, será exibida a mensagem:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'IP salvo com sucesso!',
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        backgroundColor: Style.sucefullColor,
      ),
    );
    //E o usuário será redirecionado para a tela de Login().
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(url: url), //No redirecionamento será passada a url armazenada.
      ),
    );
  }
}

