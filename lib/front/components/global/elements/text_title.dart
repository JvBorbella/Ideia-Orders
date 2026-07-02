import 'package:flutter/material.dart';
import 'package:styles/widths.dart';

class TextTitle extends StatefulWidget {
  final String text;

  const TextTitle({super.key, required this.text});

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
            fontSize: Responsive.h(context, 15), fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
