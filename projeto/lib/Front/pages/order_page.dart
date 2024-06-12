import 'package:flutter/material.dart';

import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/order_page/elements/cancel_button.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
import 'package:projeto/front/components/order_page/elements/products_order.dart';
import 'package:projeto/front/pages/home.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          Navbar(text: 'Pedido', children: [
            NavbarButton(destination: Home(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            height: Style.height_35(context),
            margin: EdgeInsets.only(
              left: Style.height_8(context),
              right: Style.height_8(context),
            ),
            padding: EdgeInsets.all(Style.height_8(context)),
            decoration: BoxDecoration(
              color: Style.primaryColor,
              borderRadius: BorderRadius.circular(Style.height_15(context)),
            ),
            child: Text(
              'Nº do pedido - 000000',
              style: TextStyle(
                  fontSize: Style.height_15(context),
                  color: Style.tertiaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.only(left: Style.height_12(context)),
            child: Text(
              'Data do pedido - 07/06/2024',
              style: TextStyle(
                  color: Style.primaryColor,
                  fontSize: Style.height_12(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Style.height_10(context),
          ),
          TextTitle(text: 'Produto(s)'),
          SizedBox(
            height: Style.height_10(context),
          ),
          ProductsOrder(),
          ProductsOrder(),
          ProductsOrder(),
          SizedBox(
            height: Style.height_10(context),
          ),
          Center(
            child: Text(
              'Total - RS 000,00',
              style: TextStyle(
                  color: Style.primaryColor,
                  fontSize: Style.height_15(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextTitle(text: 'Dados do Cliente'),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            padding: EdgeInsets.only(
                left: Style.height_15(context),
                right: Style.height_15(context)),
            child: Column(
              children: [
                InputBlocked(value: 'Nome do cliente'),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        children: [InputBlocked(value: 'CPF')],
                      ),
                    ),
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        children: [InputBlocked(value: 'Telefone')],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                InputBlocked(value: '(Endereço)'),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_225(context),
                      child: Column(
                        children: [InputBlocked(value: '(Cidade)')],
                      ),
                    ),
                    Container(
                      width: Style.width_80(context),
                      child: Column(
                        children: [InputBlocked(value: '(UF)')],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        children: [InputBlocked(value: '(Bairro)')],
                      ),
                    ),
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        children: [InputBlocked(value: '(CEP)')],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_20(context),
                ),
                CancelButton(),
                SizedBox(
                  height: Style.height_10(context),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
