import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/company_sales_monitor.dart';
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
  late String numero = '';
  late String data = '';
  late String valortotal = '';
  late String nomepessoa = '';
  String urlController = '';
  bool isLoading = true;
  NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  String selectedOptionChild = '';
  String urlBasic = '';

  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    loadData();
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
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Style.primaryColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewOrderPage()));
          },
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Style.tertiaryColor,
            size: Style.height_15(context),
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
                      iconSize: WidgetStatePropertyAll(Style.SizeDrawerButton(context)),
                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor),
                      padding: WidgetStatePropertyAll(EdgeInsets.all(Style.PaddingDrawerButton(context))),
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
                  hintStyle: WidgetStatePropertyAll(TextStyle(color: Style.quarantineColor)),
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.only(left: Style.height_15(context), right: Style.height_15(context)),
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
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem(
                            enabled: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: Style.height_5(context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(Style.height_5(context)),
                                    color: Style.errorColor,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // _closeModal();
                                    },
                                    icon: Image.network('https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/05/icons8-excluir-20.png'),
                                    style: ButtonStyle(
                                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor),
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
                              style: TextStyle(fontSize: Style.height_12(context)),
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderPage()));
                },
                child: OrderContainer(
                  numero: numero,
                  data: data,
                  nomepessoa: nomepessoa,
                  valortotal: valortotal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    // Utiliza Future.wait para buscar os dados de forma paralela
    await Future.wait([
      _loadSavedUrlBasic()
      ]);

    // Após carregar os dados do token e da URL, chama as funções para buscar os dados
    await Future.wait([
      fetchDataSalesMonitor()
    ]);
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
    print(urlBasic);
  }

  Future<void> _refreshData() async {
    // Aqui você pode chamar os métodos para recarregar os dados
    await loadData();
    setState(() {
      isLoading = false; // Define isLoading como false para esconder o indicador de carregamento
    });
  }

  Future<void> fetchDataSalesMonitor() async {
    Map<String?, String?> fetchData = await DataServiceSalesMonitor.fetchDataSalesMonitor(urlBasic);
    print(fetchData);  // Verifica os dados obtidos
    if (fetchData.isNotEmpty) {
      setState(() {
        numero = fetchData['numero'] ?? '';
        valortotal = fetchData['valortotal'] ?? '';
        data = fetchData['data'] ?? '';
        nomepessoa = fetchData['nomepessoa'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;  // Mesmo que os dados estejam vazios, para esconder o indicador
      });
    }
  }
}
