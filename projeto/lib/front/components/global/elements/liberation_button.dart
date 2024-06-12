import 'package:flutter/material.dart';

class LiberationButtom extends StatefulWidget {
  //Variável para definir o texto do button na página em que está sendo chamado
  final String text;
  //Variável para definir o destino ao clicar no button, na página em que está sendo chamado
  // final String liberacaoremotaId;
  // final String url;
  // final String token;
  // final String message;
  final onPressed;

  const LiberationButtom(
      {Key? key,
      required this.text,
      // required this.liberacaoremotaId,
      // required this.url,
      // required this.token,
      // required this.message,
      this.onPressed})
      : super(key: key);

  @override
  State<LiberationButtom> createState() => _LiberationButtomState();
}

class _LiberationButtomState extends State<LiberationButtom> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //Estilização do button
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xff42B9F0)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          //Alinhamento interno
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              //Função aplicada ao ser clicado
              onPressed: () {
                if (widget.onPressed != null) {
                  widget.onPressed();
                }
              },
              //Texto retornado, que foi definido na página em que o button está sendo chamado
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Color(0xff42b9f0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        //Tamanho do button
        width: 160,
        padding: EdgeInsets.all(0),
      ),
    );
  }
}
