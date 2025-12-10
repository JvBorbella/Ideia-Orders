import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/company/alter_table_endpoint.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/orders/new_order.dart';
import 'package:projeto/back/orders/order_details.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/back/save_products.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/home/elements/drawer_button.dart';
import 'package:projeto/front/components/home/elements/order_container.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/pages/login.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:http/http.dart' as http;

final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>();

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
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<OrdersEndpoint> orders = [];
  List<ProductsEndpoint> products = [];
  List<OrdersDetailsEndpoint> ordersDetails = [];
  List<ListTablePrices> tables_price = [];
  List<CompanyList> company = [];

  bool isLoading = true, permNovaPrevenda = false, permEditarPrevenda = false;
  //permNovoPedido = false;

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  String urlController = '',
      selectedOptionChild = '',
      urlBasic = '',
      usuario_id = '',
      id = '',
      token = '',
      prevendaId = '',
      flagFilter = '',
      empresaid = '',
      tabelapreco_id_company = '',
      tabelapreco_id = '',
      flagpermitiralterartabela = '',
      perfilId = '',
      empresa_id = '',
      empresa_nome = '',
      empresa_codigo = '',
      tableprice = '',
      tableprice_id = '';

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
  late String filterValue = '';

  final _cepcontroller = TextEditingController(),
      _complementocontroller = TextEditingController(),
      _bairrocontroller = TextEditingController(),
      _cidadecontroller = TextEditingController(),
      _numerocontroller = TextEditingController(),
      _ufcontroller = TextEditingController(),
      _logradourocontroller = TextEditingController(),
      _emailcontroller = TextEditingController(),
      _cpfcontroller = TextEditingController(),
      _nomecontroller = TextEditingController(),
      _telefonecontatocontroller = TextEditingController();

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
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedFilter();
    loadData();
  }

  void _openModal(BuildContext context) {
    bool isLoadingButton = false;
    bool isLoadingSearch = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Modal('Abertura de pedido', [
              if (empresaid.isEmpty)
                Row(
                  children: [
                    Container(
                      height: Style.height_30(context),
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            buildMenuItemsCompany(company),
                        onSelected: (value) async {
                          if (value != '') {
                            setModalState(() {
                              empresa_id = value;
                              // Busca o nome da empresa correspondente ao ID selecionado
                              final selectedCompany = company.firstWhere(
                                (company) => company.empresa_id == value,
                              );
                              empresa_nome = selectedCompany?.empresa_nome ??
                                  ''; // Atualiza o nome
                              empresa_codigo =
                                  selectedCompany?.empresa_codigo ??
                                      ''; // Atualiza o nome
                            });
                            setState(() {
                              empresa_id = value;
                            });
                            await fetchDataTablePriceCompany(empresa_id);
                            await fetchDataTablePrice(empresa_id);
                            await fetchDataListTablesPrice(empresa_id);
                            await fetchDataTablePriceName();
                            setModalState(() {
                              tableprice;
                            });
                            setState(() {
                              tabelapreco_id = tabelapreco_id_company;
                            });
                          } else {
                            setState(() {
                              empresaid = '';
                              empresa_nome = '';
                              empresa_codigo = '';
                            });
                          }
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: Style.height_20(context),
                              ),
                              SizedBox(
                                width: Style.height_2(context),
                              ),
                              Container(
                                width: Style.width_180(context),
                                child: Text(
                                  empresa_nome.isEmpty
                                      ? 'Selecione a empresa'
                                      : '${empresa_codigo} - ${empresa_nome}',
                                  style: TextStyle(
                                    color: Style.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Style.height_12(context),
                                  ),
                                  //textAlign: TextAlign.center,
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
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 150,
                      child: Text(
                        empresa_codigo + ' ' + empresa_nome,
                        style: TextStyle(
                          color: Style.quarantineColor,
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
                  ],
                ),
              // SizedBox(
              //   height: Style.height_5(context),
              // ),
              if (flagpermitiralterartabela == '1')
                Row(
                  children: [
                    SizedBox(
                      height: Style.height_30(context),
                      child: PopupMenuButton<String>(
                        itemBuilder: (BuildContext context) =>
                            buildMenuItemsTPrice(tables_price),
                        onSelected: (value) async {
                          setModalState(() {
                            tableprice = value;
                          });
                          await DataServiceTablePriceId.fetchDataTablePriceId(
                              context, urlBasic, tableprice);
                          setState(() {
                            tableprice = value;
                            fetchDataTablePriceId();
                          });
                        },
                        child: Row(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.center,
                            // crossAxisAlignment:
                            //     CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: Style.primaryColor,
                                size: Style.height_20(context),
                              ),
                              SizedBox(
                                width: Style.height_2(context),
                              ),
                              Container(
                                width: Style.width_150(context),
                                child: Text(
                                  tableprice.isEmpty
                                      ? 'Tabela de Preço'
                                      : tableprice,
                                  style: TextStyle(
                                    color: Style.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Style.height_12(context),
                                  ),
                                  //textAlign: TextAlign.center,
                                  overflow: TextOverflow
                                      .clip, // corta o texto no limite da largura
                                  softWrap:
                                      true, // permite a quebra de linha conforme necessário
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // width: 150,
                      child: Text(
                        tableprice,
                        style: TextStyle(
                          color: Style.quarantineColor,
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
                  ],
                ),
              Input(
                text: 'CPF',
                type: TextInputType.text,
                textAlign: TextAlign.start,
                controller: _cpfcontroller,
                inputFormatters: [
                  CnpjCpfFormatter(
                    eDocumentType: EDocumentType.BOTH,
                  )

                  /// Máscara de CPF
                ],
                textInputAction: TextInputAction.unspecified,
                isLoadingButton: isLoadingSearch,
                IconButton: IconButton(
                  onPressed: () async {
                    setModalState(
                      () {
                        isLoadingSearch = true;
                      },
                    );
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
                    setModalState(
                      () {
                        isLoadingSearch = false;
                      },
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
              SizedBox(
                height: Style.height_10(context),
              ),
              RegisterButton(
                text: 'Abrir Pedido',
                color: Style.primaryColor,
                width: Style.width_150(context),
                isLoadingButton: isLoadingButton,
                onPressed: () async {
                  setModalState(() {
                    isLoadingButton = true;
                  });
                  var bodyMap = {
                    'cpf': _cpfcontroller.text,
                    'telefone': _telefonecontatocontroller.text,
                    'nome': _nomecontroller.text,
                    'empresa_id': empresa_id,
                    'tabelapreco_id': tabelapreco_id,
                  };

                  final hasInternet = await hasInternetConnection();

                  if (!hasInternet) {
                    final SharedListService produtosStorage =
                        SharedListService('orders_list');
                    await produtosStorage.addItem(bodyMap);
                    List<Map<String, dynamic>> lista =
                        await produtosStorage.getList();
                    print(lista);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        padding: EdgeInsets.all(
                            Style.SaveUrlMessagePadding(context)),
                        content: Text(
                          'Pedido armazenado localmente devido à falta de conexão com a internet.',
                          style: TextStyle(
                            fontSize: Style.SaveUrlMessageSize(context),
                            color: Style.tertiaryColor,
                          ),
                        ),
                        backgroundColor: Style.warningColor,
                      ),
                    );
                  } else {
                    final data = await DataServiceCliente2.fetchDataCliente2(
                        urlBasic, _cpfcontroller.text, token);
                    var pessoa_id = data['pessoa_id'].toString();
                    if (flagpermitiralterartabela == '1') {
                      await DataServiceNewOrder.sendDataOrder(
                          context,
                          urlBasic,
                          token,
                          _cpfcontroller.text,
                          _telefonecontatocontroller.text,
                          _nomecontroller.text,
                          pessoa_id,
                          tabelapreco_id,
                          empresa_id);
                    } else {
                      await DataServiceNewOrder.sendDataOrder(
                          context,
                          urlBasic,
                          token,
                          _cpfcontroller.text,
                          _telefonecontatocontroller.text,
                          _nomecontroller.text,
                          pessoa_id,
                          tabelapreco_id_company,
                          empresa_id);
                    }
                    fetchDataOrders(ascending: true, flagFilter: flagFilter);
                    setState(() {
                      selectedOptionChild = _getFilterText(flagFilter);
                    });
                  }

                  setModalState(() {
                    isLoadingButton = false;
                  });
                  _closeModal();
                  _cpfcontroller.clear();
                  _nomecontroller.clear();
                  _telefonecontatocontroller.clear();
                },
              )
            ]);
          });
        }).then((_) {
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
                  child: CustomDrawer(
                    empresa_codigo: empresa_codigo,
                    empresa_nome: empresa_nome,
                  )),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: SizedBox(
                width: Style.height_40(context), // Defina a largura desejada
                height: Style.height_40(context), // Defina a largura desejada
                child: FloatingActionButton(
                  backgroundColor: Style.primaryColor,
                  onPressed: () {
                    // if (permNovaPrevenda || permEditarPrevenda) {
                    _openModal(context);
                    // } else {
                    //   showDialog(
                    //       context: context,
                    //       builder: (_) => AlertDialogDefault());
                    // }
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
                                    'Finalizados',
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
                                if (value == 'finalizados') {
                                  filterValue = '1';
                                  setState(() {
                                    flagFilter = '1';
                                  });
                                } else if (value == 'abertos') {
                                  filterValue = '0';
                                  setState(() {
                                    flagFilter = '0';
                                  });
                                } else {
                                  filterValue = '';
                                  setState(() {
                                    flagFilter = '';
                                  });
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

                              if (orders[index]
                                      .flagpermitefaturar
                                      ?.toString() ==
                                  '1') {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => OrderPage(
                                            prevendaId:
                                                orders[index].prevendaId,
                                            pessoaid: pessoaid,
                                            numero:
                                                orders[index].numero.toString(),
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
                                            vendedorId:
                                                orders[index].vendedorId,
                                            valordesconto:
                                                orders[index].valordesconto)));
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
                                        empresa_id:
                                            orders[index].empresaId.toString(),
                                        valordesconto: orders[index]
                                            .valordesconto
                                            .toString()),
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
                              valordesconto: orders[index].valordesconto,
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

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _loadSavedEmpresaID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmpresaID = sharedPreferences.getString('empresa_id') ?? '';
    setState(() {
      empresaid = savedEmpresaID;
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

  Future<void> loadData() async {
    await Future.wait([clearCache()]);
    await Future.wait([
      _loadSavedUserId(),
      _loadSavedEmpresaID(),
      _loadSavedFilter(),
    ]);
    final hasInternet = await hasInternetConnection();

    if (!hasInternet) {
    } else {
      await getPermissions();
      await fetchDataTablePriceCompany(empresaid);
      await fetchDataTablePriceName();
      await fetchDataTablePrice(empresaid);
      await fetchDataListTablesPrice(empresaid);
      await fetchDataCompany();
      await Future.wait(
          [fetchDataOrders(flagFilter: flagFilter), fetchDataCliente2()]);
    }
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

  Future<void> _loadSavedFlagPermiteAlterTable() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      flagpermitiralterartabela =
          sharedPreferences.getString('flagpermitiralterartabela') ?? '';
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
            .where(
                (order) => order.flagpermitefaturar?.toString() == flagFilter)
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
                  margin: EdgeInsets.only(
                      left: Style.ModalMargin(context),
                      right: Style.ModalMargin(context)),
                  padding: EdgeInsets.all(Style.InternalModalPadding(context)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Style.ModalBorderRadius(context))),
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
                              padding: EdgeInsets.all(
                                  Style.ButtonExitPadding(context)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Style.ButtonExitBorderRadius(context)),
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
                              padding: EdgeInsets.all(
                                  Style.ButtonCancelPadding(context)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Style.ButtonExitBorderRadius(context)),
                                border: Border.all(
                                    width: Style.WidthBorderImageContainer(
                                        context),
                                    color: Style.secondaryColor),
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
                }));
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

  Future<void> fetchDataTablePriceCompany(String empresa_id) async {
    Map<String, dynamic>? fetchedDataTablePriceCompany =
        await DataServiceTablePrice.fetchDataTablePrice(
            context, urlBasic, empresa_id);
    if (fetchedDataTablePriceCompany != null) {
      setState(() {
        tabelapreco_id_company =
            fetchedDataTablePriceCompany['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataTablePriceName() async {
    Map<String, dynamic>? fetchedDataTablePriceName =
        await DataServiceTablePriceName.fetchDataTablePriceName(
            context, urlBasic, tabelapreco_id_company);
    if (fetchedDataTablePriceName != null) {
      setState(() {
        tableprice = fetchedDataTablePriceName['nome'] ?? '';
      });
    }
  }

  Future<void> fetchDataTablePriceId() async {
    Map<String, dynamic>? fetchedDataTablePriceId =
        await DataServiceTablePriceId.fetchDataTablePriceId(
            context, urlBasic, tableprice);
    if (fetchedDataTablePriceId != null) {
      setState(() {
        tabelapreco_id = fetchedDataTablePriceId['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataTablePrice(String empresa_id) async {
    Map<dynamic, dynamic>? fetchedDataTablePrice =
        await DataServiceAlterTableEndpoint.fetchDataAlterTableEndpoint(
            context, urlBasic, empresa_id);
    if (fetchedDataTablePrice != null) {
      setState(() {
        flagpermitiralterartabela =
            fetchedDataTablePrice['flagpermitiralterartabela'] ?? '';
      });
    }
  }

  Future<void> fetchDataListTablesPrice(String empresa_id) async {
    List<ListTablePrices>? fetchedData =
        await DataServiceListTablePrices.fetchDataListTablePrices(
            context, urlBasic, empresa_id, token);
    if (fetchedData != null) {
      setState(() {
        tables_price = fetchedData;
      });
    }
  }

  List<PopupMenuItem<String>> buildMenuItemsTPrice(
      List<ListTablePrices> tablesPrice) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tab. Preço'),
              Container(
                margin: EdgeInsets.only(bottom: Style.height_5(context)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Style.height_5(context)),
                    color: Style.errorColor),
                child: IconButton(
                  onPressed: () {
                    _closeModal();
                  },
                  icon:
                      Image.asset('assets/images/icon_remove/icon_remove.png'),
                  style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor)),
                ),
              ),
            ],
          )),
    ];
    const PopupMenuDivider();

    List<PopupMenuItem<String>> dynamicItems = tablesPrice.map((tables) {
      return PopupMenuItem<String>(
        value: tables.nome,
        child: Text((tables.nome).toString()),
      );
    }).toList();

    return staticItems + dynamicItems;
  }

  List<PopupMenuItem<String>> buildMenuItemsCompany(
      List<CompanyList> companyList) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Empresa'),
              Container(
                margin: EdgeInsets.only(bottom: Style.height_5(context)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Style.height_5(context)),
                    color: Style.errorColor),
                child: IconButton(
                  onPressed: () {
                    _closeModal();
                  },
                  icon:
                      Image.asset('assets/images/icon_remove/icon_remove.png'),
                  style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor)),
                ),
              ),
            ],
          )),
    ];
    const PopupMenuDivider();

    List<PopupMenuItem<String>> dynamicItems = companyList.map((companys) {
      return PopupMenuItem<String>(
        value: companys.empresa_id,
        child: Text(('${companys.empresa_codigo} - ${companys.empresa_nome}')
            .toString()),
        key: Key(companys.empresa_nome.toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return staticItems + dynamicItems;
  }

  Future<void> fetchDataCompany({bool? ascending}) async {
    List<CompanyList>? fetchedData = await DataServiceCompany.fetchDataCompany(
      context,
      urlBasic,
      empresaid,
    );

    if (fetchedData != null) {
      setState(() {
        company = fetchedData;
      });
      if (empresaid.isNotEmpty) {
        setState(() {
          empresa_nome = company.first.empresa_nome.toString();
          empresa_codigo = company.first.empresa_codigo.toString();
        });
      }
    }
  }

  Future<void> clearCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('editarPrevenda', false);
    await sharedPreferences.setBool('aplicarDesconto', false);
    await sharedPreferences.setBool('cadastrarCliente', false);
    await sharedPreferences.setBool('editarCliente', false);
    await sharedPreferences.setBool('criarPedido', false);
  }

  Future<void> getPermissions() async {
    try {
      var rawQuery =
          '''usuario%20u%20WHERE%20u.usuario_id%20=%20'$usuario_id'/''';
      var urlGet = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
      print(urlGet);
      var response = await http.get(urlGet, headers: {
        // 'auth-token': token,
        'Accept': 'text/html'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var dynamicKey = jsonResponse['data'].keys.first;
        var dataMap = jsonResponse['data'] as Map<String, dynamic>;
        if (dataMap.isNotEmpty) {
          var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
          print('Chave dinâmica encontrada: $dynamicKey');

          var userList = dataMap[dynamicKey] as List;
          if (userList.isNotEmpty) {
            var user = userList.first;
            var perfil_id = user['perfil_id']?.toString();
            setState(() {
              perfilId = perfil_id ?? usuario_id;
            });
            print(perfilId);
          } else {
            print('Nenhum item encontrado na lista.');
          }
          try {
            var rawQuery =
                '''permissao%20p%20WHERE%20p.usuario_id%20=%20'$perfilId'/''';
            var urlGet = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
            print(urlGet);
            var response = await http.get(urlGet, headers: {
              // 'auth-token': token,
              'Accept': 'text/html'
            });
            print(response.statusCode);
            if (response.statusCode == 200) {
              var jsonResponse = jsonDecode(response.body);
              var dynamicKey = jsonResponse['data'].keys.first;
              var dataMap = jsonResponse['data'] as Map<String, dynamic>;
              if (dataMap.isNotEmpty) {
                var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
                var dataList = dataMap[dynamicKey] as List;
                if (dataList != null && dataList is List) {
                  var listPermissoes = dataList.toList();
                  // bool criarPrevenda = listPermissoes.any((item) {
                  //   return item['formname']?.toString() == '4008' &&
                  //       item['compname']?.toString() == 'actNovo' &&
                  //       item['flag'] == 1;
                  // });
                  bool editarPrevenda = listPermissoes.any((item) {
                    return item['formname']?.toString() == '4008' &&
                        item['compname']?.toString() == 'actEditar' &&
                        item['flag'] == 1;
                  });
                  bool criarPedido = listPermissoes.any((item) {
                    return item['formname']?.toString() == '4002' &&
                        item['compname']?.toString() == 'actNovo' &&
                        item['flag'] == 1;
                  });
                  bool aplicarDesconto = listPermissoes.any((item) {
                    return item['formname']?.toString() == 'frmPrincipalImanager2' &&
                        item['compname']?.toString() ==
                            'actIdeiaPDVDescontoTotal' &&
                        item['flag'] == 1;
                  });
                  bool cadastrarCliente = listPermissoes.any((item) {
                    return item['formname']?.toString() == '1001' &&
                        item['compname']?.toString() == 'actNovo' &&
                        item['flag'] == 1;
                  });
                  bool editarCliente = listPermissoes.any((item) {
                    return item['formname']?.toString() == '1001' &&
                        item['compname']?.toString() == 'actEditar' &&
                        item['flag'] == 1;
                  });
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  // if (criarPrevenda) {
                  //   setState(() {
                  //     permNovaPrevenda = criarPrevenda;
                  //   });
                  //   await sharedPreferences.setBool(
                  //       'criarPrevenda', criarPrevenda);
                  // }
                  if (editarPrevenda) {
                    setState(() {
                      permEditarPrevenda = editarPrevenda;
                    });
                    await sharedPreferences.setBool(
                        'editarPrevenda', editarPrevenda);
                  }
                  if (criarPedido) {
                    await sharedPreferences.setBool('criarPedido', criarPedido);
                    // setState(() {
                    //   permNovoPedido = criarPedido;
                    // });
                    //print(permNovoPedido);
                  }
                  if (aplicarDesconto) {
                    await sharedPreferences.setBool(
                        'aplicarDesconto', aplicarDesconto);
                  }
                  if (cadastrarCliente) {
                    await sharedPreferences.setBool(
                        'cadastrarCliente', cadastrarCliente);
                  }
                  if (editarCliente) {
                    await sharedPreferences.setBool(
                        'editarCliente', editarCliente);
                  }
                }
              }
            }
          } catch (e) {
            print('Erro no endpoint permissoes: $e');
          }
        }
      } else {
        print('Erro na requisição ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro durante a requisição getPermissions $e');
    }
  }
}
