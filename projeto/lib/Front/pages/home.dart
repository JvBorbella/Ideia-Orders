import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/order_details.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Home/Elements/drawer_button.dart';
import 'package:projeto/front/components/Home/Elements/order_container.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String token;
  final String url;
  final String urlBasic;

  const Home({
    Key? key,
    this.token = '',
    this.url = '',
    this.urlBasic = '',
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<OrdersEndpoint> orders = [];
  List<ProductsEndpoint> products = [];
  List<OrdersDetailsEndpoint> ordersDetails = [];
  String urlController = '';
  bool isLoading = true;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  String selectedOptionChild = '';
  String urlBasic = '';
  String prevendaId = '';

  late String nome = '';
  late String cpfcnpj = '';
  late String telefonecontato = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String enderecocomplemento = '';
  late String enderecocep = '';
  late String uf = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    // _loadSavedPrevendaId();
    loadData();
    // fetchDataOrdersDetails2();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: CustomDrawer(),
          width: MediaQuery.of(context).size.width * 0.9,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Container(
          width: Style.height_40(context), // Defina a largura desejada
          height: Style.height_40(context), // Defina a largura desejada
          child: FloatingActionButton(
            backgroundColor: Style.primaryColor,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewOrderPage()));
            },
            shape: CircleBorder(),
            child: Icon(
              Icons.add,
              color: Style.tertiaryColor,
              size: Style.height_20(context),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Navbar(
                children: [
                  DrawerButton(
                    style: ButtonStyle(
                      iconSize: WidgetStatePropertyAll(
                          Style.SizeDrawerButton(context)),
                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.all(Style.PaddingDrawerButton(context))),
                    ),
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
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.only(
                        left: Style.height_15(context),
                        right: Style.height_15(context)),
                  ),
                ),
              ),
              SizedBox(height: Style.height_10(context)),
              Center(child: TextTitle(text: 'Lista de pedidos')),
              SizedBox(height: Style.height_10(context)),
              Container(
                padding: EdgeInsets.all(Style.height_12(context)),
                margin: EdgeInsets.only(bottom: Style.height_10(context)),
                decoration: BoxDecoration(
                  color: Style.defaultColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: Style.height_30(context),
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            enabled: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: Style.height_5(context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Style.height_5(context)),
                                    color: Style.errorColor,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // _closeModal();
                                    },
                                    icon: Image.network(
                                        'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/05/icons8-excluir-20.png'),
                                    style: ButtonStyle(
                                      iconColor: WidgetStatePropertyAll(
                                          Style.tertiaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuDivider(height: Style.height_1(context)),
                          const PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Medium',
                              color: Style.primaryColor,
                            )),
                            value: 'Todos',
                            child: Text('Todos'),
                          ),
                          PopupMenuDivider(height: Style.height_1(context)),
                          const PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Medium',
                              color: Style.primaryColor,
                            )),
                            value: 'Faturados',
                            child: Text('Faturados'),
                          ),
                          PopupMenuDivider(height: Style.height_1(context)),
                          const PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins-Medium',
                              color: Style.primaryColor,
                            )),
                            value: 'Cancelados',
                            child: Text('Cancelados'),
                          ),
                        ],
                        onSelected: (String value) async {
                          if (value == 'Todos') {
                            // Filtrar por todos
                          } else if (value == 'Faturados') {
                            // Filtrar por faturados
                          } else if (value == 'Cancelados') {
                            // Filtrar por cancelados
                          }
                          setState(() {
                            selectedOptionChild = value;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_outlined,
                              color: Style.primaryColor,
                              size: Style.height_20(context),
                            ),
                            SizedBox(width: Style.height_2(context)),
                            Text(
                              'Filtrado por: ',
                              style:
                                  TextStyle(fontSize: Style.height_12(context)),
                            ),
                            Container(
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Style.secondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Style.height_12(context),
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await fetchDataOrdersDetails2(orders[index].prevendaId);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderPage(
                              prevendaId: orders[index].prevendaId,
                              numero: orders[index].numero.toString(),
                              nome: nome,
                              cpfcnpj: cpfcnpj,
                              telefonecontato: telefonecontato,
                              endereco: endereco,
                              enderecobairro: enderecobairro,
                              enderecocomplemento: enderecocomplemento,
                              enderecocep: enderecocep,
                              uf: uf,
                              data: orders[index].data,
                              datahora: orders[index].datahora,
                              valorsubtotal: orders[index].valorsubtotal,
                              // Passe outros campos conforme necessário
                            ),
                          ),
                        );
                      },
                      child: OrderContainer(
                        numero: orders[index].numero.toString(),
                        valortotal: orders[index].valortotal,
                        nomepessoa: orders[index].nomepessoa,
                        data: orders[index].data,
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    await Future.wait([_loadSavedUrlBasic()]);
    await Future.wait([
      fetchDataOrders(),
    ]);
    await Future.wait([
      // fetchDataOrdersDetails(),
    ]);
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataOrders() async {
    List<OrdersEndpoint>? fetchData =
        await DataServiceOrders.fetchDataOrders(urlBasic);
    if (fetchData != null) {
      setState(() {
        orders = fetchData;
      });
      // Chama fetchDataOrdersDetails para cada prevenda_id
      // for (var order in fetchData) {
      //   print("Fetching details for order: ${order.prevendaId}");
      //   await fetchDataOrdersDetails(order.prevendaId);
      // }
    }
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> fetchDataOrdersDetails() async {
  //   List<OrdersDetailsEndpoint>? fetchData =
  //       await DataServiceOrdersDetails.fetchDataOrdersDetails(urlBasic, prevendaId);
  //   if (fetchData != null) {
  //     setState(() {
  //       ordersDetails = fetchData;
  //     });
  //   }
  // }

  // Future<void> fetchDataOrdersDetails(String prevendaId) async {
  //   print("Fetching order details for prevendaId: $prevendaId");
  //   List<OrdersDetailsEndpoint>? fetchData =
  //       await DataServiceOrdersDetails.fetchDataOrdersDetails(urlBasic, prevendaId);
  //   print("Order details fetched: $fetchData");
  //   if (fetchData != null) {
  //     setState(() {
  //       ordersDetails.addAll(fetchData);
  //     });
  //   }
  // }

  Future<void> fetchDataOrdersDetails2(String prevendaId) async {
    final data = await DataServiceOrdersDetails2.fetchDataOrdersDetails2(
        urlBasic, prevendaId);
    setState(() {
      nome = data['nome'].toString();
      cpfcnpj = data['cpfcnpj'].toString();
      telefonecontato = data['telefonecontato'].toString();
      endereco = data['endereco'].toString();
      enderecobairro = data['enderecobairro'].toString();
      enderecocomplemento = data['enderecocomplemento'].toString();
      enderecocep = data['enderecocep'].toString();
      uf = data['uf'].toString();
      //...
    });
  }
}
