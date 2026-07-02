import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:styles/widths.dart';

class InputBlocked extends StatefulWidget {
  final String value;
  final List<TextInputFormatter>? inputFormatters;

  const InputBlocked({
    super.key,
    required this.value,
    this.inputFormatters,
  });

  @override
  State<InputBlocked> createState() => _InputBlockedState();
}

class _InputBlockedState extends State<InputBlocked> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        //height: Responsive.h(context, 50),
        child: TextField(
          controller: TextEditingController(text: widget.value),
          readOnly: true,
          inputFormatters: widget.inputFormatters,
          style: TextStyle(fontSize: Responsive.h(context, 10)),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Responsive.h(context, 15)))),
        ),
      ),
    );
  }
}
