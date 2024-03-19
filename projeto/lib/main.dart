import 'package:flutter/material.dart';
import 'package:projeto/Front/pages/splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gestor Remoto",
      theme: ThemeData(
        textTheme: TextTheme(
          // bodyText1: TextStyle(
          //   fontFamily: 'Sifonn-Pro'
          // ),bodyText2: TextStyle(
          //   fontFamily: 'Sifonn-Pro'
          // )
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //Tela em que inicia após compilar.
      home: const Splash(),
    );
  }
}

void main() => runApp(const MyApp());
