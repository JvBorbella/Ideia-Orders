import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class RegisterButton extends StatefulWidget {
  final String text;
  final Color color;
  final double? width;
  final VoidCallback? onPressed;
  final bool? isLoadingButton;

  const RegisterButton(
      {super.key,
      required this.text,
      required this.color,
      this.width,
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
      width: widget.width ?? double.infinity,
      child: TextButton(
        style: ButtonStyle(
          padding:
              WidgetStatePropertyAll(EdgeInsets.all(Responsive.h(context, 5))),
          backgroundColor: WidgetStatePropertyAll(widget.color),
        ),
        onPressed: widget.isLoadingButton == true ? null : widget.onPressed,
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
                    overflow: TextOverflow.ellipsis,
                    widget.text,
                    style: TextStyle(
                        fontSize: Responsive.h(context, 8),
                        color: ColorsApp.tertiaryColor),
                  ),
                ],
              ),
      ),
    ));
  }
}
