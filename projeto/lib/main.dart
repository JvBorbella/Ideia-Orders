import 'package:flutter/material.dart';
import 'package:projeto/front/pages/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IdeiaVendas",
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
           bodySmall: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.012
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.018
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.width * 0.025,
            ),
            labelSmall: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.012
            ),
            labelMedium: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.018,
            ),
            labelLarge: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //Tela em que inicia após compilar.
      home: const SplashPage(),
    );
  }
}

void main() => runApp(const MyApp());
