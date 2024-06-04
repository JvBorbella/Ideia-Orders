import 'package:flutter/material.dart';

class TextRequisition extends StatelessWidget {
  final int solicitacoesremotas;

  const TextRequisition({Key? key, required this.solicitacoesremotas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Row(
          children: [
            if (solicitacoesremotas == 0)
              Text(
                'Não há nenhuma requisição no momento',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xffA6A6A6),
                ),
              ),
            if (solicitacoesremotas > 0)
              Text(
                'Nova solicitação!',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xff00568E),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
