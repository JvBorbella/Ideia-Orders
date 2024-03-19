import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Home/Elements/ModalButtom.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/login.dart';

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
        body: RefreshIndicator(
          onRefresh: () => _refreshData(),
          child: ListView(
            children: [
              Navbar(
                children: [
                  NavbarButton(),
                ],
                text: 'Página inicial',
              ),
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      padding: EdgeInsets.all(12),
                      child: SearchBar(
                        constraints: BoxConstraints(),
                        leading: const Icon(
                          Icons.search,
                          color: Style.primaryColor,
                        ),
                        hintText: 'Pesquise o código do pedido',
                        hintStyle: MaterialStatePropertyAll(
                            TextStyle(color: Style.quarantineColor)),
                        backgroundColor:
                            MaterialStatePropertyAll(Style.lightGreyColor),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.only(left: 16, right: 16)),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Lista de pedidos'),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                        top: BorderSide(color: Style.lightGreyColor),
                        bottom: BorderSide(color: Style.lightGreyColor),
                      )),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(12)),
                          Text('Data - 00/00/0000'),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Style.primaryColor,
                          )
                        ],
                      ),
                    ),
                    Text(
                      'Não há nenhum pedido!',
                      style: TextStyle(
                        color: Style.quarantineColor,
                      ),
                      // textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
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
