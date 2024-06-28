import 'package:flutter/material.dart';
import 'package:projeto/front/components/style.dart';

class NameInputblocked extends StatefulWidget {
  final String text;

  const NameInputblocked({
    Key?key,
    required this.text
  });

  @override
  State<NameInputblocked> createState() => _NameInputblockedState();
}

class _NameInputblockedState extends State<NameInputblocked> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
            left: Style.height_12(context), right: Style.height_12(context)),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: Style.height_10(context),
            color: Style.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
