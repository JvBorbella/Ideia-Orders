import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Home/Elements/drawer_button.dart';
import 'package:projeto/Front/components/Home/Elements/order_container.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/new_order_page.dart';

class Home extends StatefulWidget {
  final token;
  final String url;
  final String urlBasic;

  const Home({
    Key? key,
    this.token,
    this.url = '',
    this.urlBasic = '',
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String urlController = '';
  bool isLoading = true;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: CustomDrawer(),
          width: MediaQuery.of(context).size.width * 0.9,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Style.primaryColor,
          onPressed: () {
            Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewOrderPage()));
          },
          shape: CircleBorder(),
          child: Icon(
            (Icons.add),
            color: Style.tertiaryColor,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refreshData(),
          child: ListView(
            children: [
              // Navbar(
              //   children: [
              //     DrawerButton(
              //       style: ButtonStyle(
              //           iconSize: WidgetStatePropertyAll(
              //               Style.SizeDrawerButton(context)),
              //           iconColor: WidgetStatePropertyAll(Style.tertiaryColor),
              //           padding: WidgetStatePropertyAll(EdgeInsets.all(
              //               Style.PaddingDrawerButton(context)))),
              //     ),
              //   ],
              //   text: 'Pedidos',
              // ),
              // Container(
              //   height: Style.height_60(context),
              //   padding: EdgeInsets.all(Style.height_12(context)),
              //   child: SearchBar(
              //     constraints: BoxConstraints(),
              //     leading: const Icon(
              //       Icons.search,
              //       color: Style.primaryColor,
              //     ),
              //     hintText: 'Pesquise o código do pedido',
              //     hintStyle: WidgetStatePropertyAll(
              //         TextStyle(color: Style.quarantineColor)),
              //     // backgroundColor:
              //     //     WidgetStatePropertyAll(Style.tertiaryColor),
              //     padding: WidgetStatePropertyAll(EdgeInsets.only(
              //         left: Style.height_15(context),
              //         right: Style.height_15(context))),
              //   ),
              // ),
              // SizedBox(
              //   height: Style.height_10(context),
              // ),
              // Text('Lista de pedidos'),
              // Expanded(
              //   child: Center(
              //     child: Text(
              //       'Não há mais solicitações!',
              //       style: TextStyle(
              //         color: Style.quarantineColor,
              //       ),
              //       textAlign: TextAlign.center,
              //     ),
              //   ),
              // ),
              Navbar(
                children: [
                  DrawerButton(
                    style: ButtonStyle(
                        iconSize: WidgetStatePropertyAll(
                            Style.SizeDrawerButton(context)),
                        iconColor: WidgetStatePropertyAll(Style.tertiaryColor),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(
                            Style.PaddingDrawerButton(context)))),
                  ),
                ],
                text: 'Pedidos',
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
                  hintText: 'Pesquise o código do pedido',
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
              Center(
                child: Text('Lista de pedidos'),
              ),
              SizedBox(
                height: Style.height_10(context),
              ),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),
              OrderContainer(),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Aqui você pode chamar os métodos para recarregar os dados
    // Exemplo: await loadData();
    setState(() {
      isLoading =
          true; // Define isLoading como true para mostrar o indicador de carregamento
    });
  }
}
