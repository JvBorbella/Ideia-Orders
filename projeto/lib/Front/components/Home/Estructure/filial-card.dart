import 'package:flutter/material.dart';

class FilialCard extends StatefulWidget {
  //Variável para inserir objetos dentro do card
  final List<Widget> children;

  const FilialCard({Key? key, required this.children,}) : super(key: key);

  @override
  State<FilialCard> createState() => _FilialCardState();
}

class _FilialCardState extends State<FilialCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      // Código do card
      child: Container(
        //Margem externa e altura do card que está sendo definida na página home.dart
        margin: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 15.0),
        decoration: BoxDecoration(
            //Estilização do card
            color: Color(0xffffffff),
            border: Border.all(width: 1, color: Color(0xffD9D9D9)),
            borderRadius: BorderRadius.circular(10)),
        //Parte do código para que sejam atribuidos os widgets definidos no código da tela que ficarão dentro do card
        child: Column(
          
          children: widget.children,
        ),
        padding: EdgeInsets.only(bottom: 10, top: 5),
      ),
    );
  }
}
