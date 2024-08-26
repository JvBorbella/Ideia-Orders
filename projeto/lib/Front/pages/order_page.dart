import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/order_details.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/reprint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/order_page/elements/name_inputblocked.dart';
import 'package:projeto/front/components/order_page/elements/products_order.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/order_page/elements/cancel_button.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  final prevendaId;
  final numero;
  final pessoanome;
  final cpfcnpj;
  final telefone;
  final endereco;
  final bairro;
  final cidade;
  final cep;
  final complemento;
  final uf;
  final operador;

  final datahora;
  final valortotal;
  final codigoproduto;

  const OrderPage({
    Key? key,
    this.prevendaId,
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
    this.datahora,
    this.valortotal,
    this.codigoproduto,
    this.operador,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String urlBasic = '';
  String token = '';

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

  late String nomeproduto = '';
  late String codigoproduto = '';
  late String imagemurl = '';
  late String prevendaprodutoid = '';
  late String produtoid = '';
  late double valorunitario = 0.0;
  late double valortotalitem = 0.0;
  late double valortotal = 0.0;
  late double quantidade = 0.0;

  List<OrdersDetailsEndpoint> orders = [];

   NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

      final cepFormatter = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    loadData();
    _refreshData();
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
              body: ListView(
                children: [
                  Navbar(text: 'Pedido', children: [
                    NavbarButton(
                        destination: Home(), Icons: Icons.arrow_back_ios_new)
                  ]),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  Container(
                    height: Style.height_35(context),
                    margin: EdgeInsets.only(
                      left: Style.height_8(context),
                      right: Style.height_8(context),
                    ),
                    padding: EdgeInsets.all(Style.height_8(context)),
                    decoration: BoxDecoration(
                      color: Style.primaryColor,
                      borderRadius:
                          BorderRadius.circular(Style.height_15(context)),
                    ),
                    child: Text(
                      'Nº do pedido - PV${widget.numero}',
                      style: TextStyle(
                          fontSize: Style.height_15(context),
                          color: Style.tertiaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: Style.height_5(context),
                  ),
                  Container(
                      padding: EdgeInsets.only(left: Style.height_12(context)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Data do pedido - ' +
                                    DateFormat('dd/MM/yyyy hh:mm:ss')
                                        .format(widget.datahora),
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: Style.height_12(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Style.height_5(context),
                          ),
                          Row(
                            children: [
                              Text(
                                'Vendedor - ${widget.operador}',
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: Style.height_12(context),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  TextTitle(text: 'Produto(s)'),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: Style.width_10(context),
                                      top: Style.height_5(context),
                                      right: Style.width_10(context),
                                      bottom: Style.height_5(context),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Style.defaultColor,
                                      border: BorderDirectional(
                                        bottom: BorderSide(
                                            width: Style.height_05(context),
                                            color: Style.quarantineColor),
                                        top: BorderSide(
                                            width: Style.height_05(context),
                                            color: Style.quarantineColor),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Image.network(
                                                          'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/06/Barcode.png')
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width:
                                                                Style.width_150(
                                                                    context),
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
                                                                  color: Style
                                                                      .primaryColor,
                                                                  fontSize: Style
                                                                      .height_12(
                                                                          context),
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
                                                                : orders[index]
                                                                    .codigoproduto,
                                                            style: TextStyle(
                                                              fontSize: Style
                                                                  .height_10(
                                                                      context),
                                                              color: Style
                                                                  .quarantineColor,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            currencyFormat
                                                                    .format(orders[
                                                                            index]
                                                                        .valorunitario)
                                                                    .toString() +
                                                                ' x ' +
                                                                orders[index]
                                                                    .quantidade
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: Style
                                                                    .height_12(
                                                                        context),
                                                                color: Style
                                                                    .primaryColor),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Subtotal - ' +
                                                                currencyFormat
                                                                    .format(orders[
                                                                            index]
                                                                        .valortotalitem)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: Style
                                                                    .height_10(
                                                                        context),
                                                                color: Style
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  Center(
                    child: Text(
                      'Total - ' + currencyFormat.format(widget.valortotal),
                      style: TextStyle(
                          color: Style.primaryColor,
                          fontSize: Style.height_15(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextTitle(text: 'Dados do Cliente'),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: Style.height_15(context),
                        right: Style.height_15(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NameInputblocked(text: 'Nome'),
                        InputBlocked(
                            value: nome.isEmpty ? '' : nome),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Style.width_150(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'CPF/CNPJ'),
                                  InputBlocked(
                                    value: widget.cpfcnpj == 'null'
                                        ? ''
                                        : widget.cpfcnpj,
                                    inputFormatters: [
                                      MaskedInputFormatter(
                                          '000.000.000-00'), // Máscara de CPF
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: Style.width_150(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'Telefone'),
                                  InputBlocked(
                                    value: telefone == 'null'
                                        ? ''
                                        : telefone,
                                    inputFormatters: [
                                      MaskedInputFormatter(
                                          '(00) 00000-0000'), // Máscara de CPF
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        NameInputblocked(text: 'Endereço'),
                        InputBlocked(
                            value:
                                endereco == null ? '' : endereco),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Style.width_225(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'Complemento'),
                                  InputBlocked(
                                      value: enderecocomplemento == null
                                          ? ''
                                          : enderecocomplemento)
                                ],
                              ),
                            ),
                            Container(
                              width: Style.width_80(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'UF'),
                                  InputBlocked(
                                      value: uf == null ? '' : uf)
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: Style.width_150(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'Bairro'),
                                  InputBlocked(
                                      value: enderecobairro == null
                                          ? ''
                                          : enderecobairro)
                                ],
                              ),
                            ),
                            Container(
                              width: Style.width_150(context),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NameInputblocked(text: 'CEP'),
                                  InputBlocked(
                                      value: cepFormatter.maskText(
                                          enderecocep == null
                                              ? ''
                                              : enderecocep))
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Style.height_20(context),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              RegisterIconButton(
                            text: 'Reimprimir cupom',
                            color: Style.warningColor,
                            width: Style.width_150(context),
                            icon: Icons.print,
                            onPressed: () async {
                              await DataServiceRePrintOrder
                                  .fetchDataRePrintOrder(context, urlBasic,
                                      token, widget.prevendaId, widget.numero);
                            },
                          ),
                          RegisterIconButton(
                            text: 'Reimprimir cupom na rede',
                            color: Style.warningColor,
                            width: Style.width_150(context),
                            icon: Icons.network_check_outlined,
                            onPressed: () async {
                              await DataServiceRePrintOrderNetwork
                                  .fetchDataRePrintOrderNetwork
                                  (context, urlBasic,
                                      token, widget.prevendaId, widget.numero);
                            },
                          ),
                            ],
                          ), 
                        ),
                        SizedBox(
                          height: Style.height_10(context),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            onWillPop: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()));
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

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
    });
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken()
    ]);
    await Future.wait([
      fetchDataCliente2(),
    ]);
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
    final data =
        await DataServiceCliente2.fetchDataCliente2(urlBasic, widget.cpfcnpj, token);
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
    });
  }

  // Future<void> fetchDataOrdersDetails2(String prevendaId) async {
  //   final data = await DataServiceOrdersDetails2.fetchDataOrdersDetails2(
  //       urlBasic, prevendaId);
  //   setState(() {
  //     pessoanome = data['pessoa_nome'].toString();
  //     cpfcliente = data['cpfcnpj'].toString();
  //     telefone = data['telefone'].toString();
  //     codigoproduto = data['codigo'].toString();
  //     nomeproduto = data['nome'].toString();
  //     imagemurl = data['imagem_url'].toString();
  //     prevendaprodutoid = data['prevendaproduto_id'].toString();
  //     produtoid = data['produto_id'].toString();
  //     valorunitario = double.parse(data['valorunitario'] ?? '0.0');
  //     valortotalitem = double.parse(data['valortotalitem'] ?? '0.0');
  //     valortotal = double.parse(data['valortotal'] ?? '0.0');
  //     quantidade = double.parse(data['quantidade'] ?? '0.0');
  //   });
  // }

  Future<void> fetchDataOrders() async {
    List<OrdersDetailsEndpoint>? fetchData =
        await DataServiceOrdersDetails.fetchDataOrdersDetails(
            urlBasic, widget.prevendaId, token);
    if (fetchData != null) {
      setState(() {
        orders = fetchData;
        print(fetchData);
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
