import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:projeto/back/products/service_endpoint.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/pages/new_order_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  final empresa_id;
  final valordesconto;

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
      this.flagService,
      this.empresa_id,
      this.valordesconto});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool flagService = false,
      isLoading = true,
      loadingList = false,
      flagcam = false,
      _scanned = false,
      FlagGerarPedido = false;
  List<ProductsEndpoint> products = [];
  List<ServiceEndpoint> services = [];
  String urlBasic = '',
      empresaid = '',
      token = '',
      expedicaoCodigo = '',
      expedicaoNome = '',
      expedicaoId = '';
  late String tabelapreco_id = '';
  final text = TextEditingController();

  String desc = '';

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
    print(widget.cpfcnpj);
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
                              empresa_id: widget.empresa_id,
                              valordesconto: widget.valordesconto,
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
                            setState(() {
                              loadingList = true;
                            });
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
                      if (loadingList == true)
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else
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
                                    nomeproduto:
                                        services[index].nome.toString(),
                                    codigoproduto:
                                        services[index].codigo.toString(),
                                    precotabela:
                                        services[index].precofinal.toDouble(),
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
                      Navbar(text: 'Produtos', children: [
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  empresa_id: widget.empresa_id,
                                  valordesconto: widget.valordesconto),
                              Icons: Icons.arrow_back_ios_new,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  flagcam = !flagcam;
                                });
                              },
                              icon: Icon(Icons.qr_code_scanner),
                              color: Style.tertiaryColor,
                            ),
                          ],
                        ))
                      ]),
                      // Navbar(
                      //   text: 'Produtos',
                      //   children: [
                      //     NavbarButton(
                      //       destination: NewOrderPage(
                      //         prevendaId: widget.prevendaid,
                      //         pessoaid: widget.pessoaid,
                      //         numero: widget.numpedido,
                      //         pessoanome: widget.pessoanome,
                      //         cpfcnpj: widget.cpfcnpj,
                      //         telefone: widget.telefone,
                      //         cep: widget.cep,
                      //         bairro: widget.bairro,
                      //         endereco: widget.endereco,
                      //         complemento: widget.complemento,
                      //       ),
                      //       Icons: Icons.arrow_back_ios_new,
                      //     )
                      //   ],
                      // ),
                      SizedBox(height: Style.height_10(context)),
                      if (flagcam)
                        Container(
                          padding: EdgeInsets.all(Style.height_8(context)),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: Style.height_2(context)),
                                borderRadius: BorderRadius.circular(
                                    Style.height_5(context))),
                            height: Style.height_200(context),
                            child: MobileScanner(
                              //allowDuplicates: false,
                              onDetect: (BarcodeCapture) {
                                final String? code =
                                    BarcodeCapture.barcodes.first.displayValue;
                                if (code != null && !_scanned) {
                                  debugPrint('Código detectado: $code');
                                  setState(() {
                                    text.text = code;
                                    loadingList = true;
                                    fetchDataProducts();
                                    _scanned =
                                        false; // evita múltiplas leituras
                                  });
                                }
                              },
                            ),
                          ),
                        ),
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
                            setState(() {
                              loadingList = true;
                            });
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
                      if (loadingList == true)
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (isCheckedProduct && FlagGerarPedido)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                              height: Style.height_30(context),
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
                                      expedicaoNome =
                                          selectedexpedition['nome'] ??
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
                                  print(expedicaoId);
                                },
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: Style.secondaryColor,
                                        size: Style.height_20(context),
                                      ),
                                      Container(
                                        width: Style.width_150(context),
                                        child: Text(
                                          expedicaoNome.isEmpty
                                              ? 'Selecione a expedição'
                                              : '${expedicaoCodigo} - ${expedicaoNome}',
                                          style: TextStyle(
                                            color: Style.secondaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: Style.height_12(context),
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
                                  empresaid: widget.empresa_id.toString(),
                                  nomeproduto: products[index].nome.toString(),
                                  codigoproduto:
                                      products[index].codigo.toString(),
                                  codigoean:
                                      products[index].codigoean.toString(),
                                  unidade: products[index].unidade.toString(),
                                  precotabela:
                                      products[index].precofinal.toDouble(),
                                  flagunidadefracionada:
                                      products[index].flagunidadefracionada,
                                  onProductAdded: _onProductAdded,
                                  expedicaoId:
                                      expedicaoId, // Chama a função ao adicionar o produto
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
                      empresa_id: widget.empresa_id,
                      valordesconto: widget.valordesconto,
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
        false; // Carrega o valor salvo (padrão: true)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedCheckProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ??
        false; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedProduct =
          savedCheckProduct; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> loadData() async {
    final hasInternet = await hasInternetConnection();
    await Future.wait([_loadSavedFlagService()]);
    if (flagService == true) {
      await Future.wait([
        _loadSavedUrlBasic(),
        _loadSavedEmpresaID(),
        _loadSavedToken(),
        _loadSavedCheckProduct(),
        _loadSavedFlagGerarPedido()
      ]);

      if (!hasInternet) {
      } else {
        await fetchDataTablePrice(widget.empresa_id);
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
        _loadSavedCheckProduct(),
        _loadSavedFlagGerarPedido()
      ]);
      if (!hasInternet) {
      } else {
        await fetchDataTablePrice(widget.empresa_id);
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

  Future<void> fetchDataTablePrice(String empresa_id) async {
    Map<String, String>? fetchedDataTablePrice =
        await DataServiceTablePrice.fetchDataTablePrice(
            context, urlBasic, empresa_id);
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
      loadingList = false;
    });
  }

  Future<void> fetchDataProducts() async {
    List<ProductsEndpoint>? fetchData =
        await DataServiceProducts.fetchDataProducts(
            context, urlBasic, token, text.text, tabelapreco_id);
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

  Future<void> _loadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      FlagGerarPedido = savedFlagGerarPedido;
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
    });
  }

  void _closeModal() {
    Navigator.of(context).pop();
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

  Future<void> fetchDataExpedtion() async {
    try {
      var urlGet = Uri.parse(
          '$urlBasic/ideia/core/getdata/expedicao%20e%20WHERE%20COALESCE(e.flagexcluido,%200)%20<>%201/');
      var response = await http.get(urlGet, headers: {'Accept': 'text/html'});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;
        print('Chave dinâmica encontrada: $dynamicKey');

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        var data = dataList;
        var expedicaoId = data[0]['expedicao_id'];
        var expedicaoNome = data[0]['nome'];
        var expedicaoCodigo = data[0]['codigo'];

        print(dataList);

        setState(() {
          expedition = dataList;
        });
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }
}
