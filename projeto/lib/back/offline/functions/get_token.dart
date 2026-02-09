import 'package:flutter/widgets.dart';
import 'package:projeto/back/system/login_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetToken {
  static Future<String> getToken(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    final savedUser = sharedPreferences.getString('login_usuario') ?? '';
    final savedPass = sharedPreferences.getString('senha_usuario') ?? '';
    await LoginFunction.login(
      context,
      savedUrlBasic,
      savedUser,
      savedPass,
    );
    final savedToken = sharedPreferences.getString('token') ?? '';
    return savedToken;
  }
}
