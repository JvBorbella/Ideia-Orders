import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/rm_product.dart';
import 'package:projeto/back/saveList.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/pages/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class ProductSession extends StatefulWidget {
  final prevendaid;
  final pessoaid;
  final numpedido;
  final pessoanome;
  final cpfcnpj;
  final telefone;
  final cep;
  final bairro;
  final cidade;
  final endereco;
  final complemento;

  final produtoid;
  final prevendaprodutoid;
  final nomeproduto;
  final codigoproduto;
  final valorunitario;
  final valortotalitem;
  final valortotal;
  final quantidade;
  final imagemurl;
  final empresa_id;
  final tabelapreco_id;
  final valordesconto;
  final local_id;

  final VoidCallback? onProductRemoved;

  const ProductSession(
      {Key? key,
      this.prevendaid,
      this.pessoaid,
      this.numpedido,
      this.pessoanome,
      this.cpfcnpj,
      this.telefone,
      this.cep,
      this.bairro,
      this.cidade,
      this.endereco,
      this.complemento,
      this.produtoid,
      this.prevendaprodutoid,
      this.nomeproduto,
      this.codigoproduto,
      this.valorunitario,
      this.valortotalitem,
      this.valortotal,
      this.quantidade,
      this.imagemurl,
      this.onProductRemoved,
      this.empresa_id,
      this.tabelapreco_id,
      this.valordesconto,
      this.local_id});

  @override
  State<ProductSession> createState() => _ProductSessionState();
}

class _ProductSessionState extends State<ProductSession> {
  final GlobalKey<CustomerSessionState> customerKey =
      GlobalKey<CustomerSessionState>();
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  List<OrdersDetailsEndpoint> orders = [];
  bool isLoading = true;

  String urlBasic = '',
      token = '',
      expedicaoId = '',
      expedicaoNome = '',
      expedicaoCodigo = '';

  double totalValue = 0.0;

  List expedition = [];

