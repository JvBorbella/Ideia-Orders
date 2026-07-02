import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:projeto/back/check_internet.dart';
import 'package:projeto/back/customer/get_cep.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/get_image.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/back/system/pdf_generator.dart';
import 'package:projeto/back/system/reprint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/order_page/elements/name_inputblocked.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderPage extends StatefulWidget {
  final String? prevendaId,
      localId,
      pessoaId,
      empresaId,
      numero,
      pessoanome,
      cpfcnpj,
      telefone,
      endereco,
      bairro,
      cidade,
      cep,
      complemento,
      uf,
      operador,
      vendedorId,
      codigoproduto,
      empresa;
  final DateTime datahora;
  final double? valortotal, valordesconto;

  const OrderPage(
      {super.key,
      this.prevendaId,
      this.localId,
      this.pessoaId,
      this.empresaId,
      this.numero,
      this.pessoanome,
      this.cpfcnpj,
      this.telefone,
      this.endereco,
      this.bairro,
      this.cidade,
      this.cep,
      this.complemento,
      this.uf,
      required this.datahora,
      this.valortotal,
      this.codigoproduto,
      this.operador,
      this.vendedorId,
      this.valordesconto,
      this.empresa});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String urlBasic = '', token = '', ibge = '', cidade = '';

  late String pessoaid = '';
  late String nome = '';
  late String codigo = '';
  late String pessoanome = '';
  late String cpfcliente = '';
  late String cpf = '';
  late String telefone = '';
  late String enderecocep = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String enderecocidade = '';
  late String endereconumero = '';
  late String enderecocomplemento = '';
  late String uf = '';
  late String email = '';

  late String nomeproduto = '';
  late String codigoproduto = '';
  late String imagemurl = '';
  late String prevendaprodutoid = '';
  late String produtoid = '';
  late double valorunitario = 0.0;
  late double valortotalitem = 0.0;
  late double valortotal = 0.0;
  late double quantidade = 0.0;

  final _complementocontroller2 = TextEditingController();
  final _bairrocontroller = TextEditingController();
  final _localidadecontroller = TextEditingController();
  final _ibgecontroller = TextEditingController();
  final _ufcontroller = TextEditingController();
  final _logradourocontroller = TextEditingController();

  List<OrdersDetailsEndpoint> orders = [];
  List<dynamic> options = [];

  bool isLoadingButtonLocal = false,
      isLoadingButtonNetwork = false,
      printBool = true;

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final _cpfMaskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telMaskFormatter = MaskTextInputFormatter(mask: '(##) #####-####');

  final cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  String vendedorCodigo = '';
  String vendedorNome = '';

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    loadData();
    _refreshData();
  }

  Future<void> checkConnection() async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      setState(() {
        printBool = false;
      });
    }
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
      child: PopScope(
        canPop: false,
        // onPopInvokedWithResult: (didPop, result) => Navigator.of(context)
        //     .pushReplacement(
        //         MaterialPageRoute(builder: (context) => const Home())),
        child: Scaffold(
          body: ListView(
            children: [
              Navbar(text: 'Pedido #PV${widget.numero}', children: [
                const NavbarButton(
                    destination: Home(), icons: Icons.arrow_back_ios_new),
                Container(
                  padding: EdgeInsets.only(right: Responsive.h(context, 5)),
                  child: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        buildMenuItems(options),
                    onSelected: (value) async {
                      switch (value) {
                        case 'pdf':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PdfGeneratorViewer(
                                  prevendaId: widget.prevendaId,
                                  numero: widget.numero,
                                  urlBasic: urlBasic,
                                  token: token,
                                  vendedor: vendedorNome,
                                  valordesconto: widget.valordesconto,
                                  empresa: widget.empresa,
                                  products: orders,
                                  valortotal: (widget.valortotal ?? 0.0) -
                                      (widget.valordesconto ?? 0.0)),
                            ),
                          );
                          break;
                        case 'local':
                          await DataServiceRePrintOrder.fetchDataRePrintOrder(
                              context,
                              urlBasic,
                              token,
                              widget.prevendaId ?? '',
                              widget.numero ?? '');
                          break;
                        case 'rede':
                          await DataServiceRePrintOrderNetwork
                              .fetchDataRePrintOrderNetwork(
                                  context,
                                  urlBasic,
                                  token,
                                  widget.prevendaId ?? '',
                                  widget.numero ?? '');
                          break;
                      }
                    },
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: ColorsApp.tertiaryColor,
                      size: Responsive.h(context, 20),
                    ),
                  ),
                )
              ]),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              Container(
                  padding: EdgeInsets.only(left: Responsive.h(context, 12)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Data do pedido - ${DateFormat('dd/MM/yyyy HH:mm:ss').format(widget.datahora)}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Responsive.h(context, 12),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Responsive.h(context, 5),
                      ),
                      Row(
                        children: [
                          Text(
                            vendedorNome != ''
                                ? 'Vendedor: $vendedorCodigo - $vendedorNome'
                                : 'Sem vendedor vinculado',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Responsive.h(context, 12),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              const TextTitle(text: 'Produto(s)'),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.only(
                                    left: Responsive.w(context, 10),
                                    top: Responsive.h(context, 5),
                                    right: Responsive.w(context, 10),
                                    bottom: Responsive.h(context, 5),
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    border: BorderDirectional(
                                      bottom: BorderSide(
                                          width: Responsive.h(context, 0.5),
                                          color: ColorsApp.quarantineColor),
                                      top: BorderSide(
                                          width: Responsive.h(context, 0.5),
                                          color: ColorsApp.quarantineColor),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    if (orders[index].imagem ==
                                                        '')
                                                      Icon(
                                                        Symbols
                                                            .hide_image_rounded,
                                                        size: Responsive.h(
                                                            context, 50),
                                                      )
                                                    else
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            10,
                                                          ),
                                                          child:
                                                              TelaExibicaoImagem(
                                                            url: urlBasic,
                                                            imagem:
                                                                orders[index]
                                                                    .imagem,
                                                          )),
                                                    SizedBox(
                                                      width: Responsive.w(
                                                          context, 5),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width:
                                                                  Responsive.w(
                                                                      context,
                                                                      150),
                                                              child: Text(
                                                                orders[index]
                                                                        .nomeproduto
                                                                        .isEmpty
                                                                    ? ''
                                                                    : orders[
                                                                            index]
                                                                        .nomeproduto,
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    fontSize:
                                                                        Responsive.h(
                                                                            context,
                                                                            12),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              orders[index]
                                                                      .codigoproduto
                                                                      .isEmpty
                                                                  ? ''
                                                                  : orders[
                                                                          index]
                                                                      .codigoproduto,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    Responsive.h(
                                                                        context,
                                                                        10),
                                                                color: ColorsApp
                                                                    .quarantineColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                child: Row(
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${currencyFormat.format(orders[index].valorunitario)} x ${orders[index].quantidade}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Responsive.h(
                                                                          context,
                                                                          12),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Subtotal - ${currencyFormat.format(orders[index].valortotalitem)}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Responsive.h(
                                                                          context,
                                                                          10),
                                                                  color: ColorsApp
                                                                      .warningColor),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (orders[index]
                                          .nomeexpedicao
                                          .isNotEmpty)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              orders[index].nomeexpedicao,
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.h(context, 10),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            )
                                          ],
                                        )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              Center(
                child: Text(
                  'Total dos produtos - ${currencyFormat.format(widget.valortotal)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: Responsive.h(context, 15),
                      fontWeight: FontWeight.bold),
                ),
              ),
              if (widget.valordesconto != 0.0)
                Center(
                  child: Text(
                    'Desconto - ${currencyFormat.format(widget.valordesconto)}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Responsive.h(context, 15),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              Center(
                child: Text(
                  'Valor Total - ${currencyFormat.format((widget.valortotal ?? 0.0) - (widget.valordesconto ?? 0.0))}',
                  style: TextStyle(
                      color: ColorsApp.warningColor,
                      fontSize: Responsive.h(context, 15),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              const TextTitle(text: 'Dados do Cliente'),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: Responsive.h(context, 15),
                    right: Responsive.h(context, 15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NameInputblocked(text: 'Nome'),
                    InputBlocked(
                        value: nome.isEmpty ? widget.pessoanome ?? '' : nome),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Responsive.w(context, 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'CPF/CNPJ'),
                              InputBlocked(
                                  value: widget.cpfcnpj == 'null'
                                      ? ''
                                      : _cpfMaskFormatter
                                          .maskText(widget.cpfcnpj ?? '')),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Responsive.w(context, 150),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Telefone'),
                              InputBlocked(
                                  value: telefone == 'null'
                                      ? ''
                                      : _telMaskFormatter.maskText(telefone))
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    const NameInputblocked(text: 'Endereço'),
                    InputBlocked(value: email),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    const NameInputblocked(text: 'CEP'),
                    InputBlocked(value: cepFormatter.maskText(enderecocep)),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Responsive.w(context, 215),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Endereço'),
                              InputBlocked(value: endereco),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Responsive.w(context, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'UF'),
                              InputBlocked(value: uf)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Responsive.w(context, 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Bairro'),
                              InputBlocked(value: enderecobairro)
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Responsive.w(context, 180),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Cidade'),
                              InputBlocked(value: _localidadecontroller.text)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.h(context, 5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Responsive.w(context, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Número'),
                              InputBlocked(value: endereconumero.toString())
                            ],
                          ),
                        ),
                        SizedBox(
                          width: Responsive.w(context, 215),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const NameInputblocked(text: 'Complemento'),
                              InputBlocked(value: enderecocomplemento)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Responsive.h(context, 10),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
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
    await checkConnection();
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
    ]);
    await Future.wait([
      fetchDataCliente2(),
    ]);
    await fetchDataSeller();
    await GetCep.getcep(
        enderecocep,
        _logradourocontroller,
        //_complementocontroller2,
        _bairrocontroller,
        _ufcontroller,
        _localidadecontroller,
        _ibgecontroller,
        ibge);
    await Future.wait([
      fetchDataOrders(),
      // fetchDataOrdersDetails2(widget.prevendaId),
      // initializer(),
    ]);
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataCliente2() async {
    final data = await DataServiceCliente2.fetchDataCliente2(
        urlBasic, widget.cpfcnpj ?? '', token);
    setState(() {
      pessoaid = data['pessoa_id'].toString();
      nome = data['nome'].toString();
      cpf = data['cpf'].toString();
      telefone = data['telefone'].toString();
      endereco = data['endereco'].toString();
      enderecobairro = data['enderecobairro'].toString();
      endereconumero = data['endereconumero'].toString();
      enderecocomplemento = data['enderecocomplemento'].toString();
      enderecocep = data['enderecocep'].toString();
      enderecocidade = data['enderecocidade'].toString();
      uf = data['uf'].toString();
      codigo = data['codigo'].toString();
      email = data['emailcontato'].toString();
    });
  }

  Future<void> fetchDataOrders() async {
    final hasInternet = await hasInternetConnection();
    final listOrdersOff =
        await recuperarListaProdutosPedido(widget.localId ?? '');
    if (!hasInternet) {
      setState(() {
        orders = listOrdersOff
            .where((e) => e.localId.toString() == widget.localId.toString())
            .toList();
        isLoading = false;
      });
    } else {
      List<OrdersDetailsEndpoint>? fetchData =
          await DataServiceOrdersDetails.fetchDataOrdersDetails(context,
              urlBasic, widget.prevendaId ?? '', widget.empresaId ?? '', token);
      if (fetchData != null) {
        final onlineMap = fetchData.map((e) {
          final json = e.toJson();
          json['flag_sync'] != 0;
          return json;
        }).toList();

        final offlineMap = listOrdersOff
            .where((e) => e.flagSync == 0)
            .map((e) => e.toJson())
            .toList();

        var mergedList = mergeListsByKey(
          onlineMap,
          offlineMap,
          [],
          'local_id', // ou 'pedido_id'
        );

        await salvarListaProdutosPedido(mergedList);

        setState(() {
          orders =
              mergedList.map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();
        });
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDataSeller() async {
    try {
      var urlGet = Uri.parse(
          '''$urlBasic/ideia/core/getdata/prevenda%20p%20LEFT%20JOIN%20pessoa%20pp%20ON%20pp.pessoa_id%20=%20p.vendedor_pessoa_id%20WHERE%20p.prevenda_id%20=%20'${widget.prevendaId}'/''');
      var response = await http.get(
        urlGet,
        headers: {'Accept': 'text/html'},
      );
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        var data = dataList;
        //var vendedor_pessoa_id = data[0]['vendedor_pessoa_id'];
        var codigo = data[0]['codigo'];
        var nome = data[0]['nome'];
        // Tenta imprimir o pessoa_id de forma segura
        try {
          if (data is List && data.isNotEmpty) {
            setState(() {
              vendedorCodigo = '$codigo';
              vendedorNome = '$nome';
            });
          } else {
            log('Estrutura inesperada em data.');
          }
        } catch (e) {
          log('Erro ao acessar pessoa_id: $e');
        }
      } else {
        log('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro ao pesquisar vendedor: $e');
    }
  }

  List<PopupMenuItem<String>> buildMenuItems(List<dynamic> options) {
    List<PopupMenuItem<String>> optionItems = [
      PopupMenuItem(
        value: 'pdf',
        child: Text(
          'Gerar PDF',
          style: TextStyle(
              fontSize: Responsive.h(context, 12),
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      PopupMenuItem(
        value: 'local',
        child: Text(
          'Reimprimir cupom',
          style: TextStyle(
              fontSize: Responsive.h(context, 12),
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
      PopupMenuItem(
        value: 'rede',
        enabled: printBool,
        child: Text(
          'Reimprimir via rede',
          style: TextStyle(
              fontSize: Responsive.h(context, 12),
              color: printBool
                  ? Theme.of(context).colorScheme.primary
                  : const Color.fromARGB(255, 85, 117, 138)),
          //style: TextStyle(fontSize: Responsive.h(context, 10)),
        ),
      ),
    ];

    const PopupMenuDivider();

    return optionItems;
  }
}
