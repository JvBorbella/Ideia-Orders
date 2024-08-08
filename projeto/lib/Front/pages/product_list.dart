import 'package:flutter/material.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final String? pessoanome;
  final String? cpfcnpj;
  final String? telefone;
  final String? cep;
  final String? bairro;
  final String? endereco;
  final String? complemento;

  const ProductList({
    Key? key,
    this.pessoanome,
    this.cpfcnpj,
    this.telefone,
    this.cep,
    this.bairro,
    this.endereco,
    this.complemento,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ProductsEndpoint> products = [];
  String urlBasic = '';
  String token = '';
  final text = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
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
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            children: [
              Navbar(
                text: 'Produtos',
                children: [
                  NavbarButton(
                    destination: NewOrderPage(
                      pessoanome: widget.pessoanome,
                      cpfcnpj: widget.cpfcnpj,
                      telefone: widget.telefone,
                      cep: widget.cep,
                      bairro: widget.bairro,
                      endereco: widget.endereco,
                      complemento: widget.complemento,
                    ),
                    Icons: Icons.arrow_back_ios_new,
                  )
                ],
              ),
              SizedBox(height: Style.height_10(context)),
              Container(
                height: Style.height_60(context),
                padding: EdgeInsets.all(Style.height_12(context)),
                child: SearchBar(
                  textStyle: WidgetStatePropertyAll(
                      TextStyle(fontSize: Style.height_10(context))),
                  controller: text,
                  // onChanged: (value) async {
                  //   await fetchDataProducts();
                  // },
                  constraints: BoxConstraints(),
                  leading: IconButton(
                    padding: EdgeInsets.only(
                      bottom: Style.height_1(context)
                    ),
                    onPressed: () async {
                    await fetchDataProducts();
                  },
                    icon: Icon(Icons.search),
                    color: Style.primaryColor,
                    ),
                  hintText: 'Pesquise pelo produto',
                  hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Style.quarantineColor)),
                  padding: WidgetStatePropertyAll(EdgeInsets.only(
                    left: Style.height_15(context),
                    right: Style.height_15(context),
                  )
                  ),
                ),
              ),
              SizedBox(height: Style.height_10(context)),
              TextTitle(text: 'Lista de produtos'),
              SizedBox(height: Style.height_10(context)),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ProductAdd(
                        produtoid: products[index].produtoid.toString(),
                        nomeproduto: products[index].nome.toString(),
                        codigoproduto: products[index].codigo.toString(),
                        codigoean: products[index].codigoean.toString(),
                        unidade: products[index].unidade.toString(),
                        precopromocional:
                            products[index].precopromocional.toDouble(),
                        precotabela: products[index].precotabela.toDouble(),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
    ]);
    await fetchDataProducts();
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

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataProducts() async {
    List<ProductsEndpoint>? fetchData =
        await DataServiceProducts.fetchDataProducts(urlBasic, token, text.text);
    if (fetchData != null) {
      setState(() {
        products = fetchData;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
