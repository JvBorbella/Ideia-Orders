import 'package:flutter/material.dart';
import 'package:projeto/front/components/Splash/elements/text_splash_page.dart';
import 'package:projeto/front/pages/login.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  //Função para iniciar o timer quando o widget for carregado
  void initState() {
    super.initState();
    //Função para adicionar um timer à tela splash
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        //Função executada após o tempo acabar
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //Estilização da tela splash
        decoration: const BoxDecoration(),
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
                    Image.asset(
                      "assets/images/image_card/image_card.png",
                      color: Theme.of(context).colorScheme.primary,
                      height: 80,
                    ),
                  ],
                ),
                const Row(
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
