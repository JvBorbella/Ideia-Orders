import 'package:flutter/material.dart';

class NumberOfRequisitions extends StatefulWidget {
  //Variável para definir o número de requisições
  final int solicitacoesremotas;

  const NumberOfRequisitions({Key? key, required this.solicitacoesremotas}) : super(key: key);

  @override
  State<NumberOfRequisitions> createState() => _NumberOfRequisitionsState();
}

class _NumberOfRequisitionsState extends State<NumberOfRequisitions> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //Método para verificar o número de requisições e definir uma estilização a partir disso.
        child: Text(
          '${widget.solicitacoesremotas > 0 ? widget.solicitacoesremotas : ""}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xffFFFFFF),
          ),
          textAlign: TextAlign.center,
        ),
        //Caso seja 0, a área externa será branca, fazendo com que o não seja exibido
        //Se for maior que 0, a área externa será amarela, dando destaque ao número de requisições
        decoration: BoxDecoration(
          color: widget.solicitacoesremotas > 0
              ? Color(0xffFFD700)
              : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        width: 20,
        height: 20,
        padding: EdgeInsets.only(bottom: 5),
      ),
    );
  }
}
