import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class InputBlocked extends StatefulWidget {
  final String value;

  const InputBlocked({Key? key, required this.value});

  @override
  State<InputBlocked> createState() => _InputBlockedState();
}

class _InputBlockedState extends State<InputBlocked> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: Style.height_40(context),
        child: TextFormField(
          initialValue: widget.value,
          readOnly: true,
          style: TextStyle(
            fontSize: Style.height_10(context)
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black12,
              border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(Style.height_15(context)))),
        ),
      ),
    );
  }
}
