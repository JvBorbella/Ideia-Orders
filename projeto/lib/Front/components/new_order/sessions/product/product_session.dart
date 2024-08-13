import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/rm_product.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/pages/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductSession extends StatefulWidget {
  final prevendaid;
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

  const ProductSession({
    Key? key,
    this.prevendaid,
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
  });

  @override
  State<ProductSession> createState() => _ProductSessionState();
}

class _ProductSessionState extends State<ProductSession> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  List<OrdersDetailsEndpoint> orders = [];
  bool isLoading = true;

  String urlBasic = '';
  String token = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
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
                    // width: Style.height_100(context),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: Style.height_2(context),
                            top: Style.height_5(context),
                            bottom: Style.height_5(context),
                            // right: Style.height_15(context)
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
                                            Image.network(
                                                'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/06/Barcode.png')
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
                                                await DataServiceRmProduct
                                                    .sendDataOrder(
                                                        context,
                                                        urlBasic,
                                                        token,
                                                        widget.prevendaid,
                                                        orders[index]
                                                            .prevendaprodutoid);

                                                setState(() {
                                                  fetchDataOrders();
                                                });
                                                setState(() {
                                                  orders.removeAt(
                                                      index); // Remove o item localmente
                                                });
                                                if (orders.isEmpty) {
                                                  setState(
                                                      () {}); // Força uma atualização da UI quando a lista estiver vazia
                                                }
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
            'Total - ' + currencyFormat.format(widget.valortotal).toString(),
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductList(
                        prevendaid: widget.prevendaid.toString(),
                        pessoanome: widget.pessoanome.toString(),
                        cpfcnpj: widget.cpfcnpj.toString(),
                        telefone: widget.telefone.toString(),
                        cep: widget.cep.toString(),
                        bairro: widget.bairro.toString(),
                        endereco: widget.endereco.toString(),
                        complemento: widget.complemento.toString(),
                      )));
            }),
      ],
    ));
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