  TextEditingController valordescontoController = TextEditingController(),
      eanController = TextEditingController(),
      codigoController = TextEditingController(),
      nomeController = TextEditingController(),
      quantidadeController = TextEditingController(),
      nomeExpedicaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    print(widget.local_id);
    totalValue = widget.valortotal; // Inicializa com o valor total original
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
  }

  // final hasInternet = await hasInternetConnection();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
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
                            left: Style.height_2(context),
                            top: Style.height_5(context),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                                "assets/images/image_product/Barcode.png")
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width:
                                                      Style.width_150(context),
                                                  child: Text(
                                                    orders[index]
                                                            .nomeproduto
                                                            .isEmpty
                                                        ? ''
                                                        : orders[index]
                                                            .nomeproduto,
                                                    overflow: TextOverflow.clip,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        color:
                                                            Style.primaryColor,
                                                        fontSize:
                                                            Style.height_12(
                                                                context),
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                    fontSize: Style.height_10(
                                                        context),
                                                    color:
                                                        Style.quarantineColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (orders[index]
                                                .nomeexpedicao
                                                .isNotEmpty)
                                              Row(
                                                children: [
                                                  Text(
                                                    orders[index].nomeexpedicao,
                                                    style: TextStyle(
                                                      fontSize: Style.height_10(
                                                          context),
                                                      color:
                                                          Style.quarantineColor,
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
                              if (orders[index].flagSync == 0)
                                Icon(
                                  Icons.cloud_off,
                                  color: Colors.orange,
                                  size: Style.height_15(context),
                                ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                                                          .format(orders[index]
                                                              .valorunitario)
                                                          .toString() +
                                                      ' x ' +
                                                      orders[index]
                                                          .quantidade
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: Style.height_12(
                                                          context),
                                                      color:
                                                          Style.primaryColor),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Subtotal - ' +
                                                      currencyFormat
                                                          .format(orders[index]
                                                              .valortotalitem)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: Style.height_10(
                                                          context),
                                                      color:
                                                          Style.warningColor),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Container(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'Deseja remover este item?',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          Style.height_15(
                                                                              context),
                                                                      color: Style
                                                                          .primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .clip,
                                                                  softWrap:
                                                                      true,
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: Style
                                                                  .height_30(
                                                                      context),
                                                            ),
                                                            Row(
                                                              //Espaçamento entre os Buttons
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                //Buttom de sair
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final checkInternet =
                                                                        await hasInternetConnection();
                                                                    if (!checkInternet) {
                                                                      await removerItemProduto(
                                                                          orders[index]
                                                                              .prevendaprodutoid,
                                                                          widget
                                                                              .local_id);
                                                                      _closeModal();
                                                                      fetchDataOrders();
                                                                    } else {
                                                                      await DataServiceRmProduct.sendDataOrder(
                                                                          context,
                                                                          urlBasic,
                                                                          token,
                                                                          widget
                                                                              .prevendaid,
                                                                          orders[index]
                                                                              .prevendaprodutoid);
                                                                      _closeModal();

                                                                      setState(
                                                                          () {
                                                                        orders.removeAt(
                                                                            index);
                                                                        totalValue =
                                                                            _calculateTotal();
                                                                      });

                                                                      if (orders
                                                                          .isEmpty) {
                                                                        setState(
                                                                            () {});
                                                                        if (widget.onProductRemoved !=
                                                                            null) {
                                                                          widget
                                                                              .onProductRemoved!();
                                                                        } // Força uma atualização da UI quando a lista estiver vazia
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: Style
                                                                        .ButtonExitWidth(
                                                                            context),
                                                                    padding: EdgeInsets.all(
                                                                        Style.ButtonExitPadding(
                                                                            context)),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(Style.ButtonExitBorderRadius(
                                                                                context)),
                                                                        color: Style
                                                                            .errorColor),
                                                                    child: Text(
                                                                      'Remover',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Style
                                                                            .tertiaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            Style.height_10(context),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                                //Buttom para fechar o modal
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    _closeModal();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    // width: Style.ButtonCancelWidth(context),
                                                                    // height: Style.ButtonCancelHeight(context),
                                                                    padding: EdgeInsets.all(
                                                                        Style.ButtonCancelPadding(
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Style.ButtonExitBorderRadius(context)),
                                                                      border: Border.all(
                                                                          width: Style.WidthBorderImageContainer(
                                                                              context),
                                                                          color:
                                                                              Style.secondaryColor),
                                                                      color: Style
                                                                          .tertiaryColor,
                                                                    ),
                                                                    child: Text(
                                                                      'Cancelar',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Style
                                                                            .secondaryColor,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            Style.height_10(context),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Style.errorColor,
                                                size: Style.height_20(context),
                                              ),
                                            ),
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
            'Total - ' + currencyFormat.format(totalValue).toString(),
            style: TextStyle(
                color: Style.primaryColor,
                fontSize: Style.height_15(context),
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: Style.height_10(context),
        ),
        RegisterIconButton(
            text: 'Adicionar Produto',
            color: Style.primaryColor,
            width: Style.height_150(context),
            icon: Icons.add_circle,
            onPressed: () async {
              final checkInternet = await hasInternetConnection();
              if (!checkInternet) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, setModalState) => AlertDialog(
                              backgroundColor: Style.defaultColor,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Input(
                                      text: 'Informe o EAN do produto',
                                      controller: eanController,
                                      type: TextInputType.text,
                                      textAlign: TextAlign.left),
                                  SizedBox(
                                    height: Style.height_10(context),
                                  ),
                                  Input(
                                      text: 'Informe o Código do produto',
                                      controller: codigoController,
                                      type: TextInputType.text,
                                      textAlign: TextAlign.left),
                                  SizedBox(
                                    height: Style.height_10(context),
                                  ),
                                  Input(
                                      text: 'Informe o Nome do produto',
                                      controller: nomeController,
                                      type: TextInputType.text,
                                      textAlign: TextAlign.left),
                                  SizedBox(
                                    height: Style.height_10(context),
                                  ),
                                  Input(
                                      text: 'Informe a Quantidade',
                                      controller: quantidadeController,
                                      type: TextInputType.number,
                                      textAlign: TextAlign.left),
                                  SizedBox(
                                    height: Style.height_10(context),
                                  ),
                                  Container(
                                    height: Style.height_30(context),
                                    child: PopupMenuButton<String>(
                                      itemBuilder: (BuildContext context) =>
                                          buildMenuItemsexpedition(expedition),
                                      onSelected: (value) async {
                                        if (value != '') {
                                          setModalState(() {
                                            expedicaoId = value;
                                            // Busca o nome da empresa correspondente ao ID selecionado
                                            final selectedexpedition =
                                                expedition.firstWhere(
                                              (expedition) =>
                                                  expedition['expedicao_id'] ==
                                                  value,
                                            );
                                            expedicaoNome =
                                                selectedexpedition['nome'] ??
                                                    ''; // Atualiza o nome
                                            expedicaoCodigo =
                                                selectedexpedition['codigo'] ??
                                                    ''; // Atualiza o nome
                                          });
                                          setState(() {
                                            expedicaoId = value;
                                          });
                                          print(expedicaoId);
                                        } else {
                                          setState(() {
                                            expedicaoId = '';
                                            expedicaoNome = '';
                                            expedicaoCodigo = '';
                                          });
                                        }
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Style.secondaryColor,
                                              size: Style.height_20(context),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Style
                                                        .secondaryColor, // Color of the bottom border
                                                    width: Style.height_2(
                                                        context), // Thickness of the bottom border
                                                    style: BorderStyle
                                                        .solid, // Style of the border (solid, dashed, etc.)
                                                  ),
                                                ),
                                              ),
                                              width: Style.width_150(context),
                                              child: Text(
                                                expedicaoNome.isEmpty
                                                    ? 'Selecione a expedição'
                                                    : '${expedicaoCodigo} - ${expedicaoNome}',
                                                style: TextStyle(
                                                  color: Style.secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      Style.height_12(context),
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow
                                                    .ellipsis, // corta o texto no limite da largura
                                                softWrap:
                                                    true, // permite a quebra de linha conforme necessário
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      final uuid = const Uuid().v4();
                                      final bodyMap = {
                                        'local_id': widget.local_id,
                                        'flag_sync': 0,
                                        'produto_id': '',
                                        'prevendaproduto_id': uuid,
                                        'codigoproduto': codigoController.text,
                                        'nomeproduto': nomeController.text,
                                        'nome': expedicaoNome,
                                        'expedicao_id': expedicaoId,
                                        'valorunitario': 0.0,
                                        'quantidade': double.parse(quantidadeController.text),
                                        'valortotal': 0.0,
                                        'ean': eanController.text,
                                      };
                                      await adicionarItemProduto(bodyMap);
                                      _closeModal();
                                      fetchDataOrders();
                                    },
                                    child: Text('Adicionar'))
                              ],
                            ));
                  },
                );
              } else {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ProductList(
                        prevendaid: widget.prevendaid.toString(),
                        pessoaid: widget.pessoaid.toString(),
                        numpedido: widget.numpedido.toString(),
                        pessoanome: widget.pessoanome.toString(),
                        cpfcnpj: widget.cpfcnpj.toString(),
                        telefone: widget.telefone.toString(),
                        cep: widget.cep.toString(),
                        bairro: widget.bairro.toString(),
                        endereco: widget.endereco.toString(),
                        complemento: widget.complemento.toString(),
                        empresa_id: widget.empresa_id.toString(),
                        tabelapreco_id: widget.tabelapreco_id.toString(),
                        valordesconto: widget.valordesconto)));
              }
            }),
      ],
    ));
  }

  double _calculateTotal() {
    double total = 0.0;
    for (var order in orders) {
      total += order.valortotalitem;
    }
    return total;
  }

  Future<void> loadData() async {
    await Future.wait([_loadSavedUrlBasic(), _loadSavedToken()]);
    await Future.wait([
      fetchDataOrders(),
    ]);
    await fetchDataListExpedicao();
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

  Future<void> fetchDataOrders() async {
    setState(() => isLoading = true);

    final hasInternet = await hasInternetConnection();
    final allOffline = await recuperarListaProdutosPedido(); // 🔴 todos

    try {
      if (!hasInternet) {
        final filtered = allOffline
            .where((e) => e.local_id.toString() == widget.local_id.toString())
            .toList();

        setState(() => orders = filtered);
        //await adicionarItemProduto(filtered);
        return;
      }

      final fetchData = await DataServiceOrdersDetails.fetchDataOrdersDetails(
          urlBasic, widget.prevendaid, token);

      if (fetchData != null) {
        final onlineMap = fetchData.map((e) {
          final json = e.toJson();
          json['local_id'] = widget.local_id;
          json['flag_sync'] = 1;
          return json;
        }).toList();

        // 🔵 separa apenas o pedido atual
        final currentOrderOffline = allOffline
            .where((e) => e.local_id.toString() == widget.local_id.toString())
            .map((e) => e.toJson())
            .toList();

        final mergedCurrent = mergeListsByKey(
          onlineMap,
          currentOrderOffline,
          'local_id',
        );

        // 🔵 remove o pedido atual da lista completa
        final otherOrders = allOffline
            .where((e) => e.local_id.toString() != widget.local_id.toString())
            .map((e) => e.toJson())
            .toList();

        // 🔵 junta tudo novamente
        final finalList = [...otherOrders, ...mergedCurrent];

        //await salvarListaProdutosPedido(finalList);

        setState(() {
          orders = mergedCurrent
              .map((e) => OrdersDetailsEndpoint.fromJson(e))
              .toList();
        });
      } else {
        final filtered = allOffline
            .where((e) => e.local_id.toString() == widget.local_id.toString())
            .toList();

        setState(() => orders = filtered);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Future<void> fetchDataOrders() async {
  //   final hasInternet = await hasInternetConnection();
  //   final listOrdersOff = await recuperarListaProdutosPedido();
  //   if (!hasInternet) {
  //     print(listOrdersOff);
  //     setState(() {
  //       orders = listOrdersOff
  //           .where((e) => e.local_id.toString() == widget.local_id.toString())
  //           .toList();
  //       isLoading = false;
  //     });
  //   } else {
  //     List<OrdersDetailsEndpoint>? fetchData =
  //         await DataServiceOrdersDetails.fetchDataOrdersDetails(
  //             urlBasic, widget.prevendaid, token);
  //     if (fetchData != null) {
  //       final onlineMap = fetchData.map((e) {
  //         final json = e.toJson();
  //         json['local_id'] = widget.local_id;
  //         json['flag_sync'] = 1;
  //         return json;
  //       }).toList();

  //       final offlineMap = listOrdersOff
  //           .where((e) => e.local_id.toString() == widget.local_id.toString())
  //           .map((e) => e.toJson())
  //           .toList();

  //       final mergedList = mergeListsByKey(
  //         onlineMap,
  //         offlineMap,
  //         'local_id',
  //       );

  //       await salvarListaProdutosPedido(mergedList);

  //       print(mergedList);

  //       setState(() {
  //         orders =
  //             mergedList.map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();
  //       });
  //     } else {
  //       final listOrdersOff = await recuperarListaProdutosPedido();

  //       setState(() {
  //         orders = listOrdersOff;
  //       });
  //     }
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  Future<void> fetchDataListExpedicao() async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final listTablePricesOff = await recuperarListaExpedicao();
      setState(() {
        expedition = listTablePricesOff;
      });
    } else {
      try {
        var urlGet = Uri.parse(
            '$urlBasic/ideia/core/getdata/expedicao%20e%20WHERE%20COALESCE(e.flagexcluido,%200)%20<>%201/');
        var response = await http.get(urlGet, headers: {'Accept': 'text/html'});
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          var dynamicKey = jsonData['data'].keys.first;
          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          var data = dataList;
          var expedicaoId = data[0]['expedicao_id'];
          var expedicaoNome = data[0]['nome'];
          var expedicaoCodigo = data[0]['codigo'];

          var bodyMap = {
            'expedicao_id': expedicaoId,
            'expedicao_nome': expedicaoNome,
            'expedicao_codigo': expedicaoCodigo,
          };

          await salvarListaExpedicao(data);

          setState(() {
            expedition = dataList;
          });
        }
      } catch (e) {
        print('Erro durante a requisição: $e');
      }
    }
  }

  List<PopupMenuItem<String>> buildMenuItemsexpedition(List expedition) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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

    List<PopupMenuItem<String>> dynamicItems = expedition.map((expeditions) {
      return PopupMenuItem<String>(
        value: expeditions['expedicao_id'].toString(),
        child: Text(
            ('${expeditions['codigo']} - ${expeditions['nome']}').toString()),
        key: Key(expeditions['nome'].toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return staticItems + dynamicItems;
  }
}
