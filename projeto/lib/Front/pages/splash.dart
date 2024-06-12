import 'package:flutter/material.dart';
import 'package:projeto/front/components/Splash/elements/text_splash_page.dart';
import 'package:projeto/front/pages/login.dart';
import 'package:projeto/front/components/style.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
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
        decoration: BoxDecoration(),
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
                      color: Style.primaryColor,
                      height: Style.LogoSplashSize(context),
                    ),
                  ],
                ),
                Row(
                  //Chamando a animação do texto abaixo da imagem
                  children: [
                    AnimatedTextMove(
                      text: 'Pré-vendas',
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
