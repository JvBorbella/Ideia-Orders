import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

int value = 0;

void add() {
  value++;
}

void remove() {
  value--;
}

class _ProductAddState extends State<ProductAdd> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(Style.height_8(context)),
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
                                'Vl. Unit',
                                style: TextStyle(
                                    fontSize: Style.height_12(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '0,00',
                                style: TextStyle(
                                    fontSize: Style.height_12(context),
                                    color: Style.warningColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      value;
                                    });
                                    remove();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Style.primaryColor,
                                    size: Style.height_25(context),
                                  ),
                                ),
                                SizedBox(
                                  width: Style.height_2(context),
                                ),
                                Text('$value'),
                                SizedBox(
                                  width: Style.height_2(context),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      value;
                                    });
                                    add();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Style.primaryColor,
                                    size: Style.height_25(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: Style.height_2(context),
                          ),
                          Container(
                            height: Style.height_30(context),
                            decoration: BoxDecoration(
                                color: Style.primaryColor,
                                borderRadius: BorderRadius.circular(
                                    Style.height_5(context))),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'Adicionar',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: Style.height_12(context)),
                              ),
                            ),
                          )
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
    );
  }
}
