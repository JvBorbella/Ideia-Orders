import 'package:flutter/material.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsOrder extends StatefulWidget {
  final String urlBasic;
  final String prevenda_id;
  final String produto_id;
  final String codigoproduto;
  final String nomeproduto;
  final double valorunitario;
  final double quantidade;

  const ProductsOrder({
    Key?key, 
    this.urlBasic = '',
    this.prevenda_id = '',
    this.produto_id = '',
    this.codigoproduto = '',
    this.nomeproduto = '',
    this.valorunitario = 0.0,
    this.quantidade = 0.0,
  });

  @override
  State<ProductsOrder> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductsOrder> {
  String urlBasic = '';
  List<ProductsEndpoint> products = [];
  List<OrdersDetailsEndpoint> ordersDetails = [];
  bool isLoading = true;

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
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: ordersDetails.length,
          itemBuilder: (context, index) {
            return Row(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.nomeproduto,
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: Style.height_12(context),
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip,
                                softWrap: true,
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
                                widget.valorunitario.toString() + 'x' + widget.quantidade.toString(),
                                style: TextStyle(
                                    fontSize: Style.height_12(context),
                                    color: Style.primaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Subtotal - ',
                                style: TextStyle(
                                    fontSize: Style.height_10(context),
                                    color: Style.warningColor),
                              )
                            ],
                          )
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //       onPressed: () {},
                      //       icon: Icon(
                      //         Icons.remove_circle,
                      //         color: Style.errorColor,
                      //         size: Style.height_35(context),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
          }
        )
      ),
    );
  }

   Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
    print(urlBasic);
  }

   Future<void> fetchDataOrdersDetails() async {
    List<OrdersDetailsEndpoint>? fetchData =
        await DataServiceOrdersDetails.fetchDataOrdersDetails(
            urlBasic, widget.prevenda_id);
    print(fetchData); // Verifica os dados obtidos
    if (fetchData != null) {
      setState(() {
        ordersDetails = fetchData;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading =
            false; // Mesmo que os dados estejam vazios, para esconder o indicador
      });
    }
  }

  Future<void> fetchDataProducts() async {
    List<ProductsEndpoint>? fetchData =
        await DataServiceProducts.fetchDataProducts(urlBasic, widget.produto_id);
    print(fetchData); // Verifica os dados obtidos
    if (fetchData != null) {
      setState(() {
        products = fetchData;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading =
            false; // Mesmo que os dados estejam vazios, para esconder o indicador
      });
    }
  }
}
