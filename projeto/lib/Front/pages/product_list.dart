import 'package:flutter/material.dart';
import 'package:projeto/back/products_endpoint.dart';
import 'package:projeto/back/service_endpoint.dart';
import 'package:projeto/back/table_price.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductList extends StatefulWidget {
  final prevendaid;
  final pessoaid;
  final numpedido;
  final String? pessoanome;
  final String? cpfcnpj;
  final String? telefone;
  final String? cep;
  final String? bairro;
  final String? endereco;
  final String? complemento;

  final flagService;

  const ProductList(
      {Key? key,
      this.prevendaid,
      this.pessoaid,
      this.numpedido,
      this.pessoanome,
      this.cpfcnpj,
      this.telefone,
      this.cep,
      this.bairro,
      this.endereco,
      this.complemento,
      this.flagService});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool flagService = false;
  List<ProductsEndpoint> products = [];
  List<ServiceEndpoint> services = [];
  String urlBasic = '';
  String empresaid = '';
  String token = '';
  final text = TextEditingController();
  bool isLoading = true;

  final FocusNode _focusNode = FocusNode();

  late String tabelapreco_id = '';

  @override
  void initState() {
    super.initState();
    loadData();
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

    if (flagService == true) {
      return SafeArea(
          child: WillPopScope(
              child: Scaffold(
                body: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
                    children: [
                      Navbar(
                        text: 'Serviços',
                        children: [
                          NavbarButton(
                            destination: NewOrderPage(
                              prevendaId: widget.prevendaid,
                              pessoaid: widget.pessoaid,
                              numero: widget.numpedido,
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
                          focusNode: _focusNode,
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: Style.height_10(context))),
                          controller: text,
                          onSubmitted: (value) async {
                            await fetchDataServices(); // Chama a função de pesquisa ao pressionar "Enter"
                          },
                          constraints: const BoxConstraints(),
                          leading: IconButton(
                            padding: EdgeInsets.only(
                                bottom: Style.height_1(context)),
                            onPressed: () async {
                              await fetchDataServices();
                            },
                            icon: const Icon(Icons.search),
                            color: Style.primaryColor,
                          ),
                          onTap: () async {
                            text.clear();
                            fetchDataServices();
                          },
                          hintText: 'Pesquise pelo Serviço',
                          hintStyle: const WidgetStatePropertyAll(
                              TextStyle(color: Style.quarantineColor)),
                          padding: WidgetStatePropertyAll(EdgeInsets.only(
                            left: Style.height_15(context),
                            right: Style.height_15(context),
                          )),
                        ),
                      ),
                      SizedBox(height: Style.height_10(context)),
                      const TextTitle(text: 'Lista de Serviços'),
                      SizedBox(height: Style.height_10(context)),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ProductAdd(
                                  prevendaid: widget.prevendaid,
                                  produtoid:
                                      services[index].produto_id.toString(),
                                  nomeproduto: services[index].nome.toString(),
                                  codigoproduto:
                                      services[index].codigo.toString(),
                                  // codigoean: services[index].codigoean.toString(),
                                  // unidade: services[index].unidade.toString(),
                                  // precopromocional: services[index].precopromocional.toDouble(),
                                  precotabela:
                                      services[index].precofinal.toDouble(),
                                  // flagunidadefracionada: services[index].flagunidadefracionada,
                                  onProductAdded:
                                      _onProductAdded, // Chama a função ao adicionar o produto
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => NewOrderPage(
                      prevendaId: widget.prevendaid.toString(),
                      pessoaid: widget.pessoaid.toString(),
                      numero: widget.numpedido.toString(),
                      pessoanome: widget.pessoanome.toString(),
                      cpfcnpj: widget.cpfcnpj.toString(),
                      telefone: widget.telefone.toString(),
                      cep: widget.cep.toString(),
                      bairro: widget.bairro.toString(),
                      endereco: widget.endereco.toString(),
                      complemento: widget.complemento.toString(),
                      // Passe outros campos conforme necessário
                    ),
                  ),
                );
                return true;
              }));
    } else {
      return SafeArea(
          child: WillPopScope(
              child: Scaffold(
                body: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: Column(
                    children: [
                      Navbar(
                        text: 'Produtos',
                        children: [
                          NavbarButton(
                            destination: NewOrderPage(
                              prevendaId: widget.prevendaid,
                              pessoaid: widget.pessoaid,
                              numero: widget.numpedido,
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
                          onTap: () {
                            text.clear();
                            fetchDataProducts();
                          },
                          focusNode: _focusNode,
                          textStyle: WidgetStatePropertyAll(
                              TextStyle(fontSize: Style.height_10(context))),
                          controller: text,
                          onSubmitted: (value) async {
                            await fetchDataProducts(); // Chama a função de pesquisa ao pressionar "Enter"
                          },
                          constraints: const BoxConstraints(),
                          leading: IconButton(
                            padding: EdgeInsets.only(
                                bottom: Style.height_1(context)),
                            onPressed: () async {
                              await fetchDataProducts();
                            },
                            icon: const Icon(Icons.search),
                            color: Style.primaryColor,
                          ),
                          hintText: 'Pesquise pelo produto',
                          hintStyle: const WidgetStatePropertyAll(
                              TextStyle(color: Style.quarantineColor)),
                          padding: WidgetStatePropertyAll(EdgeInsets.only(
                            left: Style.height_15(context),
                            right: Style.height_15(context),
                          )),
                        ),
                      ),
                      SizedBox(height: Style.height_10(context)),
                      const TextTitle(text: 'Lista de produtos'),
                      SizedBox(height: Style.height_10(context)),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ProductAdd(
                                  prevendaid: widget.prevendaid,
                                  produtoid:
                                      products[index].produtoid.toString(),
                                  nomeproduto: products[index].nome.toString(),
                                  codigoproduto:
                                      products[index].codigo.toString(),
                                  codigoean:
                                      products[index].codigoean.toString(),
                                  unidade: products[index].unidade.toString(),
                                  precopromocional: products[index]
                                      .precopromocional
                                      .toDouble(),
                                  precotabela:
                                      products[index].precotabela.toDouble(),
                                  flagunidadefracionada:
                                      products[index].flagunidadefracionada,
                                  onProductAdded:
                                      _onProductAdded, // Chama a função ao adicionar o produto
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onWillPop: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => NewOrderPage(
                      prevendaId: widget.prevendaid.toString(),
                      pessoaid: widget.pessoaid.toString(),
                      numero: widget.numpedido.toString(),
                      pessoanome: widget.pessoanome.toString(),
                      cpfcnpj: widget.cpfcnpj.toString(),
                      telefone: widget.telefone.toString(),
                      cep: widget.cep.toString(),
                      bairro: widget.bairro.toString(),
                      endereco: widget.endereco.toString(),
                      complemento: widget.complemento.toString(),
                      // Passe outros campos conforme necessário
                    ),
                  ),
                );
                return true;
              }));
    }
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

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
    });
  }

  Future<void> _loadSavedFlagService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagService = sharedPreferences.getBool('flagService') ??
        true; // Carrega o valor salvo (padrão: true)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> loadData() async {
    await Future.wait([_loadSavedFlagService()]);
    if (flagService == true) {
      await Future.wait([
        _loadSavedUrlBasic(),
        _loadSavedEmpresaID(),
        _loadSavedToken(),
      ]);
      await fetchDataTablePrice();
      await fetchDataServices();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
        print('Foco solicitado: ${_focusNode.hasFocus}');
      });
    } else {
      await Future.wait(
          [_loadSavedUrlBasic(), _loadSavedToken(), _loadSavedFlagService()]);
      await fetchDataProducts();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
        print('Foco solicitado: ${_focusNode.hasFocus}');
      });
    }
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataTablePrice() async {
    Map<String, String>? fetchedDataTablePrice =
        await DataServiceTablePrice.fetchDataTablePrice(
            context, urlBasic, empresaid);
    if (fetchedDataTablePrice != null) {
      setState(() {
        tabelapreco_id = fetchedDataTablePrice['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataServices() async {
    List<ServiceEndpoint>? fetchDataServices =
        await DataServiceServices.fetchDataSevices(
            context, urlBasic, token, text.text, tabelapreco_id);
    if (fetchDataServices != null) {
      setState(() {
        services = fetchDataServices;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataProducts() async {
    List<ProductsEndpoint>? fetchData =
        await DataServiceProducts.fetchDataProducts(
            context, urlBasic, token, text.text);
    if (fetchData != null) {
      setState(() {
        products = fetchData;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // Função que é chamada quando um produto é adicionado
  void _onProductAdded() {
    setState(() {
      text.clear(); // Limpa a SearchBar
    });
    if (flagService == true) {
      fetchDataServices();
    } else {
      fetchDataProducts();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
      // print('Foco solicitado: ${_focusNode.hasFocus}');
    });
  }
}
