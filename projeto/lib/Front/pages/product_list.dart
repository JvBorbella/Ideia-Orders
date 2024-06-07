import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Global/Elements/Navbar-Button.dart';
import 'package:projeto/Front/components/Global/Elements/text_title.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/components/product_page/elements/product_add.dart';
import 'package:projeto/Front/pages/new_order_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Navbar(text: 'Produtos', children: [
            NavbarButton(destination: NewOrderPage(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            height: Style.height_60(context),
            padding: EdgeInsets.all(Style.height_12(context)),
            child: SearchBar(
              constraints: BoxConstraints(),
              leading: const Icon(
                Icons.search,
                color: Style.primaryColor,
              ),
              hintText: 'Pesquise o código do produto',
              hintStyle: WidgetStatePropertyAll(
                  TextStyle(color: Style.quarantineColor)),
              // backgroundColor:
              //     WidgetStatePropertyAll(Style.tertiaryColor),
              padding: WidgetStatePropertyAll(EdgeInsets.only(
                  left: Style.height_15(context),
                  right: Style.height_15(context))),
            ),
          ),
          SizedBox(
            height: Style.height_10(context),
          ),
          TextTitle(text: 'Lista de produtos'),
          SizedBox(
            height: Style.height_10(context),
          ),
          ProductAdd(),
          ProductAdd(),
          ProductAdd(),
          ProductAdd(),
          ProductAdd(),
          ProductAdd()
        ],
      ),
    );
  }
}
