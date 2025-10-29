import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/front/components/Style.dart';

class OrderContainer extends StatefulWidget {
  final String nomepessoa;
  final double valortotal;
  final DateTime data;
  final String numero;
  final flagpermitefaturar;
  final valordesconto;

  const OrderContainer({
    super.key, 
  required this.valortotal,
  required this.data,
  required this.nomepessoa,
  required this.numero,
  this.flagpermitefaturar,
  this.valordesconto
  });

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}
class _OrderContainerState extends State<OrderContainer> {
  double get valorfinal => widget.valortotal - (widget.valordesconto ?? 0.0);
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Número',
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
                children: [
                  SizedBox(
                    width: Style.width_215(context),
                    child: Column(
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
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Column(
            children: [
              if (widget.flagpermitefaturar == '1')
              Icon(
                Icons.check_circle_outline,
                color: Style.sucefullColor,
                size: Style.height_15(context),
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Valor',
                        style: TextStyle(
                            color: Style.quarantineColor,
                            fontSize: Style.height_8(context),
                            ),
                      ),
                      Text(
                        currencyFormat.format(valorfinal),
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
                        'Data',
                        style: TextStyle(
                            color: Style.quarantineColor,
                            fontSize: Style.height_8(context),
                            ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(widget.data),
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
