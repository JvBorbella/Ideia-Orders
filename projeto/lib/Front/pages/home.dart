import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto/back/get_cliente.dart';
// import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/new_order.dart';
import 'package:projeto/back/order_details.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Home/Elements/drawer_button.dart';
import 'package:projeto/front/components/Home/Elements/order_container.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
// import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

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
  String id = '';
  String token = '';
  String prevendaId = '';

  late String pessoanome = '';
  late String cpfcnpj = '';
  late String telefone = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String enderecocidade = '';
  late String endereconumero = '';
  late String enderecocomplemento = '';
  late String enderecocep = '';
  late String uf = '';
  late String codigoproduto = '';

  late String pessoaid = '';
  late String nome = '';
  late String codigo = '';
  late String cpfcliente = '';

  final _cepcontroller = TextEditingController();
  final _complementocontroller = TextEditingController();
  final _bairrocontroller = TextEditingController();
  final _cidadecontroller = TextEditingController();
  final _numerocontroller = TextEditingController();
  final _ufcontroller = TextEditingController();
  final _logradourocontroller = TextEditingController();

  final _cpfcontroller = TextEditingController();
  final _nomecontroller = TextEditingController();
  final _telefonecontatocontroller = TextEditingController();

  String formatCpfCnpj(String cpfCnpj) {
    if (cpfCnpj.length == 11) {
      // CPF
      return UtilBrasilFields.obterCpf(cpfCnpj);
    } else if (cpfCnpj.length == 14) {
      // CNPJ
      return UtilBrasilFields.obterCnpj(cpfCnpj);
    } else {
      // Não formatado
      return cpfCnpj;
    }
  }

  String formatTel(String telefonecontato) {
    if (telefonecontato.length > 10) {
      // CPF
      return UtilBrasilFields.obterTelefone(telefonecontato);
    } else {
      // Não formatado
      return telefonecontato;
    }
  }

  // final cepFormatter = MaskTextInputFormatter(
  //     mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  // final cpfFormatter = MaskTextInputFormatter(
  //   mask: '###.###.###-##',
  //   filter: {"#": RegExp(r'[0-9]')},
  // );

  @override
  void initState() {
    super.initState();
    _loadSavedId();
    _loadSavedUrlBasic();
    _loadSavedToken();
    loadData();
  }

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(Style.height_8(context)),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Style.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Style.height_20(context)),
                      topRight: Radius.circular(Style.height_20(context)),
                    ),
                  ),
                  child: Text(
                    'Abertura do pedido',
                    style: TextStyle(
                      fontSize: Style.height_15(context),
                      fontWeight: FontWeight.bold,
                      color: Style.tertiaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'CPF',
                  type: TextInputType.text,
                  textAlign: TextAlign.start,
                  controller: _cpfcontroller,
                  inputFormatters: [
                    MaskedInputFormatter('000.000.000-00'), // Máscara de CPF
                  ],
                  IconButton: IconButton(
                    onPressed: () async {
                      await GetCliente.getcliente(
                        context,
                        urlBasic,
                        _nomecontroller,
                        _cpfcontroller,
                        _telefonecontatocontroller,
                        _cepcontroller,
                        _logradourocontroller,
                        _ufcontroller,
                        _bairrocontroller,
                        _numerocontroller,
                        _complementocontroller,
                        _cidadecontroller,
                      );
                    },
                    icon: Icon(Icons.person_search),
                  ),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Telefone',
                  type: TextInputType.text,
                  controller: _telefonecontatocontroller,
                  textAlign: TextAlign.start,
                  inputFormatters: [
                    MaskedInputFormatter('(00) 00000-0000'), // Máscara de CPF
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Nome do cliente',
                  type: TextInputType.text,
                  controller: _nomecontroller,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: Style.height_20(context),
                ),
                TextButton(
                    onPressed: () async {
                      await DataServiceNewOrder.sendDataOrder(
                        context,
                        urlBasic,
                        token,
                        _cpfcontroller.text,
                        _telefonecontatocontroller.text,
                        _nomecontroller.text,
                      );
                      setState(() {
                        fetchDataOrders();
                      });
                      _closeModal();
                      _cpfcontroller.clear();
                      _nomecontroller.clear();
                      _telefonecontatocontroller.clear();
                    },
                    child: Text('Abrir pedido'))
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
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
        child: WillPopScope(
            child: Scaffold(
              drawer: Drawer(
                child: CustomDrawer(),
                width: MediaQuery.of(context).size.width * 0.9,
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: Container(
                width: Style.height_40(context), // Defina a largura desejada
                height: Style.height_40(context), // Defina a largura desejada
                child: FloatingActionButton(
                  backgroundColor: Style.primaryColor,
                  onPressed: () {
                    _openModal(context);
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
                            iconColor:
                                WidgetStatePropertyAll(Style.tertiaryColor),
                            padding: WidgetStatePropertyAll(EdgeInsets.all(
                                Style.PaddingDrawerButton(context))),
                          ),
                        ),
                      ],
                      text: 'Pedidos',
                    ),
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
                    //     padding: WidgetStatePropertyAll(
                    //       EdgeInsets.only(
                    //           left: Style.height_15(context),
                    //           right: Style.height_15(context)),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: Style.height_10(context)),
                    Center(child: TextTitle(text: 'Lista de pedidos')),
                    SizedBox(height: Style.height_10(context)),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              await fetchDataOrdersDetails2(
                                orders[index].prevendaId,
                              );

                              if (orders[index].flagpermitefaturar == '1') {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => OrderPage(
                                              prevendaId: orders[index].prevendaId,
                                              numero: orders[index].numero.toString(),
                                              pessoanome: pessoanome,
                                              cpfcnpj: cpfcnpj,
                                              telefone: telefone,
                                              datahora: orders[index].datahora,
                                              valortotal: orders[index].valortotal,
                                              codigoproduto: codigoproduto,
                                              endereco: endereco,
                                              // enderecobairro: enderecobairro,
                                              // enderecocep: enderecocep,
                                              // enderecocomplemento: enderecocomplemento,
                                              uf: uf,
                                              operador: orders[index].operador,
                                            )));
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => NewOrderPage(
                                      prevendaId: orders[index].prevendaId,
                                      numero: orders[index].numero.toString(),
                                      pessoanome: pessoanome.toString(),
                                      cpfcnpj: cpfcnpj.toString(),
                                      telefone: telefone.toString(),
                                      datahora: orders[index].datahora,
                                      valortotal: orders[index].valortotal,
                                      codigoproduto: codigoproduto,
                                      // Passe outros campos conforme necessário
                                    ),
                                  ),
                                );
                              }
                            },
                            child: OrderContainer(
                              numero: orders[index].numero.toString(),
                              valortotal: orders[index].valortotal,
                              nomepessoa: orders[index].nomepessoa,
                              data: orders[index].datahora,
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              return false;
            }));
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
    ]);
    await Future.wait([fetchDataOrders(), fetchDataCliente2()]);
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _loadSavedId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedId = sharedPreferences.getString('id') ?? '';
    setState(() {
      id = savedId;
    });
  }

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
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
        await DataServiceOrders.fetchDataOrders(context, urlBasic, id, token);
    if (fetchData != null) {
      setState(() {
        orders = fetchData;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataOrdersDetails2(String prevendaId) async {
    final data = await DataServiceOrdersDetails2.fetchDataOrdersDetails2(
        urlBasic, prevendaId);
    setState(() {
      pessoanome = data['pessoa_nome'].toString();
      cpfcnpj = data['cpfcnpj'].toString();
      telefone = data['telefone'].toString();
      codigoproduto = data['codigo'].toString();
    });
  }

  Future<void> fetchDataCliente2() async {
    final data = await DataServiceCliente2.fetchDataCliente2(
        urlBasic, _cpfcontroller.text, token);
    setState(() {
      pessoaid = data['pessoa_id'].toString();
      nome = data['nome'].toString();
      cpfcliente = data['cpf'].toString();
      telefone = data['telefone'].toString();
      endereco = data['endereco'].toString();
      enderecobairro = data['enderecobairro'].toString();
      endereconumero = data['endereconumero'].toString();
      enderecocomplemento = data['enderecocomplemento'].toString();
      enderecocep = data['enderecocep'].toString();
      enderecocidade = data['enderecocidade'].toString();
      uf = data['uf'].toString();
      codigo = data['codigo'].toString();
    });
  }
}
