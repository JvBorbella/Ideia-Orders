import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/front/components/Style.dart';

class OrderContainer extends StatefulWidget {
  final String nomepessoa;
  final String valortotal;
  final String data;
  final String numero;

  const OrderContainer({
    Key? key, 
  required this.valortotal,
  required this.data,
  required this.nomepessoa,
  required this.numero,
  });

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
   NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Style.height_8(context)),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
                  width: Style.height_05(context),
                  color: Style.quarantineColor),
              top: BorderSide(
                  width: Style.height_05(context),
                  color: Style.quarantineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nº do pedido',
                    style: TextStyle(
                        color: Style.quarantineColor,
                        fontSize: Style.height_8(context),
                        ),
                  ),
                  Text(
                    widget.numero,
                    style: TextStyle(
                        color: Style.primaryColor,
                        fontSize: Style.height_10(context),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: Style.height_12(context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cliente',
                    style: TextStyle(
                        color: Style.quarantineColor,
                        fontSize: Style.height_8(context),
                        ),
                  ),
                  Text(
                    widget.nomepessoa,
                    style: TextStyle(
                      color: Style.primaryColor,
                      fontSize: Style.height_10(context),
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Vl. do pedido',
                        style: TextStyle(
                            color: Style.quarantineColor,
                            fontSize: Style.height_8(context),
                            ),
                      ),
                      Text(
                        widget.valortotal.toString(),
                        style: TextStyle(
                          color: Style.primaryColor,
                          fontSize: Style.height_10(context),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Dt. do pedido',
                        style: TextStyle(
                            color: Style.quarantineColor,
                            fontSize: Style.height_8(context),
                            ),
                      ),
                      Text(
                        widget.data.toString(),
                        style: TextStyle(
                            color: Style.primaryColor,
                            fontSize: Style.height_8(context),
                            fontWeight: FontWeight.bold
                            ),
                      )
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
