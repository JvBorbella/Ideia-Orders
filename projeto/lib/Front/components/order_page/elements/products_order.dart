import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class ProductsOrder extends StatefulWidget {
  const ProductsOrder({super.key});

  @override
  State<ProductsOrder> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductsOrder> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
            left: Style.height_15(context), right: Style.height_15(context)),
        decoration: BoxDecoration(
          color: Style.defaultColor,
          border: BorderDirectional(
            bottom: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
            top: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.network(
                              'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/06/Barcode.png')
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Descrição',
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: Style.height_12(context),
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Código',
                                style: TextStyle(
                                  fontSize: Style.height_10(context),
                                  color: Style.quarantineColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '0,00 x 1',
                                style: TextStyle(
                                    fontSize: Style.height_12(context),
                                    color: Style.primaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Subtotal - 0,00',
                                style: TextStyle(
                                    fontSize: Style.height_10(context),
                                    color: Style.warningColor),
                              )
                            ],
                          )
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.remove_circle,
                      //         color: Style.errorColor,
                      //         size: Style.height_35(context),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
