import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({super.key});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
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
                    '000000',
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
                    'Nome do cliente',
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
                        'RS 000,00',
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
                        'XX/XX/XXXX',
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
