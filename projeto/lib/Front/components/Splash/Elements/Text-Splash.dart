import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class AnimatedTextMove extends StatefulWidget {
  final String text;

   const AnimatedTextMove({Key? key, required this.text,}) : super(key: key);

  @override
  _AnimatedTextMoveState createState() => _AnimatedTextMoveState();
}

//Código do texto "Gestor remoto" da tela splash

class _AnimatedTextMoveState extends State<AnimatedTextMove> {
  double _position = -100.0; //Posição inicial do texto (Fora da tela)
  double _opacity = 0.0; // Opacidade inicial do texto
  double _targetPosition = 0.0; // Posição final (centro da tela)
  double _targetOpacity = 1.0; //Opacidade final do texto.
  
  @override
  Widget build(BuildContext context) {
    //Propriedade para que seja executada a animação da movimentação do texto.
    return TweenAnimationBuilder(
      //Definindo onde começará e onde terminará a animação.
      tween: Tween<double>(begin: _position, end: _targetPosition),
      //Duração da animação.
      duration: Duration(seconds: 1),
      builder: (context, double positionValue, child) {
        return Opacity(
          opacity: _opacity, //Aplicação da opacidade de acordo com a animação de movimentação do texto.
          child: Transform.translate(
            //Quando for a posição inicial do texto, a opacidade será 0.
            offset: Offset(positionValue, 0.0),
            child: child,
          ),
        );
      },
      onEnd: () {
        //Propriedade usada para terminar a animação
      },
      //Propriedade para aplicar a animação da opacidade.
      child: TweenAnimationBuilder(
        //Definindo como será a opacidade no início e no final da animação.
        tween: Tween<double>(begin: 0.0, end: _targetOpacity),
        //duração da animação.
        duration: Duration(seconds: 1),
        builder: (context, double opacityValue, child) {
          return Opacity(
            opacity: opacityValue,
            child: child,
          );
        },
        onEnd: () {
          //Propriedade usada para terminar a animação
        },
        //Texto que será animado e sua estilização.
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w300,
            color: Style.tertiaryColor,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //Inicia a animação quando o widget é construído.
    _startAnimation();
  }
  //Aplica as animações.
  void _startAnimation() {
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _position = _targetPosition;
        _opacity = _targetOpacity;
      });
    });
  }
}

