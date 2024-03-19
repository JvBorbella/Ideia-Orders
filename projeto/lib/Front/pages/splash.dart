import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Splash/Elements/Text-Splash.dart';
import 'package:projeto/Front/components/Style.dart';
import 'dart:async';

import 'package:projeto/Front/pages/login.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  //Função para iniciar o timer quando o widget for carregado
  void initState() {
    super.initState();

    //Função para adicionar um timer à tela splash
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        //Função executada após o tempo acabar
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Estilização da tela splash
        decoration: BoxDecoration(
          //Gradiente color usado na tela splash
          gradient: Style.gradient
        ),
        //Conteúdo da tela
        child: Row(
          //Alinhamentos
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Image.network(
                      'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/02/IDEIA-LOGO-AZUL-e1707321339855.png',
                      color: Style.tertiaryColor,
                      height: MediaQuery.of(context).size.width * 0.25,
                    ),
                  ],
                ),
                Row(
                  //Chamando a animação do texto abaixo da imagem
                  children: [
                    AnimatedTextMove(
                      text: 'Gestor Remoto',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
