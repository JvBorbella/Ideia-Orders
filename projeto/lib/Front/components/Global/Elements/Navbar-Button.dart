import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class ButtonNavbar extends StatefulWidget {
  final Widget destination;
  final Icons;

  const ButtonNavbar({Key? key, required this.destination, required this.Icons}) : super (key: key);

  @override
  State<ButtonNavbar> createState() => _ButtonNavbarState();
}

class _ButtonNavbarState extends State<ButtonNavbar> {
  @override
  Widget build(BuildContext context) {
    return Material(
       child: Container(
        width: 70,
        //Área externa do button  
        decoration: BoxDecoration(
          color: Style.primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              //Função que está sendo definida na página em que este código está sendo chamado
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget.destination),
                );
              },
              child: ButtonTheme(
                //Estilização do Buttom
                child: Icon(
                  widget.Icons,
                  color: Style.tertiaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}