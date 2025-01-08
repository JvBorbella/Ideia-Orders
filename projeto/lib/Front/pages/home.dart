import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/new_order.dart';
import 'package:projeto/back/order_details.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Home/Elements/drawer_button.dart';
import 'package:projeto/front/components/Home/Elements/order_container.dart';
import 'package:projeto/front/components/home/elements/modal_button.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/pages/login.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class Home extends StatefulWidget {
  final String token;
  final String url;
  final String urlBasic;

  const Home({
    super.key,
    this.token = '',
    this.url = '',
    this.urlBasic = '',
  });

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
  String usuario_id = '';
  String id = '';
  String token = '';
  String prevendaId = '';
  String flagFilter = '';

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
  final _emailcontroller = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    _loadSavedId();
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedFilter();
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
                  textInputAction: TextInputAction.unspecified,
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
                        _emailcontroller,
                      );
                    },
                    icon: const Icon(Icons.person_search),
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
                  textInputAction: TextInputAction.unspecified,
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
                  textInputAction: TextInputAction.unspecified,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: Style.height_20(context),
                ),
                TextButton(
                  onPressed: () async {
                    final data = await DataServiceCliente2.fetchDataCliente2(
                        urlBasic, _cpfcontroller.text, token);
                    var pessoa_id = data['pessoa_id'].toString();
                    await DataServiceNewOrder.sendDataOrder(
                      context,
                      urlBasic,
                      token,
                      _cpfcontroller.text,
                      _telefonecontatocontroller.text,
                      _nomecontroller.text,
                      pessoa_id,
                    );
                    setState(() {
                      fetchDataOrders();
                    });
                    _closeModal();
                    _cpfcontroller.clear();
                    _nomecontroller.clear();
                    _telefonecontatocontroller.clear();
                  },
                  child: const Text('Abrir pedido'),
                )
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _cpfcontroller.clear();
      _nomecontroller.clear();
      _telefonecontatocontroller.clear();
    });
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
        child: WillPopScope(
            child: Scaffold(
              drawer: Drawer(
                width: MediaQuery.of(context).size.width * 0.9,
                child: CustomDrawer(),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: SizedBox(
                width: Style.height_40(context), // Defina a largura desejada
                height: Style.height_40(context), // Defina a largura desejada
                child: FloatingActionButton(
                  backgroundColor: Style.primaryColor,
                  onPressed: () {
                    _openModal(context);
                  },
                  shape: const CircleBorder(),
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
                      text: 'Pedidos',
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
                    ),
                    SizedBox(height: Style.height_10(context)),
                    const Center(child: TextTitle(text: 'Lista de pedidos')),
                    SizedBox(height: Style.height_10(context)),
                    Container(
                      padding: EdgeInsets.all(Style.height_15(context)),
                      margin: EdgeInsets.only(bottom: Style.height_20(context)),
                      decoration: BoxDecoration(
                        color: Style.defaultColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Style.height_25(context)),
                                              color: Style.errorColor),
                                          child: IconButton(
                                            onPressed: () {
                                              _closeModal();
                                            },
                                            icon: Image.asset(
                                                "assets/images/icon_remove/icon_remove.png"),
                                            style: const ButtonStyle(
                                                iconColor:
                                                    WidgetStatePropertyAll(
                                                        Style.tertiaryColor)),
                                          ),
                                        ),
                                      ],
                                    )),
                                PopupMenuDivider(
                                  height: Style.height_1(context),
                                ),
                                const PopupMenuItem<String>(
                                  labelTextStyle: WidgetStatePropertyAll(
                                      TextStyle(
                                          fontSize: 15,
                                          color: Style.primaryColor)),
                                  value: 'finalizados',
                                  child: Text(
                                    'Faturados',
                                  ),
                                ),
                                PopupMenuDivider(
                                  height: Style.height_1(context),
                                ),
                                const PopupMenuItem<String>(
                                  labelTextStyle: WidgetStatePropertyAll(
                                      TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins-Medium',
                                          color: Style.primaryColor)),
                                  value: 'abertos',
                                  child: Text(
                                    'Em aberto',
                                  ),
                                ),
                                PopupMenuDivider(
                                  height: Style.height_1(context),
                                ),
                                const PopupMenuItem<String>(
                                  labelTextStyle: WidgetStatePropertyAll(
                                      TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins-Medium',
                                          color: Style.primaryColor)),
                                  value: 'todos',
                                  child: Text('Todos'),
                                ),
                              ],
                              onSelected: (String value) async {
                                String filterValue;
                                if (value == 'finalizados') {
                                  filterValue = '1';
                                } else if (value == 'abertos') {
                                  filterValue = '0';
                                } else {
                                  filterValue = '';
                                }
                                await _saveFilter(filterValue);
                                await fetchDataOrders(
                                    ascending: true, flagFilter: filterValue);
                                setState(() {
                                  selectedOptionChild =
                                      _getFilterText(filterValue);
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
                                    SizedBox(
                                      width: Style.height_2(context),
                                    ),
                                    Text(
                                      'Filtrado por: ',
                                      style: TextStyle(
                                          fontSize: Style.height_12(context)),
                                    ),
                                    Container(
                                      // width: 150,
                                      child: Text(
                                        selectedOptionChild,
                                        style: TextStyle(
                                          color: Style.secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Style.height_12(context),
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow
                                            .clip, // corta o texto no limite da largura
                                        softWrap:
                                            true, // permite a quebra de linha conforme necessário
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
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
                                              prevendaId:
                                                  orders[index].prevendaId,
                                              pessoaid: pessoaid,
                                              numero: orders[index]
                                                  .numero
                                                  .toString(),
                                              pessoanome: pessoanome,
                                              cpfcnpj: cpfcnpj,
                                              telefone: telefone,
                                              datahora: orders[index].datahora,
                                              valortotal:
                                                  orders[index].valortotal,
                                              codigoproduto: codigoproduto,
                                              endereco: endereco,
                                              uf: uf,
                                              operador: orders[index].operador,
                                            )));
                              } else {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => NewOrderPage(
                                      prevendaId: orders[index].prevendaId,
                                      pessoaid: pessoaid.toString(),
                                      numero: orders[index].numero.toString(),
                                      pessoanome: pessoanome.toString(),
                                      cpfcnpj: cpfcnpj.toString(),
                                      telefone: telefone.toString(),
                                      datahora: orders[index].datahora,
                                      valortotal: orders[index].valortotal,
                                      codigoproduto: codigoproduto,
                                      operador: orders[index].operador,
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
                              flagpermitefaturar:
                                  orders[index].flagpermitefaturar.toString(),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              openModal(context);
              return true;
            }));
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedUserId(),
    ]);
    await Future.wait(
        [fetchDataOrders(flagFilter: flagFilter), fetchDataCliente2()]);
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _loadSavedUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUserId = sharedPreferences.getString('usuario_id') ?? '';
    setState(() {
      usuario_id = savedUserId;
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
    setState(() {
      isLoading =
          true; // Define isLoading como true para mostrar o indicador de carregamento
    });
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  // Função para salvar o filtro no SharedPreferences
  Future<void> _saveFilter(String filter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('flagFilter', filter);
  }

  // Função para carregar o filtro do SharedPreferences
  Future<void> _loadSavedFilter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      flagFilter = sharedPreferences.getString('flagFilter') ?? '';
      selectedOptionChild = _getFilterText(flagFilter);
    });
  }

  // Função para obter o texto do filtro com base no flagFilter
  String _getFilterText(String filter) {
    switch (filter) {
      case '1':
        return 'Finalizados';
      case '0':
        return 'Em aberto';
      default:
        return 'Todos';
    }
  }

  Future<void> fetchDataOrders({bool? ascending, String? flagFilter}) async {
    List<OrdersEndpoint>? fetchData = await DataServiceOrders.fetchDataOrders(
        context, urlBasic, usuario_id, token,
        ascending: ascending);

    if (fetchData != null) {
      // Aplicando o filtro baseado no campo flagpermitefaturar
      if (flagFilter != null && flagFilter.isNotEmpty) {
        fetchData = fetchData
            .where((order) => order.flagpermitefaturar == flagFilter)
            .toList();
      }
      setState(() {
        orders = fetchData!;
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

  late BuildContext modalContext;

  void openModal(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          height: Style.ModalSize(context),
          child: WillPopScope(
            child: Container(
            //Tamanho e espaçamento interno do modal
            height: Style.InternalModalSize(context),
            margin: EdgeInsets.only(left: Style.ModalMargin(context), right: Style.ModalMargin(context)),
            padding: EdgeInsets.all(Style.InternalModalPadding(context)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Style.ModalBorderRadius(context))),
            child: Column(
              //Conteúdo interno do modal
              children: [
                Row(
                  children: [
                    Text(
                      'Deseja sair da aplicação?',
                      style: TextStyle(
                        fontSize: Style.height_15(context),
                        color: Style.primaryColor,
                      ),
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_30(context),
                ),
                Row(
                  //Espaçamento entre os Buttons
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Buttom de sair
                    TextButton(
                      onPressed: () async {
                        _sair();
                      },
                      child: Container(
                        width: Style.ButtonExitWidth(context),
                        // height: Style.ButtonExitHeight(context),
                        padding: EdgeInsets.all(Style.ButtonExitPadding(context)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Style.ButtonExitBorderRadius(context)),
                            color: Style.primaryColor),
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Style.tertiaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Style.height_10(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //Buttom para fechar o modal
                    TextButton(
                      onPressed: () {
                        _closeModal();
                      },
                      child: Container(
                        // width: Style.ButtonCancelWidth(context),
                        // height: Style.ButtonCancelHeight(context),
                        padding: EdgeInsets.all(Style.ButtonCancelPadding(context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Style.ButtonExitBorderRadius(context)),
                          border:
                              Border.all(width: Style.WidthBorderImageContainer(context), color: Style.secondaryColor),
                          color: Style.tertiaryColor,
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Style.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Style.height_10(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ), 
            onWillPop: () async {
              closeModal();
              return true;
            }
            ) 
            
        );
      },
    );
  }

  void closeModal() {
    //Função para fechar o modal
    Navigator.of(modalContext).pop();
  }

  void _sair() {
   Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }
}
