import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class NavbarButton extends StatefulWidget {
  final Widget? destination;
  final IconData? icons;
  final bool? back;
  final int? returnPageQnt;
  final VoidCallback? onPressed;

  const NavbarButton(
      {super.key,
      this.destination,
      required this.icons,
      this.back = false,
      this.returnPageQnt,
      this.onPressed});

  @override
  State<NavbarButton> createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 40,
        //Área externa do button
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              //Função que está sendo definida na página em que este código está sendo chamado
              onTap: () {
                if (widget.onPressed != null) {
                  widget.onPressed!();
                  return;
                }
                widget.back == false
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                widget.destination ?? const SizedBox()),
                      )
                    : Navigator.popUntil(context, (route) {
                        return count++ == widget.returnPageQnt;
                      });
              },
              child: Icon(
                widget.icons,
                color: ColorsApp.tertiaryColor,
                size: Responsive.h(context, 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
