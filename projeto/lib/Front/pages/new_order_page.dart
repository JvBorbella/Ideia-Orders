import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Global/Elements/Navbar-Button.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/Front/components/new_order/sessions/product/product_session.dart';
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
            NavbarButton(destination: Home(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          ProductSession(),
          SizedBox(
            height: Style.height_30(context),
          ),
          CustomerSession(),
          SizedBox(
            height: Style.height_30(context),
          ),
        ],
      ),
    );
  }
}
