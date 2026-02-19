import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Código com a função para armazenar o usuário informado no input da tela Login().

class SaveUserService {
  Future<void> saveUser(BuildContext context, String username, String password) async {
    // if (username.isNotEmpty) { //Caso username esteja vazio, a função preencherá com o texto digitado no input.
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString('saveUser', username);
        await sharedPreferences.setString('savePass', password);
      } catch (e) {
        //Caso não tenha sido possível salvá-lo, será exibida o erro no console.
        print('Erro ao salvar usuário: $e');
      }
    // }
  }

  //Em listenAndSaveUser o texto salvo será carregado no controller do input, através da função saveUser.
  void listenAndSaveUser(
      BuildContext context, TextEditingController controller, TextEditingController passwordController) {
    controller.addListener(() {
      saveUser(context, controller.text, passwordController.text);
    });
  }
}
