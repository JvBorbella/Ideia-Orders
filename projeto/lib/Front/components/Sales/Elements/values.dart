import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/Front/components/Sales/Elements/Text-Values.dart';
import 'package:projeto/Front/components/Style.dart';

class Values extends StatefulWidget {
  final double valorHoje;
  final double valorOntem;
  final double valorSemana;
  final double valorMes;

  const Values({
    Key? key,
    required this.valorHoje,
    required this.valorOntem,
    required this.valorSemana,
    required this.valorMes,
  });

  @override
  State<Values> createState() => _ValuesState();
}

class _ValuesState extends State<Values> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return Material(
      //Código dos valores que estarão na tela de vendas
      child: Container(
        child: Column(
          children: [
            //Primeira linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Hoje',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    TextValues(text: currencyFormat.format(widget.valorHoje))
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Ontem',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    TextValues(text: currencyFormat.format(widget.valorOntem))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            //Segunda linha
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Semana',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    if (widget.valorSemana == 0)
                      CircularProgressIndicator()
                    else
                      TextValues(
                          text: currencyFormat.format(widget.valorSemana))
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Mês',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    if (widget.valorMes == 0)
                      CircularProgressIndicator()
                    else
                      TextValues(text: currencyFormat.format(widget.valorMes))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //Linha divisória
            Divider(
              color: Style.quarantineColor, // Cor da linha
              height: 20, // Altura da linha
              thickness: 2,
            ),
            SizedBox(
              height: 0,
            ),
            //Valores de metas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Meta de hoje',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    TextValues(text: '(Valor)')
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Meta acum.',
                      style:
                          TextStyle(fontSize: 9, color: Style.quarantineColor),
                    ),
                    TextValues(text: '(Valor)')
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
