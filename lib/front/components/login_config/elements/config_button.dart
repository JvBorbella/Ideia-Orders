import 'package:flutter/material.dart';
import 'package:projeto/main.dart';
import 'package:styles/widths.dart';

class ButtonConfig extends StatefulWidget {
  //Variável para definir o texto do button na página em que é chamado
  final String text;
  //Variável para definir o destino ao clicar no button na página em que é chamado
  final VoidCallback? onPressed;
  //Variável para definir o tamanho do button na página em que é chamado
  final double height;
  final bool? isLoadingButton;

  const ButtonConfig(
      {super.key,
      required this.text,
      this.onPressed,
      required this.height,
      this.isLoadingButton});

  @override
  State<ButtonConfig> createState() => _ButtonConfigState();
}

class _ButtonConfigState extends State<ButtonConfig> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        //Alinhamento do button
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            //Redirecionamento executado ao clicar no button. Definido na página em que o button está sendo chamado.
            onPressed: () {
              if (widget.onPressed != null) {
                widget.onPressed!();
              }
            },
            child: widget.isLoadingButton == true
                ? SizedBox(
                    width: Responsive.h(context, 15),
                    height: Responsive.h(context, 15),
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onSecondary,
                      strokeWidth: 2.0,
                    ),
                  )
                : Text(
                    //Texto do button está sendo definido na página em que está sendo chamado.
                    widget.text,
                    //Estilização do button
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontFamily: kFontFamilyPoppins,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.height,
                    ),
                  ),
          ),
          //Espaçamento para o bottom.
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
