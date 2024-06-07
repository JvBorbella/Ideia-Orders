import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class TextTitle extends StatefulWidget {
  final String text;

  const TextTitle({Key? key, required this.text});

  @override
  State<TextTitle> createState() => _TextTitleState();
}

class _TextTitleState extends State<TextTitle> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Text(
        widget.text,
        style: TextStyle(
              fontSize: Style.height_15(context),
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
      ),
    );
  }
}