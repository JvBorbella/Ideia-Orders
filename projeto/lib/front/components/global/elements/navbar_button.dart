import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class NavbarButton extends StatefulWidget {
  final destination;
  final Icons;
  final back;

  const NavbarButton(
      {super.key,
      this.destination,
      required this.Icons,
      this.back = false});

  @override
  State<NavbarButton> createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: Style.ModalButtonWidth(context),
        //Área externa do button
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Style.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              //Função que está sendo definida na página em que este código está sendo chamado
              onTap: () {
                widget.back == false
                    ? Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => widget.destination),
                      )
                    : Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Icon(
                widget.Icons,
                color: Style.tertiaryColor,
                size: Style.SizeDrawerButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
