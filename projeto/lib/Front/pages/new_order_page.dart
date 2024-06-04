import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Global/Elements/Navbar-Button.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Login_Config/Elements/input.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/home.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({super.key});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Navbar(text: 'Novo pedido', children: [
            ButtonNavbar(destination: Home(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          Text(
            'Produtos',
            style: TextStyle(
              fontSize: Style.height_15(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            width: Style.height_100(context),
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.all(Style.height_5(context))),
                      backgroundColor:
                          WidgetStatePropertyAll(Style.primaryColor),
                      maximumSize: WidgetStatePropertyAll(Size(
                          Style.height_200(context),
                          Style.height_100(context))),
                      minimumSize: WidgetStatePropertyAll(Size(
                          Style.height_150(context),
                          Style.height_45(context)))),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Adicionar produto',
                        style: TextStyle(
                            fontSize: Style.height_12(context),
                            color: Style.tertiaryColor),
                      ),
                      SizedBox(
                        width: Style.height_2(context),
                      ),
                      Icon(
                        Icons.add_circle_outlined,
                        color: Style.tertiaryColor,
                        size: Style.height_20(context),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: Style.height_5(context),
                      right: Style.height_5(context)),
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
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                    fontSize: Style.height_12(context)),
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
                          ),
                        ],
                      ),
                      Column(
                        children: [],
                      ),
                      Column(
                        children: [],
                      ),
                      Column(
                        children: [],
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
                )
              ],
            ),
          ),
          SizedBox(
            height: Style.height_30(context),
          ),
          Text(
            'Clientes',
            style: TextStyle(
              fontSize: Style.height_15(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.all(Style.height_15(context)),
            child: Column(
              children: [
                Input(
                  text: 'Informe o CPF',
                  type: TextInputType.number,
                  IconButton: IconButton(
                      onPressed: () {}, icon: Icon(Icons.person_search)),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(text: 'Informe o tel.', type: TextInputType.number),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(text: 'Nome do cliente', type: TextInputType.text),
              ],
            ),
          ),
          SizedBox(
            height: Style.height_30(context),
          ),
          Text(
            'Endereço',
            style: TextStyle(
              fontSize: Style.height_15(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.all(Style.height_15(context)),
            child: Column(
              children: [
                Input(
                  text: 'CEP',
                  type: TextInputType.number,
                  IconButton: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.screen_search_desktop_sharp)),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.height_250(context),
                          child: Input(
                              text: 'Informe o endereço',
                              type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.height_80(context),
                          child: Input(text: 'UF', type: TextInputType.text),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.height_200(context),
                          child:
                              Input(text: 'Bairro', type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.height_130(context),
                          child:
                              Input(text: 'Cidade', type: TextInputType.text),
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
                        Container(
                          width: Style.height_150(context),
                          child: TextButton(
                            style: ButtonStyle(
                                padding: WidgetStatePropertyAll(
                                    EdgeInsets.all(Style.height_5(context))),
                                backgroundColor:
                                    WidgetStatePropertyAll(Style.primaryColor),
                                maximumSize: WidgetStatePropertyAll(Size(
                                    Style.height_200(context),
                                    Style.height_100(context))),
                                minimumSize: WidgetStatePropertyAll(Size(
                                    Style.height_150(context),
                                    Style.height_45(context)))),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Cadastrar cliente',
                                  style: TextStyle(
                                      fontSize: Style.height_12(context),
                                      color: Style.tertiaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.height_150(context),
                          child: Column(
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(
                                            Style.height_5(context))),
                                    backgroundColor: WidgetStatePropertyAll(
                                        Style.sucefullColor),
                                    maximumSize: WidgetStatePropertyAll(Size(
                                        Style.height_200(context),
                                        Style.height_100(context))),
                                    minimumSize: WidgetStatePropertyAll(Size(
                                        Style.height_150(context),
                                        Style.height_45(context)))),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Finalizar pedido',
                                      style: TextStyle(
                                          fontSize: Style.height_12(context),
                                          color: Style.tertiaryColor),
                                    ),
                                    SizedBox(
                                      width: Style.height_2(context),
                                    ),
                                    Icon(
                                      Icons.check,
                                      color: Style.tertiaryColor,
                                      size: Style.height_20(context),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
