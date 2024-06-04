import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class TextValues extends StatefulWidget {
  final String text;

  const TextValues({Key? key, required this.text}) : super(key: key);

  @override
  State<TextValues> createState() => _TextValuesState();
}

class _TextValuesState extends State<TextValues> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: 18,
          color: Style.primaryColor,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}