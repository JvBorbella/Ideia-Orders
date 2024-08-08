import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';

class ProductAdd extends StatefulWidget {
  final produtoid;
  final nomeproduto;
  final codigoproduto;
  final codigoean;
  final unidade;
  final precopromocional;
  final precotabela;

  const ProductAdd({
    Key? key,
    this.produtoid,
    this.nomeproduto,
    this.codigoproduto,
    this.codigoean,
    this.unidade,
    this.precopromocional,
    this.precotabela,
  });

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

// int value = 0;

// void add() {
//   value++;
// }

// void remove() {
//   value--;
// }

class _ProductAddState extends State<ProductAdd> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: SingleChildScrollView(
                child: AlertDialog(
                    alignment: Alignment.center,
                    content: Container(
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     IconButton(
                      //       onPressed: _closeModal,
                      //       icon: Icon(Icons.close),
                      //       color: Style.errorColor,
                      //       iconSize: Style.height_15(context),
                      //       )
                      //   ],
                      // ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          widget.nomeproduto.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Style.height_15(context),
                            color: Style.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Style.height_5(context),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(widget.codigoproduto),
                      ),
                      SizedBox(
                        height: Style.height_20(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Ean',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.codigoean,
                                style: TextStyle(
                                    fontSize: Style.height_20(context),
                                    color: Style.primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Qtde em Estoque',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '50',
                                style: TextStyle(
                                    fontSize: Style.height_20(context),
                                    color: Style.primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Preço Tabela',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                currencyFormat
                                    .format(widget.precotabela)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: Style.height_20(context),
                                    color: Style.primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Preço Promocional',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                currencyFormat
                                    .format(widget.precopromocional)
                                    .toString(),
                                style: TextStyle(
                                    fontSize: Style.height_20(context),
                                    color: Style.primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Unidade',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.unidade,
                                style: TextStyle(
                                    fontSize: Style.height_20(context),
                                    color: Style.primaryColor),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Qtde a adicionar',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: Style.width_130(context),
                                child: Input(
                                  text: 'Informe a quantidade',
                                  type: TextInputType.number,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Complemento',
                                style: TextStyle(
                                    fontSize: Style.height_15(context),
                                    color: Style.warningColor),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: Style.width_180(context),
                                child: TextFormField(
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical
                                      .top, // Alinha o cursor ao topo
                                  maxLines:
                                      null, // Permite quebra de linha automática
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 20.0,
                                        left: 10.0,
                                        right:
                                            10.0), // Ajuste conforme necessário
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Style.secondaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Style.secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: Style.height_20(context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              RegisterButton(
                                text: 'Adicionar produto',
                                color: Style.primaryColor,
                                width: Style.width_100(context),
                                onPressed: () {
                                  //  Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) => NewOrderPage()));
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              RegisterButton(
                                text: 'Fechar',
                                color: Style.errorColor,
                                width: Style.width_100(context),
                                onPressed: () {
                                  _closeModal();
                                },
                              )
                            ],
                          )
                        ],
                      )
                    ])))));
      },
    );
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
  }

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
                              Container(
                                width: Style.width_130(context),
                                child: Text(
                                  widget.nomeproduto,
                                  style: TextStyle(
                                      color: Style.primaryColor,
                                      fontSize: Style.height_10(context),
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                widget.codigoproduto,
                                style: TextStyle(
                                  fontSize: Style.height_10(context),
                                  color: Style.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Estoque',
                          //       style: TextStyle(
                          //         fontSize: Style.height_10(context),
                          //         color: Style.quarantineColor,
                          //       ),
                          //     ),
                          //   ],
                          // )
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
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Text(
                      //           'Vl. Unit',
                      //           style: TextStyle(
                      //               fontSize: Style.height_12(context),
                      //               color: Style.warningColor),
                      //         ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         Text(
                      //           currencyFormat.format(widget.precotabela).toString(),
                      //           style: TextStyle(
                      //               fontSize: Style.height_12(context),
                      //               color: Style.warningColor),
                      //         )
                      //       ],
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        width: Style.height_10(context),
                      ),
                      Column(
                        children: [
                          // Container(
                          //   width: Style.width_50(context),
                          //   child: Input(
                          //     text: 'Qtde',
                          //     type: TextInputType.number,
                          //     textAlign: TextAlign.center,
                          //     ),
                          // ),
                          // SizedBox(
                          //   height: Style.height_5(context),
                          // ),
                          Container(
                            height: Style.height_30(context),
                            decoration: BoxDecoration(
                                color: Style.primaryColor,
                                borderRadius: BorderRadius.circular(
                                    Style.height_5(context))),
                            child: TextButton(
                              onPressed: () {
                                _openModal(context);
                              },
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
