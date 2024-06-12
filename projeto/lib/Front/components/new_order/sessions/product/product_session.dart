import 'package:flutter/material.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/pages/product_list.dart';

class ProductSession extends StatefulWidget {
  const ProductSession({super.key});

  @override
  State<ProductSession> createState() => _ProductSessionState();
}

class _ProductSessionState extends State<ProductSession> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextTitle(text: 'Produto(s)'),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            // width: Style.height_100(context),
            child: Column(
              children: [
                SizedBox(
                  height: Style.height_10(context),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: Style.height_15(context),
                      right: Style.height_15(context)),
                  decoration: BoxDecoration(
                    color: Style.defaultColor,
                    border: BorderDirectional(
                      bottom: BorderSide(
                          width: Style.height_05(context),
                          color: Style.quarantineColor),
                      top: BorderSide(
                          width: Style.height_05(context),
                          color: Style.quarantineColor),
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
                                              fontSize:
                                                  Style.height_12(context),
                                              fontWeight: FontWeight.bold),
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
                                              fontSize:
                                                  Style.height_12(context),
                                              color: Style.primaryColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Subtotal - 0,00',
                                          style: TextStyle(
                                              fontSize:
                                                  Style.height_10(context),
                                              color: Style.warningColor),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Style.errorColor,
                                        size: Style.height_20(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Center(
                  child: Text(
                    'Total - RS 0,00',
                    style: TextStyle(
                        color: Style.primaryColor,
                        fontSize: Style.height_15(context),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                RegisterIconButton(
                  text: 'Adicionar Produto', 
                  color: Style.primaryColor, 
                  width: Style.height_150(context), 
                  icon: Icons.add_circle, 
                  onPressed: () {
                    Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProductList()));
                  }
                  ),
              ],
            ),
          ),
        ],
      ) 
    );
  }
}