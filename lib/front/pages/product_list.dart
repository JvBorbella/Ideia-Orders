import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/get_image.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:projeto/back/products/rm_product.dart';
import 'package:projeto/back/products/service_endpoint.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  final String? localId,
      prevendaid,
      pessoaid,
      numpedido,
      empresaId,
      tabelaprecoId,
      empresaCodigo,
      empresaNome;
  final String? pessoanome;
  final String? cpfcnpj;
  final String? telefone;
  final String? cep;
  final String? bairro;
  final String? endereco;
  final String? complemento;
  final double? valordesconto, valortotal;
  final int? flagObrigarVendedor,
      flagService,
      flagObrigarCliente,
      flagObrigarExpedicao;

  const ProductList({
    super.key,
    this.localId,
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
    this.flagService,
    this.empresaCodigo,
    this.empresaNome,
    this.valortotal,
    this.empresaId,
    this.tabelaprecoId,
    this.valordesconto,
    this.flagObrigarVendedor,
    this.flagObrigarCliente,
    this.flagObrigarExpedicao,
  });

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool flagService = false,
      isLoading = true,
      loadingList = false,
      flagcam = false,
      _scanned = false,
      flagGerarPedido = false;
  List<ProductsEndpoint> products = [];
  List<ServiceEndpoint> services = [];
  List<dynamic> productsAdd = [];
  String urlBasic = '',
      empresaid = '',
      token = '',
      expedicaoCodigo = '',
      expedicaoNome = '',
      expedicaoId = '',
      desc = '';
  late String tabelaprecoId = '';
  final text = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) =>
            Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => NewOrderPage(
                    localId: widget.localId,
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
                    empresaId: widget.empresaId,
                    empresaCodigo: widget.empresaCodigo,
                    empresaNome: widget.empresaNome,
                    tabelaprecoId: widget.tabelaprecoId,
                    valortotal: widget.valortotal,
                    tabelapreco: customerKey.currentState?.tableprice,
                    valordesconto: widget.valordesconto,
                    flagObrigarVendedor: widget.flagObrigarVendedor,
                    flagObrigarCliente: widget.flagObrigarCliente,
                    flagObrigarExpedicao: widget.flagObrigarExpedicao,
                  )),
        ),
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Column(
              children: [
                Navbar(text: flagService ? 'Serviços' : 'Produtos', children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NavbarButton(
                        destination: NewOrderPage(
                          localId: widget.localId,
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
                          empresaId: widget.empresaId,
                          empresaCodigo: widget.empresaCodigo,
                          empresaNome: widget.empresaNome,
                          tabelaprecoId: widget.tabelaprecoId,
                          valortotal: widget.valortotal,
                          tabelapreco: customerKey.currentState?.tableprice,
                          valordesconto: widget.valordesconto,
                          flagObrigarVendedor: widget.flagObrigarVendedor,
                          flagObrigarCliente: widget.flagObrigarCliente,
                          flagObrigarExpedicao: widget.flagObrigarExpedicao,
                        ),
                        icons: Icons.arrow_back_ios_new,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            flagcam = !flagcam;
                          });
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        color: ColorsApp.tertiaryColor,
                      ),
                    ],
                  ))
                ]),
                SizedBox(height: Responsive.h(context, 10)),
                if (flagcam)
                  Container(
                    padding: EdgeInsets.all(Responsive.h(context, 8)),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: Responsive.h(context, 2)),
                          borderRadius:
                              BorderRadius.circular(Responsive.h(context, 5))),
                      height: Responsive.h(context, 200),
                      child: MobileScanner(
                        onDetect: (barcodeCapture) {
                          final String? code =
                              barcodeCapture.barcodes.first.displayValue;
                          if (code != null && !_scanned) {
                            setState(() {
                              text.text = code;
                              loadingList = true;
                              fetchDataProducts();
                              _scanned = false; //   evita múltiplas leituras
                            });
                          }
                        },
                      ),
                    ),
                  ),
                Container(
                  height: Responsive.h(context, 60),
                  padding: EdgeInsets.all(Responsive.h(context, 12)),
                  child: SearchBar(
                    onTap: () {
                      text.clear();
                      fetchDataProducts();
                    },
                    focusNode: _focusNode,
                    textStyle: WidgetStatePropertyAll(
                        TextStyle(fontSize: Responsive.h(context, 10))),
                    controller: text,
                    onSubmitted: (value) async {
                      setState(() {
                        loadingList = true;
                      });
                      await fetchDataProducts(); // Chama a função de pesquisa ao pressionar "Enter"
                    },
                    constraints: const BoxConstraints(),
                    leading: IconButton(
                      padding:
                          EdgeInsets.only(bottom: Responsive.h(context, 1)),
                      onPressed: () async {
                        await fetchDataProducts();
                      },
                      icon: const Icon(Icons.search),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    hintText: flagService
                        ? 'Pesquise pelo Serviço'
                        : 'Pesquise pelo produto',
                    hintStyle: const WidgetStatePropertyAll(
                        TextStyle(color: ColorsApp.quarantineColor)),
                    padding: WidgetStatePropertyAll(EdgeInsets.only(
                      left: Responsive.h(context, 15),
                      right: Responsive.h(context, 15),
                    )),
                  ),
                ),
                TextTitle(
                    text: flagService
                        ? 'Lista de Serviços'
                        : 'Lista de produtos'),
                SizedBox(height: Responsive.h(context, 10)),
                if (loadingList == true)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (widget.flagObrigarExpedicao == 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(bottom: Responsive.h(context, 10)),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        //height: 45,
                        child: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) =>
                              buildMenuItemsexpedition(expedition),
                          onSelected: (value) async {
                            if (value != '') {
                              setState(() {
                                expedicaoId = value;
                                // Busca o nome da empresa correspondente ao ID selecionado
                                final selectedexpedition =
                                    expedition.firstWhere(
                                  (expedition) =>
                                      expedition['expedicao_id'] == value,
                                );
                                expedicaoNome = selectedexpedition['nome'] ??
                                    ''; // Atualiza o nome
                                expedicaoCodigo =
                                    selectedexpedition['codigo'] ??
                                        ''; // Atualiza o nome
                              });
                            } else {
                              setState(() {
                                expedicaoId = '';
                                expedicaoNome = '';
                                expedicaoCodigo = '';
                              });
                            }
                          },
                          child: Text(
                            expedicaoNome.isEmpty
                                ? 'Selecione a expedição'
                                : 'Expedição: $expedicaoCodigo - $expedicaoNome',
                            style: const TextStyle(
                              color: ColorsApp.tertiaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow
                                .ellipsis, // corta o texto no limite da largura
                            softWrap:
                                true, // permite a quebra de linha conforme necessário
                          ),
                        ),
                      ),
                    ],
                  ),
                if (productsAdd.isNotEmpty)
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: Responsive.h(context, 80)),
                    child: ListView.builder(
                      itemCount: productsAdd.length,
                      padding: const EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        width: Responsive.w(context, 220),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: ColorsApp.quarantineColor, width: 1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Responsive.h(context, 10),
                                ),
                                child: TelaExibicaoImagem(
                                  url: urlBasic,
                                  imagem: productsAdd[index]['imagem'] ?? '',
                                )),
                            SizedBox(
                              width: 80,
                              child: Text(
                                productsAdd[index]['nomeproduto'],
                                style: const TextStyle(fontSize: 8),
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            IconButton(
                                onPressed: () async {
                                  try {
                                    var url = Uri.parse(
                                        "$urlBasic/ideia/core/getdata/(SELECT%20pp.prevendaproduto_id%20FROM%20prevendaproduto%20pp%20WHERE%20pp.produto_id%20=%20'${productsAdd[index]['produto_id']}'%20AND%20pp.prevenda_id%20=%20'${productsAdd[index]['prevenda_id']}')%20AS%20p/");
                                    var response = await http.get(url,
                                        headers: {'Accept': 'text/html'});
                                    if (response.statusCode == 200) {
                                      var jsonData = json.decode(response.body);
                                      var dynamicKey =
                                          jsonData['data'].keys.first;
                                      var dataList =
                                          jsonData['data'][dynamicKey];

                                      await DataServiceOrdersDetails
                                          .fetchDataOrdersDetails(
                                              context,
                                              urlBasic,
                                              widget.prevendaid ?? '',
                                              widget.empresaId ?? '',
                                              token);
                                      await DataServiceRmProduct.sendDataOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          widget.prevendaid ?? '',
                                          dataList.first['prevendaproduto_id']);
                                      await removerItemProduto(
                                          dataList.first['prevendaproduto_id'],
                                          widget.localId ?? '');

                                      productsAdd.removeAt(index);
                                      setState(() {});
                                    } else {
                                      Message.showReturnOverlay(
                                          context,
                                          ColorsApp.errorColor,
                                          Icons.error,
                                          response.body);
                                    }
                                  } catch (e) {
                                    Message.showReturnOverlay(
                                        context,
                                        ColorsApp.errorColor,
                                        Icons.error,
                                        '$e');
                                  }
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: ColorsApp.errorColor,
                                  size: 20,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flagService ? services.length : products.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (flagService)
                            ProductAdd(
                              localId: widget.localId,
                              prevendaid: widget.prevendaid,
                              produtoid: services[index].produtoId.toString(),
                              nomeproduto: services[index].nome.toString(),
                              codigoproduto: services[index].codigo.toString(),
                              precotabela:
                                  services[index].precofinal.toDouble(),
                              onProductAdded:
                                  _onProductAdded, // Chama a função ao adicionar o produto
                            ),
                          ProductAdd(
                            url: urlBasic,
                            localId: widget.localId,
                            prevendaid: widget.prevendaid,
                            produtoid: products[index].produtoid.toString(),
                            empresaid: widget.empresaId.toString(),
                            nomeproduto: products[index].nome,
                            codigoproduto: products[index].codigo.toString(),
                            codigoean: products[index].codigoean.toString(),
                            unidade: products[index].unidade.toString(),
                            precotabela: products[index].precofinal,
                            flagunidadefracionada:
                                products[index].flagunidadefracionada,
                            onProductAdded: _onProductAdded,
                            quantidadeEstq:
                                double.parse(products[index].quantidadeEstq),
                            quantidadeUnMedida: double.parse(
                                products[index].quantidadeUnMedida),
                            expedicaoId: expedicaoId,
                            onExpedicaoChanged: (newId) {
                              setState(() {
                                expedicaoId = newId;
                                // opcional: mantem nome/codigo coerentes se necessário
                                if (newId == '') {
                                  expedicaoNome = '';
                                  expedicaoCodigo = '';
                                } else {
                                  final selected = expedition.firstWhere(
                                    (e) =>
                                        e['expedicao_id'].toString() == newId,
                                    orElse: () => {},
                                  );
                                  expedicaoNome = selected is Map
                                      ? (selected['nome'] ?? '')
                                      : '';
                                  expedicaoCodigo = selected is Map
                                      ? (selected['codigo'] ?? '')
                                      : '';
                                }
                              });
                            },
                            imagem: products[index].imagem,
                            produtounidademedidaId:
                                products[index].produtounidademedidaId,
                            expeditions: expedition,
                            flagObrigarExpedicao: widget.flagObrigarExpedicao,
                          ),
                        ],
                      );
                      //}
                    },
                  ),
                )
              ],
            ),
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

  Future<void> _loadSavedEmpresaID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmpresaID = sharedPreferences.getString('empresaId') ?? '';
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
        false; // Carrega o valor salvo (padrão: true)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  // Future<void> _loadSavedCheckProduct() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ??
  //       false; // Carrega o valor salvo (padrão: true)
  //   setState(() {
  //     isCheckedProduct =
  //         savedCheckProduct; // Atualiza o estado com o valor salvo
  //   });
  // }

  Future<void> loadData() async {
    final hasInternet = await hasInternetConnection();
    await Future.wait([_loadSavedFlagService()]);
    isCheckedProduct = true;
    if (flagService == true) {
      await Future.wait([
        _loadSavedUrlBasic(),
        _loadSavedEmpresaID(),
        _loadSavedToken(),
        //_loadSavedCheckProduct(),
        floadSavedFlagGerarPedido()
      ]);

      if (!hasInternet) {
      } else {
        await fetchDataTablePrice(widget.empresaId ?? '');
        await Future.wait([
          fetchDataServices(),
        ]);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    } else {
      await Future.wait([
        _loadSavedUrlBasic(),
        _loadSavedEmpresaID(),
        _loadSavedToken(),
        _loadSavedFlagService(),
        //_loadSavedCheckProduct(),
        floadSavedFlagGerarPedido()
      ]);
      if (!hasInternet) {
      } else {
        await fetchDataTablePrice(widget.empresaId ?? '');
        await fetchDataProducts();
        await fetchDataExpedtion();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataTablePrice(String empresaId) async {
    Map<String, String>? fetchedDataTablePrice =
        await DataServiceTablePrice.fetchDataTablePrice(
            context, urlBasic, empresaId);
    if (fetchedDataTablePrice != null) {
      setState(() {
        tabelaprecoId = fetchedDataTablePrice['tabelapreco_id'] == '' ||
                fetchedDataTablePrice['tabelapreco_id'] == null
            ? widget.tabelaprecoId ?? ''
            : fetchedDataTablePrice['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataServices() async {
    List<ServiceEndpoint>? fetchDataServices =
        await DataServiceServices.fetchDataSevices(
            context, urlBasic, token, text.text, tabelaprecoId);
    if (fetchDataServices != null) {
      setState(() {
        services = fetchDataServices;
      });
    }
    setState(() {
      isLoading = false;
      loadingList = false;
    });
  }

  Future<void> fetchDataProducts() async {
    List<ProductsEndpoint>? fetchData =
        await DataServiceProducts.fetchDataProducts(context, urlBasic, token,
            text.text, tabelaprecoId, widget.empresaId ?? '');
    if (fetchData != null) {
      setState(() {
        products = fetchData;
      });
    }
    setState(() {
      isLoading = false;
      loadingList = false;
    });
  }

  Future<void> floadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool favedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      flagGerarPedido = favedFlagGerarPedido;
    });
  }

  // Função que é chamada quando um produto é adicionado
  void _onProductAdded(Map<String, dynamic> added) {
    // setState(() {
    //   text.clear(); // Limpa a SearchBar
    // });
    if (flagService == true) {
      fetchDataServices();
    } else {
      fetchDataProducts();
    }
    productsAdd.add(added);
    customerKey.currentState?.hasProduct = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  List<PopupMenuItem<String>> buildMenuItemsexpedition(List expedition) {
    List<PopupMenuItem<String>> dynamicItems = expedition.map((expeditions) {
      return PopupMenuItem<String>(
        value: expeditions['expedicao_id'].toString(),
        key: Key(expeditions['nome'].toString()),
        child: Text(
            ('${expeditions['codigo']} - ${expeditions['nome']}').toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return dynamicItems;
  }

  Future<void> fetchDataExpedtion() async {
    try {
      var urlGet = Uri.parse(
          '$urlBasic/ideia/core/getdata/expedicao%20e%20WHERE%20COALESCE(e.flagexcluido,%200)%20<>%201/');
      var response = await http.get(urlGet, headers: {'Accept': 'text/html'});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        setState(() {
          expedition = dataList;
        });
      }
    } catch (e) {
      log('Erro durante a requisição: $e');
    }
  }
}
