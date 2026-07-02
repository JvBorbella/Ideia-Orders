import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsOrder extends StatefulWidget {
  final String urlBasic;
  final String prevendaId;
  final String produtoId;
  final String codigoproduto;
  final String nomeproduto;
  final double valorunitario;
  final int quantidade;

  const ProductsOrder({
    super.key,
    this.urlBasic = '',
    this.prevendaId = '',
    this.produtoId = '',
    required this.codigoproduto,
    this.nomeproduto = '',
    this.valorunitario = 0.0,
    this.quantidade = 0,
  });

  @override
  State<ProductsOrder> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductsOrder> {
  String urlBasic = '';
  String nome = '';
  List<ProductsEndpoint> products = [];
  bool isLoading = true;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          padding: EdgeInsets.only(
              left: Responsive.h(context, 15),
              right: Responsive.h(context, 15)),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: BorderDirectional(
              bottom: BorderSide(
                  width: Responsive.h(context, 0.5),
                  color: ColorsApp.quarantineColor),
              top: BorderSide(
                  width: Responsive.h(context, 0.5),
                  color: ColorsApp.quarantineColor),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Responsive.h(context, 5)),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Image.asset(
                                "assets/images/image_products/Barcode.png")
                          ],
                        ),
                        SizedBox(
                          width: Responsive.h(context, 5),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: Responsive.w(context, 150),
                                  child: Text(
                                    nome,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: Responsive.h(context, 12),
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.codigoproduto.toString(),
                                  style: TextStyle(
                                    fontSize: Responsive.h(context, 10),
                                    color: ColorsApp.quarantineColor,
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
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${currencyFormat.format(widget.valorunitario)} x ${widget.quantidade}',
                                style: TextStyle(
                                    fontSize: Responsive.h(context, 12),
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Subtotal - R\$ ${(widget.valorunitario * widget.quantidade).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: Responsive.h(context, 10),
                                    color: ColorsApp.warningColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future<void> loadData() async {
    await Future.wait([_loadSavedUrlBasic()]);
    await Future.wait([fetchDataProductDetails2(widget.produtoId)]);
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> fetchDataProductDetails2(String produtoId) async {
    final data =
        await ProductsService2.fetchDataProductDetails2(urlBasic, produtoId);
    setState(() {
      nome = data['nome'].toString();
    });
  }

  // Future<void> fetchDataProducts() async {
  //   List<ProductsEndpoint>? fetchData =
  //       await DataServiceProducts.fetchDataProducts(urlBasic, widget.produtoId,);
  //   print(fetchData); // Verifica os dados obtidos
  //   if (fetchData != null) {
  //     setState(() {
  //       products = fetchData;
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() {
  //       isLoading =
  //           false; // Mesmo que os dados estejam vazios, para esconder o indicador
  //     });
  //   }
  // }
}
