import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class ValuesDays extends StatefulWidget {
  final String text;

  const ValuesDays({Key? key, required this.text}) : super(key: key);

  @override
  State<ValuesDays> createState() => _ValuesDaysState();
}

class _ValuesDaysState extends State<ValuesDays> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //Código do texto que armazenará os valores nos cards de cada filial da home
      child: Text(
        widget.text,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 600
                ? MediaQuery.of(context).size.width * 0.032
                : MediaQuery.of(context).size.width * 0.012,
            color: Style.primaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
