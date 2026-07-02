import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class RegisterIconButton extends StatefulWidget {
  final String text;
  final Color color;
  final double width;
  final IconData icon;
  final Function onPressed;
  final bool? isLoadingButton;

  const RegisterIconButton(
      {super.key,
      required this.text,
      required this.color,
      required this.width,
      required this.icon,
      required this.onPressed,
      this.isLoadingButton});

  @override
  State<RegisterIconButton> createState() => _RegisterIconButtonState();
}

class _RegisterIconButtonState extends State<RegisterIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: widget.width,
        child: TextButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
                EdgeInsets.all(Responsive.h(context, 5))),
            backgroundColor: WidgetStatePropertyAll(widget.color),
            // maximumSize: WidgetStatePropertyAll(
            //     Size(Responsive.h(context, 200), Style.height_100(context))),
            // minimumSize: WidgetStatePropertyAll(
            //     Size(Responsive.h(context, 150), Style.height_45(context)))
          ),
          onPressed: widget.isLoadingButton == true
              ? null
              : () {
                  widget.onPressed();
                },
          child: widget.isLoadingButton == true
              ? SizedBox(
                  width: Responsive.h(context, 15),
                  height: Responsive.h(context, 15),
                  child: const CircularProgressIndicator(
                    color: ColorsApp.tertiaryColor,
                    strokeWidth: 2.0,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: Responsive.h(context, 8),
                          color: ColorsApp.tertiaryColor),
                    ),
                    SizedBox(
                      width: Responsive.h(context, 2),
                    ),
                    Icon(
                      widget.icon,
                      size: Responsive.h(context, 15),
                      color: ColorsApp.tertiaryColor,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
