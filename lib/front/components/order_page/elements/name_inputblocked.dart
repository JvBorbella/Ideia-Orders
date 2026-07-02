import 'package:flutter/material.dart';
import 'package:styles/widths.dart';

class NameInputblocked extends StatefulWidget {
  final String text;

  const NameInputblocked({super.key, required this.text});

  @override
  State<NameInputblocked> createState() => _NameInputblockedState();
}

class _NameInputblockedState extends State<NameInputblocked> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
            left: Responsive.h(context, 12), right: Responsive.h(context, 12)),
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: Responsive.h(context, 10),
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
