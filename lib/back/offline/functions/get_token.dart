import 'package:shared_preferences/shared_preferences.dart';

class GetToken {
  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final savedToken = sharedPreferences.getString('token') ?? '';
    return savedToken;
  }
}
