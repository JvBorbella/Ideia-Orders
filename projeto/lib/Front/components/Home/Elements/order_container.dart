import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class OrderContainer extends StatefulWidget {
  const OrderContainer({super.key});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Style.height_12(context)),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
                  width: Style.height_05(context),
                  color: Style.quarantineColor),
              top: BorderSide(
                  width: Style.height_05(context),
                  color: Style.quarantineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '000000',
                style: TextStyle(
                    color: Style.primaryColor,
                    fontSize: Style.height_10(context)),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'Nome do cliente',
                style: TextStyle(
                  color: Style.primaryColor,
                  fontSize: Style.height_10(context),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    'RS 000,00',
                    style: TextStyle(
                      color: Style.primaryColor,
                      fontSize: Style.height_10(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'XX/XX/XXXX',
                    style: TextStyle(
                        color: Style.primaryColor,
                        fontSize: Style.height_8(context)),
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
