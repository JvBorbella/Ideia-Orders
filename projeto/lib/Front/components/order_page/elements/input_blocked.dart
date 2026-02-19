import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto/front/components/Style.dart';

class InputBlocked extends StatefulWidget {
  final String value;
  final List<TextInputFormatter>? inputFormatters;

  const InputBlocked({Key?key,
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
        //height: Style.height_50(context),
        child: TextField(
          controller: TextEditingController(text: widget.value),
          readOnly: true,
          inputFormatters: widget.inputFormatters,
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
