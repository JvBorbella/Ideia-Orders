import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class RegisterButton extends StatefulWidget {
  final String text;
  final Color color;
  final double width;
  final onPressed;
  final isLoadingButton;

  const RegisterButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.width,
      this.onPressed,
      this.isLoadingButton});

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SizedBox(
      width: widget.width,
      child: TextButton(
        style: ButtonStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.all(Style.height_5(context))),
          backgroundColor: WidgetStatePropertyAll(widget.color),
          // maximumSize: WidgetStatePropertyAll(
          //     Size(Style.height_200(context), Style.height_100(context))),
          // minimumSize: WidgetStatePropertyAll(
          //     Size(Style.height_150(context), Style.height_45(context)))
        ),
        onPressed: widget.isLoadingButton == true ? null : widget.onPressed,
        child: widget.isLoadingButton == true
            ? SizedBox(
                width: Style.height_15(context),
                height: Style.height_15(context),
                child: CircularProgressIndicator(
                  color: Style.tertiaryColor,
                  strokeWidth: 2.0,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    style: TextStyle(
                        fontSize: Style.height_8(context),
                        color: Style.tertiaryColor),
                  ),
                ],
              ),
      ),
    ));
  }
}
