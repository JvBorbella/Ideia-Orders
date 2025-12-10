import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsOrder extends StatefulWidget {
  final String urlBasic;
  final String prevenda_id;
  final String produtoId;
  final String codigoproduto;
  final String nomeproduto;
  final double valorunitario;
  final int quantidade;

  const ProductsOrder({Key?key, 
    this.urlBasic = '',
    this.prevenda_id = '',
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
   NumberFormat currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: '');

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
      
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(
            left: Style.height_15(context), right: Style.height_15(context)),
        decoration: BoxDecoration(
          color: Style.defaultColor,
          border: BorderDirectional(
            bottom: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
            top: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
          ),
        ),
       child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: Style.height_5(context)),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                              "assets/images/image_products/Barcode.png")
                        ],
                      ),
                      SizedBox(
                        width: Style.height_5(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: Style.width_150(context),
                                child: Text(
                                nome,
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: Style.height_12(context),
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
                                  fontSize: Style.height_10(context),
                                  color: Style.quarantineColor,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${currencyFormat.format(widget.valorunitario)} x ${widget.quantidade}',
                                style: TextStyle(
                                    fontSize: Style.height_12(context),
                                    color: Style.primaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                 'Subtotal - R\$ ${(widget.valorunitario * widget.quantidade).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: Style.height_10(context),
                                    color: Style.warningColor),
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
        )
      ),
    );
  }

  Future<void> loadData() async {
    await Future.wait([_loadSavedUrlBasic()]);
    await Future.wait([
      fetchDataProductDetails2(widget.produtoId)
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

 Future<void> fetchDataProductDetails2(String produtoId) async {
    final data = await ProductsService2.fetchDataProductDetails2(
        urlBasic, produtoId);
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
