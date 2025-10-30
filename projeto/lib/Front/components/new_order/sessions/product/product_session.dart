import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/rm_product.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/pages/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final valordesconto;

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
      this.valordesconto});

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

  String urlBasic = '';
  String token = '';

  double totalValue = 0.0;

  TextEditingController valordescontoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    totalValue = widget.valortotal; // Inicializa com o valor total original
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
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
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
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
                                                                      if (widget
                                                                              .onProductRemoved !=
                                                                          null) {
                                                                        widget
                                                                            .onProductRemoved!();
                                                                      } // Força uma atualização da UI quando a lista estiver vazia
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: Style
                                                                        .ButtonExitWidth(
                                                                            context),
                                                                    // height: Style.ButtonExitHeight(context),
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
            onPressed: () {
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
                      valordesconto: widget.valordesconto)));
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
    List<OrdersDetailsEndpoint>? fetchData =
        await DataServiceOrdersDetails.fetchDataOrdersDetails(
            urlBasic, widget.prevendaid, token);
    if (fetchData != null) {
      setState(() {
        orders = fetchData;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
