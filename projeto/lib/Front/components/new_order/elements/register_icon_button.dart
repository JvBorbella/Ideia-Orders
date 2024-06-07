import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class RegisterIconButton extends StatefulWidget {
  final String text;
  final Color color;
  final double width;
  final IconData icon;

  const RegisterIconButton({
    Key? key, 
    required this.text,
    required this.color,
    required this.width,
    required this.icon
    });

  @override
  State<RegisterIconButton> createState() => _RegisterIconButtonState();
}

class _RegisterIconButtonState extends State<RegisterIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.width,
        child: TextButton(
          style: ButtonStyle(
              padding: WidgetStatePropertyAll(
                  EdgeInsets.all(Style.height_5(context))),
              backgroundColor: WidgetStatePropertyAll(widget.color),
              // maximumSize: WidgetStatePropertyAll(
              //     Size(Style.height_200(context), Style.height_100(context))),
              // minimumSize: WidgetStatePropertyAll(
              //     Size(Style.height_150(context), Style.height_45(context)))
                  ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    fontSize: Style.height_12(context),
                    color: Style.tertiaryColor),
              ),
              Icon(
                widget.icon,
                size: Style.height_25(context),
                color: Style.tertiaryColor,
                )
            ],
          ),
        ),
      ),
    );
  }
}
