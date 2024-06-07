import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Global/Elements/text_title.dart';
import 'package:projeto/Front/components/Login_Config/Elements/input.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/components/new_order/elements/register_button.dart';
import 'package:projeto/Front/components/new_order/elements/register_icon_button.dart';

class CustomerSession extends StatefulWidget {
  const CustomerSession({super.key});

  @override
  State<CustomerSession> createState() => _CustomerSessionState();
}

class _CustomerSessionState extends State<CustomerSession> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          TextTitle(text: 'Cliente'),
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
                SizedBox(
                  height: Style.height_10(context),
                ),
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
                          width: Style.width_250(context),
                          child: Input(
                              text: 'Informe o endereço',
                              type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_80(context),
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
                          width: Style.width_200(context),
                          child:
                              Input(text: 'Bairro', type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_130(context),
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
                          child: RegisterButton(
                            text: 'Cadastrar cliente',
                            color: Style.primaryColor,
                            width: Style.width_150(context),
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
                              RegisterIconButton(
                                text: 'Finalizar pedido',
                                color: Style.sucefullColor,
                                width: Style.height_150(context),
                                icon: Icons.check_rounded,
                              ),
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
