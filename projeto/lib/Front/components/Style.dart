import 'package:flutter/material.dart';

class Style {
  static const Color primaryColor = Color(0xff00568e);
  static const Color secondaryColor = Color(0xff42b9f0);
  static const Color tertiaryColor = Color(0xffffffff);
  static const Color quarantineColor = Color(0xffA6A6A6);
  static const Color sucefullColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Color(0xffFFD700);
  static const double inputSpace = 25.0; 
  static const double InputToButtonSpace = 50.0; 
  static const double ButtonSpace = 15.0; 
  static const double ContentInternalSpace = 10.0; 
  static const double ContentInternalButtonSpace = 30.0; 
  static const double ImageToInputSpace = 50.0;  
  static const LinearGradient gradient = LinearGradient(
    colors: [
      Color(0xff0B4164),
      Color(0xff0476A8),
      Color(0xff009BC0),
      Color(0xff2EB9D3),
    ],
    //Direcionamento do gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData getAppTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      primaryColorLight: tertiaryColor,
      primaryColorDark: quarantineColor,
      // Outras configurações de tema, se necessário
    );
  }
}
