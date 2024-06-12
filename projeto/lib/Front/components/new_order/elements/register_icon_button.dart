import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class RegisterIconButton extends StatefulWidget {
  final String text;
  final Color color;
  final double width;
  final IconData icon;
  final Function onPressed;

  const RegisterIconButton({
    Key? key, 
    required this.text,
    required this.color,
    required this.width,
    required this.icon,
    required this.onPressed,
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
          onPressed: () {
            widget.onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    fontSize: Style.height_8(context),
                    color: Style.tertiaryColor),
              ),
              SizedBox(
                width: Style.height_2(context),
              ),
              Icon(
                widget.icon,
                size: Style.height_15(context),
                color: Style.tertiaryColor,
                )
            ],
          ),
        ),
      ),
    );
  }
}
