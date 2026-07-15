// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:brasil_datetime/brasil_datetime.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/company/alter_table_endpoint.dart';
import 'package:projeto/back/company/company_data_return.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/customer/send_customer_offline.dart';
import 'package:projeto/back/offline/functions/get_token.dart';
import 'package:projeto/back/orders/finish_order.dart';
import 'package:projeto/back/orders/new_order.dart';
import 'package:projeto/back/orders/order_details.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/products_endpoint.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/back/products/send_products_offline.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/home/elements/drawer_button.dart';
import 'package:projeto/front/components/home/elements/modal_button.dart';
import 'package:projeto/front/components/home/elements/order_container.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/pages/login.dart';
import 'package:projeto/front/pages/new_order_page.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>();

class Home extends StatefulWidget {
  final String token, url, urlBasic, password;

  const Home(
      {super.key,
      this.token = '',
      this.url = '',
      this.urlBasic = '',
      this.password = ''});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<OrdersEndpoint> orders = [];
  List<ProductsEndpoint> products = [];
  List<OrdersDetailsEndpoint> ordersDetails = [];
  List<ListTablePrices> tablesPrice = [];
  List<CompanyList> company = [];
  List offlineOrders = [];

  bool isLoading = true,
      permNovaPrevenda = false,
      permEditarPrevenda = false,
      flagGerarPedido = false;
  int flagPrivilegiado = 0,
      flagFilter = 0,
      flagpermitiralterartabela = 0,
      flagObrigarVendedor = 0,
      flagObrigarCliente = 0,
      flagObrigarExpedicao = 0;

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  double descontoMaximoPermitido = 0.0;

  String urlController = '',
      selectedOptionChild = '',
      urlBasic = '',
      usuarioId = '',
      id = '',
      token = '',
      prevendaId = '',
      empresaid = '',
      tabelaprecoIdCompany = '',
      tabelaprecoId = '',
      perfilId = '',
      empresaId = '',
      empresaNome = '',
      empresaCodigo = '',
      tableprice = '',
      tablepriceId = '',
      perfilUsuario = '',
      dataSync = '';

  late String pessoanome = '';
  late String cpfcnpj = '';
  late String telefone = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String enderecocidade = '';
  late String endereconumero = '';
  late String enderecocomplemento = '';
  late String enderecocep = '';
  late String uf = '';
  late String codigoproduto = '';
  late String pessoaid = '';
  late String nome = '';
  late String codigo = '';
  late String cpfcliente = '';
  late String filterValue = '';

  final GlobalKey<ProductSessionState> productKey =
      GlobalKey<ProductSessionState>();

  final _cepcontroller = TextEditingController(),
      _complementocontroller = TextEditingController(),
      _bairrocontroller = TextEditingController(),
      _cidadecontroller = TextEditingController(),
      _numerocontroller = TextEditingController(),
      _ufcontroller = TextEditingController(),
      _logradourocontroller = TextEditingController(),
      _emailcontroller = TextEditingController(),
      _cpfcontroller = TextEditingController(),
      clientcontroller = TextEditingController(),
      _nomecontroller = TextEditingController(),
      _telefonecontatocontroller = TextEditingController();

  String formatTel(String telefonecontato) {
    if (telefonecontato.length > 10) {
      // CPF
      return UtilBrasilFields.obterTelefone(telefonecontato);
    } else {
      // Não formatado
      return telefonecontato;
    }
  }

  @override
  void initState() {
    super.initState();
    // limparPedidoFinalizado();
    floadSavedFlagGerarPedido();
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedUserId();
    _loadSavedEmpresaID();
    _loadSavedFilter();
    _loadSavedFlagPermiteAlterTable();
    _loadSavedDataSync();
    loadData();

    _startSendOrdersOffline();
    // sendOrdersOffline(context);
  }

  Future<void> floadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool favedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      flagGerarPedido = favedFlagGerarPedido;
    });
  }

  Timer? _offlineTimer;
  bool _isSyncing = false;

  bool inSync = false;
  void _startSendOrdersOffline() {
    //_offlineTimer?.cancel(); // Prevent multiple timers
    _offlineTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      // Less frequent
      if (!mounted) return;

      // ✅ lock anti-reentrância
      if (_isSyncing) return;
      _isSyncing = true;

      final bool hasInternet = await hasInternetConnection();
      if (!hasInternet || !mounted) return;

      final List<OrdersEndpoint> allOrders = await recuperarListaPedido();
      final List<OrdersEndpoint> ordersOffline =
          allOrders.where((e) => e.flagSync == 0).toList();

      final String token = await GetToken.getToken();
      try {
        for (final OrdersEndpoint order in ordersOffline) {
          if (!mounted) break;
          //try {
          setState(() {
            inSync = true;
          });
          // 1. Search `empresa_id` and `tabelaprecoId` if missing (shouldn't happen but just in case)
          final empresaIdToUse = await CompanyDataReturn().searchCompany(
              urlBasic, '', order.empresaCodigo ?? '', order.empresaNome ?? '');
          final tablepriceIdToUse = await CompanyDataReturn()
              .searchTablePrice(urlBasic, '', '', order.tabelaprecoNome ?? '');

          late dynamic numeroPedido;
          late dynamic prevendaId;

          prevendaId = order.prevendaId;
          numeroPedido = order.numero;

          // 2. Create order on server
          final Map<String, dynamic>? newOrderResponse =
              await DataServiceNewOrder.sendDataOrder(
            context,
            urlBasic,
            token,
            order.cpfcnpj ?? '',
            order.telefone ?? '',
            order.nomepessoa,
            '',
            tablepriceIdToUse,
            empresaIdToUse,
            order.localId ?? '',
            isBackground: true,
          );

          prevendaId = newOrderResponse?['prevenda_id']?.toString() ?? '';
          numeroPedido = newOrderResponse?['numero']?.toString() ?? '';

          // if (order.flagSync == 0) {
          //   // 2. Create order on server
          //   final Map<String, dynamic>? newOrderResponse =
          //       await DataServiceNewOrder.sendDataOrder(
          //     context,
          //     urlBasic,
          //     token,
          //     order.cpfcnpj ?? '',
          //     order.telefone ?? '',
          //     order.nomepessoa,
          //     '',
          //     tablepriceIdToUse,
          //     empresaIdToUse,
          //     order.localId ?? '',
          //     isBackground: true,
          //   );

          //   prevendaId = newOrderResponse?['prevenda_id']?.toString() ?? '';
          //   numeroPedido = newOrderResponse?['numero']?.toString() ?? '';

          // // 6. Mark as synced & remove locally ONLY if ALL steps succeeded
          // await removerPedido(order.localId ?? order.prevendaId);

          //   if (prevendaId.isEmpty) {
          //     log('Failed to create order for localId: ${order.localId}');
          //     continue;
          //   }
          // }

          // 3. Send products using new server prevenda_id (called once per order, sending all products)
          await DataServiceSendProductsOff().sendDataProducts(
            urlBasic,
            prevendaId,
            order.localId ?? order.prevendaId,
            empresaIdToUse,
            tablepriceIdToUse,
            context,
            isBackground: true,
          );

          // 4. Send customer data
          await DataServiceSendCustomer().sendDataCustomer(
            context,
            prevendaId,
            order.localId ?? order.prevendaId,
            empresaIdToUse,
            tablepriceIdToUse,
            urlBasic,
          );

          // 6. Mark as synced & remove locally ONLY if ALL steps succeeded
          await removerPedido(order.localId ?? order.prevendaId);

          log('✅ Synced order ${order.localId ?? order.prevendaId} -> server $prevendaId');
          //log('❌ Order ${order.localId ?? order.prevendaId} sync failed: $orderError');
          // } catch (orderError) {
          //   log('❌ Order ${order.localId ?? order.prevendaId} sync failed: $orderError');
          //   // Continue with next order
          // }
        }
        for (var order in allOrders) {
          final allProducts =
              await recuperarListaProdutosPedido(order.localId ?? '');
          final customerOrder =
              await recuperarClientePorLocalId(order.localId ?? '');
          var productsOffline =
              allProducts.where((e) => e.flagSync == 0).toList();
          var customerOffline =
              customerOrder.where((e) => e['flag_sync'] == 0).toList();
          final produtosParaRemocao =
              await recuperarProdutosParaRemocao(order.localId ?? '');

          if (productsOffline.isNotEmpty ||
              customerOffline.isNotEmpty ||
              produtosParaRemocao.isNotEmpty) {
            await DataServiceSendProductsOff().sendDataProducts(
                urlBasic,
                order.prevendaId,
                order.localId ?? '',
                order.empresaId,
                order.tabelaprecoId ?? '',
                context,
                isBackground: true);
            await DataServiceSendCustomer().sendDataCustomer(
                context,
                order.prevendaId,
                order.localId ?? '',
                order.empresaId,
                order.tabelaprecoId ?? '',
                urlBasic);
          }
        }
      } finally {
        // ✅ liberar lock mesmo em caso de erro
        _isSyncing = false;
        setState(() {
          inSync = false;
        });
        if (mounted) {
          await fetchDataOrders(ascending: true, flagFilter: flagFilter);
        }
      }
      // Sync main offline orders first
    });
  }

  @override
  void dispose() {
    _offlineTimer?.cancel();
    super.dispose();
  }

  void _openModal(BuildContext context) {
    bool isLoadingButton = false;
    bool isLoadingSearch = false;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setModalState) {
            return Modal('Abertura de pedido', [
              if (empresaid.isEmpty)
                SizedBox(
                  height: Responsive.h(context, 30),
                  child: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        buildMenuItemsCompany(company),
                    onSelected: (value) async {
                      final selectedCompany = company.firstWhere(
                        (company) => company.empresaId == value,
                      );
                      if (value != '') {
                        setModalState(() {
                          empresaId = value;
                          // Busca o nome da empresa correspondente ao ID selecionado
                          empresaNome = selectedCompany.empresaNome ??
                              ''; // Atualiza o nome
                          empresaCodigo = selectedCompany.empresaCodigo ??
                              ''; // Atualiza o nome
                        });
                        setState(() {
                          empresaId = value;
                          flagObrigarVendedor =
                              selectedCompany.flagobrigarvendedor ?? 0;
                          flagObrigarCliente =
                              selectedCompany.flagobrigarcliente ?? 0;
                          flagObrigarExpedicao =
                              selectedCompany.flagobrigarexpedicao ?? 0;
                        });
                        await fetchDataTablePriceCompany(empresaId);
                        await fetchDataTablePrice(empresaId);
                        await fetchDataListTablesPrice(empresaId);
                        await fetchDataTablePriceName();
                        setModalState(() {
                          tableprice;
                        });
                        setState(() {
                          tabelaprecoId = tabelaprecoIdCompany;
                        });
                      } else {
                        setState(() {
                          empresaId = '';
                          empresaNome = '';
                          empresaCodigo = '';
                        });
                      }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: Responsive.h(context, 20),
                          ),
                          SizedBox(
                            width: Responsive.h(context, 2),
                          ),
                          SizedBox(
                            child: Text(
                              empresaNome.isEmpty
                                  ? 'Selecione a empresa'
                                  : '$empresaCodigo - $empresaNome',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.h(context, 12),
                              ),
                              overflow: TextOverflow
                                  .clip, // corta o texto no limite da largura
                              softWrap:
                                  true, // permite a quebra de linha conforme necessário
                            ),
                          )
                        ]),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Text(
                        '$empresaCodigo $empresaNome',
                        style: TextStyle(
                          color: ColorsApp.quarantineColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.h(context, 12),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .clip, // corta o texto no limite da largura
                        softWrap:
                            true, // permite a quebra de linha conforme necessário
                      ),
                    )
                  ],
                ),
              if (flagpermitiralterartabela == 1)
                SizedBox(
                  height: Responsive.h(context, 30),
                  child: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        buildMenuItemsTPrice(tablesPrice),
                    onSelected: (value) async {
                      await DataServiceTablePriceId.fetchDataTablePriceId(
                          context, urlBasic, tableprice);
                      final selectedTBPrice = tablesPrice.firstWhere(
                        (table) => table.tabelaprecoId == value,
                      );
                      setModalState(() {
                        tableprice = selectedTBPrice.nome ?? '';
                      });
                      setState(() {
                        tableprice = selectedTBPrice.nome ?? '';
                        tabelaprecoId = value;
                        fetchDataTablePriceId();
                      });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: Theme.of(context).colorScheme.onSecondary,
                            size: Responsive.h(context, 20),
                          ),
                          SizedBox(
                            width: Responsive.h(context, 2),
                          ),
                          SizedBox(
                            child: Text(
                              tableprice.isEmpty
                                  ? 'Tabela de Preço'
                                  : tableprice,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.h(context, 12),
                              ),
                              //textAlign: TextAlign.center,
                              overflow: TextOverflow
                                  .clip, // corta o texto no limite da largura
                              softWrap:
                                  true, // permite a quebra de linha conforme necessário
                            ),
                          ),
                        ]),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Text(
                        tableprice.isEmpty
                            ? 'Tab. Preço não informada'
                            : tableprice,
                        style: TextStyle(
                          color: ColorsApp.quarantineColor,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.h(context, 12),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow
                            .clip, // corta o texto no limite da largura
                        softWrap:
                            true, // permite a quebra de linha conforme necessário
                      ),
                    )
                  ],
                ),
              Input(
                text: 'Informe o Cliente',
                type: TextInputType.text,
                textAlign: TextAlign.start,
                controller: clientcontroller,
                textInputAction: TextInputAction.unspecified,
                isLoadingButton: isLoadingSearch,
                iconButton: IconButton(
                  onPressed: () async {
                    setModalState(
                      () {
                        isLoadingSearch = true;
                      },
                    );
                    await searchClient();
                    setModalState(
                      () {
                        isLoadingSearch = false;
                      },
                    );
                  },
                  icon: const Icon(Icons.person_search),
                ),
              ),
              SizedBox(
                height: Responsive.h(context, 10),
              ),
              // Input(
              //   text: 'Telefone',
              //   type: TextInputType.text,
              //   controller: _telefonecontatocontroller,
              //   textAlign: TextAlign.start,
              //   textInputAction: TextInputAction.unspecified,
              //   inputFormatters: [
              //     MaskedInputFormatter('(00) 00000-0000'), // Máscara de CPF
              //   ],
              // ),
              // SizedBox(
              //   height: Responsive.h(context, 10),
              // ),
              // Input(
              //   text: 'Nome do cliente',
              //   type: TextInputType.text,
              //   controller: _nomecontroller,
              //   textInputAction: TextInputAction.unspecified,
              //   textAlign: TextAlign.start,
              // ),
              // SizedBox(
              //   height: Responsive.h(context, 20),
              // ),
              // SizedBox(
              //   height: Responsive.h(context, 10),
              // ),
              RegisterButton(
                text: 'Abrir Pedido',
                color: Theme.of(context).colorScheme.primary,
                //width: Responsive.w(context, 150),
                isLoadingButton: isLoadingButton,
                onPressed: () async {
                  setModalState(() {
                    isLoadingButton = true;
                  });
                  final uuid = const Uuid().v4();
                  final Map<String, dynamic> bodyMap = {
                    "usuario_id": usuarioId,
                    "vendedor_pessoa_id": '',
                    "empresa_id": empresaid == '' ? empresaId : empresaid,
                    "empresa_nome": empresaNome,
                    "empresa_codigo": empresaCodigo,
                    "tabelaprec_id": tabelaprecoId,
                    "prevenda_id": '',
                    "nome_2": tableprice, //Nomde da tabela de preço
                    "numero": '', //(listaPedidoOff.last.numero + 1),
                    "valortotal": 0.0,
                    "valordesconto": 0.0,
                    "datahora": DateTime.now().toIso8601String(),
                    "nomepessoa": _nomecontroller.text,
                    "telefone": _telefonecontatocontroller.text,
                    "cpfcnpj": _cpfcontroller.text,
                    "operador": '',
                    "flagprocessado": 0,
                    "flagpermitefaturar": 1,
                    "flag_sync": 0, // 0 = offline, 1 = sincronizado
                    "local_id": uuid,
                  };
                  final hasInternet = await hasInternetConnection();
                  if (!hasInternet) {
                    await adicionarPedido(bodyMap);
                    await fetchDataOrders(
                        ascending: true, flagFilter: flagFilter);
                    Message.showReturnOverlay(
                        context,
                        ColorsApp.warningColor,
                        Icons.cloud_off_outlined,
                        'Pedido armazenado localmente devido à falta de conexão com a internet');
                  } else {
                    String pessoaId = '';
                    if (_cpfcontroller.text.isNotEmpty) {
                      final data = await DataServiceCliente2.fetchDataCliente2(
                          urlBasic, _cpfcontroller.text, token);
                      pessoaId = data['pessoa_id'].toString();
                    }
                    if (flagpermitiralterartabela == 1) {
                      await DataServiceNewOrder.sendDataOrder(
                          context,
                          urlBasic,
                          token,
                          _cpfcontroller.text,
                          _telefonecontatocontroller.text,
                          _nomecontroller.text,
                          pessoaId,
                          tabelaprecoId,
                          empresaid == '' ? empresaId : empresaid,
                          uuid);
                    } else {
                      await DataServiceNewOrder.sendDataOrder(
                          context,
                          urlBasic,
                          token,
                          _cpfcontroller.text,
                          _telefonecontatocontroller.text,
                          _nomecontroller.text,
                          pessoaId,
                          tabelaprecoIdCompany,
                          empresaid == '' ? empresaId : empresaid,
                          uuid);
                    }
                    await fetchDataOrders(
                        ascending: true, flagFilter: flagFilter);
                    setState(() {
                      selectedOptionChild =
                          _getFilterText(flagFilter.toString());
                    });
                  }
                  setModalState(() {
                    isLoadingButton = false;
                  });
                  _closeModal();
                  _cpfcontroller.clear();
                  _nomecontroller.clear();
                  _telefonecontatocontroller.clear();
                },
              )
            ]);
          });
        }).then((_) {
      _cpfcontroller.clear();
      _nomecontroller.clear();
      _telefonecontatocontroller.clear();
    });
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
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
            ModalExit.modalExit(context),
        child: Scaffold(
          drawer: Drawer(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomDrawer(
                pass: widget.password,
                perfilUsuario: perfilUsuario,
                empresaCodigo: empresaCodigo,
                empresaNome: empresaNome,
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: SizedBox(
            width: Responsive.h(context, 50), // Defina a largura desejada
            height: Responsive.h(context, 50), // Defina a largura desejada
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                // if (permNovaPrevenda || permEditarPrevenda) {
                _openModal(context);
                // } else {
                //   showDialog(
                //       context: context,
                //       builder: (_) => AlertDialogDefault());
                // }
              },
              shape: const CircleBorder(),
              child: Icon(
                Icons.add,
                color: ColorsApp.tertiaryColor,
                size: Responsive.h(context, 20),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              children: [
                Navbar(
                  text: 'Pedidos',
                  children: [
                    DrawerButton(
                      style: ButtonStyle(
                        iconSize:
                            WidgetStatePropertyAll(Responsive.h(context, 25)),
                        iconColor: const WidgetStatePropertyAll(
                            ColorsApp.tertiaryColor),
                        padding: WidgetStatePropertyAll(
                            EdgeInsets.all(Responsive.h(context, 8))),
                      ),
                    ),
                  ],
                ),
                FutureBuilder<bool>(
                  future: hasInternetConnection(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && !snapshot.data!) {
                      return Container(
                          decoration: const BoxDecoration(
                              color: ColorsApp.warningColor),
                          padding: EdgeInsets.all(Responsive.h(context, 10)),
                          child: Text(
                            'Última sincronização de dados: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now().toLocal())}',
                            style: TextStyle(
                                fontSize: Responsive.h(context, 8),
                                color: ColorsApp.tertiaryColor),
                            textAlign: TextAlign.center,
                          ));
                    }
                    if (inSync == true) {
                      return Container(
                          decoration: const BoxDecoration(
                              color: ColorsApp.secondaryColor),
                          padding: EdgeInsets.all(Responsive.h(context, 10)),
                          child: Text(
                            'Sincronizando pedidos offline...',
                            style: TextStyle(
                                fontSize: Responsive.h(context, 8),
                                color: ColorsApp.tertiaryColor),
                            textAlign: TextAlign.center,
                          ));
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: Responsive.h(context, 10)),
                const Center(child: TextTitle(text: 'Lista de pedidos')),
                PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSecondary,
                            )),
                            value: 'finalizados',
                            child: const Text(
                              'Faturados',
                            ),
                          ),
                          PopupMenuDivider(
                            height: Responsive.h(context, 1),
                          ),
                          PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins-Medium',
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                            value: 'abertos',
                            child: const Text(
                              'Em aberto',
                            ),
                          ),
                          PopupMenuDivider(
                            height: Responsive.h(context, 1),
                          ),
                          PopupMenuItem<String>(
                            labelTextStyle: WidgetStatePropertyAll(TextStyle(
                                fontSize: 15,
                                fontFamily: 'Poppins-Medium',
                                color:
                                    Theme.of(context).colorScheme.onSecondary)),
                            value: 'todos',
                            child: const Text('Todos'),
                          ),
                        ],
                    onSelected: (String value) async {
                      if (value == 'finalizados') {
                        filterValue = '1';
                        setState(() {
                          flagFilter = 1;
                        });
                      } else if (value == 'abertos') {
                        filterValue = '0';
                        setState(() {
                          flagFilter = 0;
                        });
                      } else {
                        filterValue = '';
                        setState(() {
                          flagFilter = 2;
                        });
                      }
                      await _saveFilter(flagFilter.toString());
                      await fetchDataOrders(
                          ascending: true, flagFilter: flagFilter);
                      setState(() {
                        selectedOptionChild = _getFilterText(filterValue);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(Responsive.h(context, 8)),
                      margin: EdgeInsets.all(Responsive.h(context, 12)),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          Icons.filter_list_alt,
                          color: ColorsApp.tertiaryColor,
                          size: Responsive.h(context, 20),
                        ),
                        SizedBox(
                          width: Responsive.h(context, 2),
                        ),
                        Text(
                          'Filtrado por: ',
                          style: TextStyle(
                              fontSize: Responsive.h(context, 12),
                              color: ColorsApp.tertiaryColor),
                        ),
                        SizedBox(
                          child: Text(
                            selectedOptionChild,
                            style: TextStyle(
                              color: ColorsApp.tertiaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.h(context, 12),
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow
                                .clip, // corta o texto no limite da largura
                            softWrap:
                                true, // permite a quebra de linha conforme necessário
                          ),
                        )
                      ]),
                    )),
                // Container(
                //   padding: EdgeInsets.all(Responsive.h(context, 15)),
                //   margin: EdgeInsets.only(bottom: Responsive.h(context, 20)),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.surface,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withValues(alpha: 0.15),
                //         spreadRadius: 5,
                //         blurRadius: 7,
                //         offset: const Offset(0, 3),
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         height: Responsive.h(context, 30),
                //         child: PopupMenuButton<String>(
                //           itemBuilder: (BuildContext context) =>
                //               <PopupMenuEntry<String>>[
                //             PopupMenuItem<String>(
                //               labelTextStyle: WidgetStatePropertyAll(TextStyle(
                //                 fontSize: 15,
                //                 color:
                //                     Theme.of(context).colorScheme.onSecondary,
                //               )),
                //               value: 'finalizados',
                //               child: const Text(
                //                 'Finalizados',
                //               ),
                //             ),
                //             PopupMenuDivider(
                //               height: Responsive.h(context, 1),
                //             ),
                //             PopupMenuItem<String>(
                //               labelTextStyle: WidgetStatePropertyAll(TextStyle(
                //                   fontSize: 15,
                //                   fontFamily: 'Poppins-Medium',
                //                   color: Theme.of(context)
                //                       .colorScheme
                //                       .onSecondary)),
                //               value: 'abertos',
                //               child: const Text(
                //                 'Em aberto',
                //               ),
                //             ),
                //             PopupMenuDivider(
                //               height: Responsive.h(context, 1),
                //             ),
                //             PopupMenuItem<String>(
                //               labelTextStyle: WidgetStatePropertyAll(TextStyle(
                //                   fontSize: 15,
                //                   fontFamily: 'Poppins-Medium',
                //                   color: Theme.of(context)
                //                       .colorScheme
                //                       .onSecondary)),
                //               value: 'todos',
                //               child: const Text('Todos'),
                //             ),
                //           ],
                //           onSelected: (String value) async {
                //             if (value == 'finalizados') {
                //               filterValue = '1';
                //               setState(() {
                //                 flagFilter = 1;
                //               });
                //             } else if (value == 'abertos') {
                //               filterValue = '0';
                //               setState(() {
                //                 flagFilter = 0;
                //               });
                //             } else {
                //               filterValue = '';
                //               setState(() {
                //                 flagFilter = 2;
                //               });
                //             }
                //             await _saveFilter(flagFilter.toString());
                //             await fetchDataOrders(
                //                 ascending: true, flagFilter: flagFilter);
                //             setState(() {
                //               selectedOptionChild = _getFilterText(filterValue);
                //             });
                //           },
                //           child: Row(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Icons.filter_list_outlined,
                //                   color: Theme.of(context).colorScheme.primary,
                //                   size: Responsive.h(context, 20),
                //                 ),
                //                 SizedBox(
                //                   width: Responsive.h(context, 2),
                //                 ),
                //                 Text(
                //                   'Filtrado por: ',
                //                   style: TextStyle(
                //                       fontSize: Responsive.h(context, 12)),
                //                 ),
                //                 SizedBox(
                //                   child: Text(
                //                     selectedOptionChild,
                //                     style: TextStyle(
                //                       color: Theme.of(context)
                //                           .colorScheme
                //                           .onSecondary,
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: Responsive.h(context, 12),
                //                     ),
                //                     textAlign: TextAlign.center,
                //                     overflow: TextOverflow
                //                         .clip, // corta o texto no limite da largura
                //                     softWrap:
                //                         true, // permite a quebra de linha conforme necessário
                //                   ),
                //                 )
                //               ]),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          fetchDataOrdersDetails2(
                            orders[index].prevendaId,
                          );
                          if (orders[index].flagprocessado == 1) {
                            if (!mounted) return;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => OrderPage(
                                        prevendaId: orders[index].prevendaId,
                                        localId: orders[index].localId,
                                        pessoaId: pessoaid,
                                        empresaId: orders[index].empresaId,
                                        numero: orders[index].numero.toString(),
                                        pessoanome: pessoanome,
                                        cpfcnpj:
                                            orders[index].cpfcnpj.toString(),
                                        telefone: telefone,
                                        endereco: endereco,
                                        valortotal: orders[index].valortotal,
                                        uf: uf,
                                        operador: orders[index].operador,
                                        vendedorId: orders[index].vendedorId,
                                        datahora: orders[index].datahora,
                                        codigoproduto: codigoproduto,
                                        valordesconto:
                                            orders[index].valordesconto,
                                        empresa: orders[index].empresaNome)));
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => NewOrderPage(
                                        prevendaId: orders[index].prevendaId,
                                        pessoaid: orders[index].pessoaId,
                                        vendedorId: orders[index].vendedorId,
                                        numero: orders[index].numero.toString(),
                                        pessoanome:
                                            orders[index].nomepessoa.toString(),
                                        cpfcnpj:
                                            orders[index].cpfcnpj.toString(),
                                        telefone:
                                            orders[index].telefone.toString(),
                                        datahora: orders[index].datahora,
                                        valortotal: orders[index].valortotal,
                                        codigoproduto: codigoproduto,
                                        operador: orders[index].operador,
                                        empresaId:
                                            orders[index].empresaId.toString(),
                                        empresaCodigo:
                                            orders[index].empresaCodigo,
                                        //empresaCodigo.toString(),
                                        empresaNome: orders[index]
                                            .empresaNome, //empresaNome.toString(),
                                        tabelaprecoId: orders[index]
                                            .tabelaprecoId
                                            .toString(),
                                        tabelapreco: orders[index]
                                            .tabelaprecoNome
                                            .toString(),
                                        localId: orders[index].localId,
                                        valordesconto:
                                            orders[index].valordesconto,
                                        flagObrigarVendedor:
                                            orders[index].flagobrigarvendedor,
                                        flagObrigarCliente:
                                            orders[index].flagobrigarcliente,
                                        flagObrigarExpedicao:
                                            orders[index].flagobrigarexpedicao,
                                      )),
                            );
                          }
                        },
                        child: OrderContainer(
                            numero: orders[index].numero.toString(),
                            valortotal: orders[index].valortotal,
                            nomepessoa: orders[index].nomepessoa,
                            data: orders[index].datahora,
                            flagpermitefaturar:
                                orders[index].flagpermitefaturar,
                            valordesconto: orders[index].valordesconto,
                            flagSync: orders[index].flagSync,
                            flagprocessado: orders[index].flagprocessado),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('saveUrl') ?? '';
    if (!mounted) return;
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

  Future<void> _loadSavedUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUserId = sharedPreferences.getString('usuario_id') ?? '';
    setState(() {
      usuarioId = savedUserId;
    });
  }

  Future<void> _loadSavedDataSync() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String dataSavedSync = sharedPreferences.getString('data_save') ?? '';
    setState(() {
      dataSync = dataSavedSync;
    });
  }

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    final checkInternet = await hasInternetConnection();
    if (checkInternet && savedToken.isEmpty) {
      final getToken = await GetToken.getToken();
      if (!mounted) return;
      setState(() {
        token = getToken;
      });
    } else {
      if (!mounted) return;
      setState(() {
        token = savedToken;
      });
    }
  }

  Future<void> loadData() async {
    final hasInternet = await hasInternetConnection();
    if (hasInternet) {
      await salvarDataSave(DateTime.now().diaMesAnoHoraMinuto());
    }

    if (!mounted) return;
    await Future.wait([clearCache()]);
    if (!mounted) return;
    await Future.wait([
      fetchDataCompany(),
      fetchDataListTablesPrice(empresaid),
      fetchDataTablePriceCompany(empresaid),
      fetchDataTablePriceName(),
      fetchDataTablePrice(empresaid)
    ]);

    await getPermissions();
    await fetchDataOrders(flagFilter: flagFilter);

    //await Future.wait([fetchDataCliente2()]);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading =
          true; // Define isLoading como true para mostrar o indicador de carregamento
    });
    await loadData();
    setState(() {});
    setState(() {
      isLoading = false;
    });
  }

  // Função para salvar o filtro no SharedPreferences
  Future<void> _saveFilter(String filter) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('flagFilter', filter);
  }

  // Função para carregar o filtro do SharedPreferences
  Future<void> _loadSavedFilter() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      flagFilter =
          int.tryParse(sharedPreferences.getString('flagFilter') ?? '0') ?? 0;
      selectedOptionChild = _getFilterText(flagFilter.toString());
    });
  }

  Future<void> _loadSavedFlagPermiteAlterTable() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      flagpermitiralterartabela =
          sharedPreferences.getInt('flagpermitiralterartabela') ?? 0;
    });
  }

  // Função para obter o texto do filtro com base no flagFilter
  String _getFilterText(String filter) {
    switch (filter) {
      case '1':
        return 'Faturados';
      case '0':
        return 'Em aberto';
      default:
        return 'Todos';
    }
  }

  Future<void> fetchDataOrders({bool? ascending, int? flagFilter}) async {
    final listOrdersOff = await recuperarListaPedido();
    if (!mounted) return;
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      var mergedList = mergeListsByKey(
        [], // priority: finalized orders override
        listOrdersOff.map((e) => e.toJson()).toList(),
        [],
        'local_id',
      );
      List<OrdersEndpoint> mergedOrders =
          mergedList.map((e) => OrdersEndpoint.fromJson(e)).toList();
      if (flagFilter != null && flagFilter != 2) {
        var filteredOrders = mergedOrders
            .where((order) => order.flagprocessado == flagFilter)
            .toList();
        setState(() {
          orders = filteredOrders;
        });
      } else {
        setState(() {
          orders = mergedOrders;
        });
      }
      orders.sort((a, b) => b.datahora.compareTo(a.datahora));

      //await salvarListaPedido(mergedList);
    } else {
      if (!mounted) return;
      List<OrdersEndpoint>? fetchData = await DataServiceOrders.fetchDataOrders(
          context, urlBasic, usuarioId, token,
          ascending: ascending);
      if (!mounted) return;
      final listOrdersOff = await recuperarListaPedido();
      final onlineMap = fetchData?.map((e) {
        final json = e.toJson();
        json['flag_sync'] != 0;
        return json;
      }).toList();

      final offlineMap = listOrdersOff
          .where((e) => e.flagSync == 0)
          .map((e) => e.toJson())
          .toList();

      var mergedList = mergeListsByKey(
        onlineMap ?? [],
        offlineMap,
        [],
        'local_id', // ou 'pedido_id'
      );

      await salvarListaPedido(mergedList);

      if (flagFilter != null && flagFilter != 2) {
        mergedList = mergedList
            .where((order) => order['flagprocessado'] == flagFilter)
            .toList();
        var filteredOrders = mergedList
            .where((order) => order['flagprocessado'] == flagFilter)
            .toList();
        // mergedList.map((e) => OrdersEndpoint.fromJson(e)).toList();
        setState(() {
          orders =
              filteredOrders.map((e) => OrdersEndpoint.fromJson(e)).toList();
        });
      } else {
        setState(() {
          orders = mergedList.map((e) => OrdersEndpoint.fromJson(e)).toList();
        });
      }
      orders.sort((a, b) => b.datahora.compareTo(a.datahora));
      return;
    }
  }

  Future<void> fetchDataOrdersDetails2(String prevendaId) async {
    if (!mounted) return;
    final data = await DataServiceOrdersDetails2.fetchDataOrdersDetails2(
        context, urlBasic, prevendaId);
    if (!mounted) return;
    setState(() {
      pessoanome = data['pessoa_nome'].toString();
      cpfcnpj = data['cpfcnpj'].toString();
      telefone = data['telefone'].toString();
      codigoproduto = data['codigo'].toString();
    });
  }

  Future<void> fetchDataCliente2() async {
    if (!mounted) return;
    final data = await DataServiceCliente2.fetchDataCliente2(
        urlBasic, _cpfcontroller.text, token);
    if (!mounted) return;
    setState(() {
      pessoaid = data['pessoa_id'].toString();
      nome = data['nome'].toString();
      cpfcliente = data['cpf'].toString();
      telefone = data['telefone'].toString();
      endereco = data['endereco'].toString();
      enderecobairro = data['enderecobairro'].toString();
      endereconumero = data['endereconumero'].toString();
      enderecocomplemento = data['enderecocomplemento'].toString();
      enderecocep = data['enderecocep'].toString();
      enderecocidade = data['enderecocidade'].toString();
      uf = data['uf'].toString();
      codigo = data['codigo'].toString();
    });
  }

  late BuildContext modalContext;

  void openModal(BuildContext context) async {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          height: Responsive.h(context, 200),
          child: PopScope(
            canPop: false,
            // onPopInvokedWithResult: (didPop, result) => closeModal(),
            child: Container(
              //Tamanho e espaçamento interno do modal
              height: Responsive.h(context, 300),
              margin: EdgeInsets.only(
                  left: Responsive.h(context, 12),
                  right: Responsive.h(context, 12)),
              padding: EdgeInsets.all(Responsive.h(context, 12)),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Responsive.r(context, 10))),
              child: Column(
                //Conteúdo interno do modal
                children: [
                  Row(
                    children: [
                      Text(
                        'Deseja sair da aplicação?',
                        style: TextStyle(
                          fontSize: Responsive.h(context, 15),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Responsive.h(context, 30),
                  ),
                  Row(
                    //Espaçamento entre os Buttons
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //Buttom de sair
                      TextButton(
                        onPressed: () async {
                          _sair();
                        },
                        child: Container(
                          width: Responsive.w(context, 100),
                          // height: Style.ButtonExitHeight(context),
                          padding: EdgeInsets.all(Responsive.h(context, 8)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Responsive.r(context, 10)),
                              color: ColorsApp.errorColor),
                          child: Text(
                            'Sair',
                            style: TextStyle(
                              color: ColorsApp.tertiaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.h(context, 10),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      //Buttom para fechar o modal
                      TextButton(
                        onPressed: () {
                          _closeModal();
                        },
                        child: Container(
                          padding: EdgeInsets.all(Responsive.h(context, 8)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Responsive.r(context, 10)),
                            border: Border.all(
                                width: 2,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.h(context, 10),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void closeModal() {
    //Função para fechar o modal
    Navigator.of(modalContext).pop();
  }

  void _sair() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }

  Future<void> fetchDataTablePriceCompany(String empresaId) async {
    if (!mounted) return; // proteção inicial
    final fetchedDataTablePriceCompany =
        await DataServiceTablePrice.fetchDataTablePrice(
            context, urlBasic, empresaId);
    if (!mounted) return; // widget pode ter sido descartado durante o await
    if (fetchedDataTablePriceCompany != null) {
      setState(() {
        tabelaprecoIdCompany =
            fetchedDataTablePriceCompany['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataTablePriceName() async {
    if (!mounted) return; // proteção antes do await
    final fetchedDataTablePriceName =
        await DataServiceTablePriceName.fetchDataTablePriceName(
            context, urlBasic, tabelaprecoIdCompany);
    if (!mounted) return; // widget pode ter sido desmontado durante o await
    final hasInternet = await hasInternetConnection();
    if (fetchedDataTablePriceName != null && hasInternet) {
      setState(() {
        tableprice = fetchedDataTablePriceName['nome'] ?? '';
      });
    }
  }

  Future<void> fetchDataTablePriceId() async {
    if (!mounted) return;
    Map<String, dynamic>? fetchedDataTablePriceId =
        await DataServiceTablePriceId.fetchDataTablePriceId(
            context, urlBasic, tableprice);
    if (!mounted) return;
    if (fetchedDataTablePriceId != null) {
      setState(() {
        tabelaprecoId = fetchedDataTablePriceId['tabelapreco_id'] ?? '';
      });
    }
  }

  Future<void> fetchDataCompany({bool? ascending}) async {
    final hasInternet = await hasInternetConnection();
    if (!mounted) return;
    if (!hasInternet) {
      final listCompanyOff = await recuperarListaEmpresa();
      final listTablePricesOff = await recuperarListaTabPreco();
      for (var companys in listCompanyOff) {
        setState(() {
          tablesPrice = listTablePricesOff
              .where((e) => e.tabelaprecoId == companys.tabelaprecoId)
              .toList();
          tableprice =
              tablesPrice.isNotEmpty ? tablesPrice.first.nome.toString() : '';
        });
      }
      setState(() {
        company = listCompanyOff;
      });
      if (empresaid.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          empresaNome = company.first.empresaNome.toString();
          empresaCodigo = company.first.empresaCodigo.toString();
          flagObrigarVendedor = company.first.flagobrigarvendedor ?? 0;
          flagObrigarCliente = company.first.flagobrigarcliente ?? 0;
          flagObrigarExpedicao = company.first.flagobrigarexpedicao ?? 0;
        });
      }
    } else {
      List<CompanyList>? fetchedData =
          await DataServiceCompany.fetchDataCompany(
        context,
        urlBasic,
        empresaid,
      );

      if (fetchedData != null) {
        final listaMap = fetchedData.map((e) => e.toJson()).toList();
        await salvarListaEmpresa(listaMap);
        if (!mounted) return;
        setState(() {
          company = fetchedData;
        });
        if (empresaid.isNotEmpty) {
          if (!mounted) return;
          setState(() {
            empresaNome = company.first.empresaNome.toString();
            empresaCodigo = company.first.empresaCodigo.toString();
            flagObrigarVendedor = company.first.flagobrigarvendedor ?? 0;
            flagObrigarCliente = company.first.flagobrigarcliente ?? 0;
            flagObrigarExpedicao = company.first.flagobrigarexpedicao ?? 0;
          });
        }
      }
    }
  }

  Future<void> fetchDataTablePrice(String empresaId) async {
    if (!mounted) return;
    Map<dynamic, dynamic>? fetchedDataTablePrice =
        await DataServiceAlterTableEndpoint.fetchDataAlterTableEndpoint(
            context, urlBasic, empresaId);
    if (!mounted) return;
    if (fetchedDataTablePrice != null) {
      setState(() {
        flagpermitiralterartabela =
            fetchedDataTablePrice['flagpermitiralterartabela'] ?? 0;
      });
    }
  }

  Future<void> fetchDataListTablesPrice(String empresaId) async {
    if (!mounted) return;
    final hasInternet = await hasInternetConnection();
    if (!mounted) return;
    if (!hasInternet) {
      final listTablePricesOff = await recuperarListaTabPreco();
      setState(() {
        flagpermitiralterartabela = 1;
        tablesPrice = listTablePricesOff;
      });
    } else {
      List<ListTablePrices>? fetchedData =
          await DataServiceListTablePrices.fetchDataListTablePrices(
              context, urlBasic, empresaId, token);
      if (fetchedData != null) {
        final listaMap = fetchedData.map((e) => e.toJson()).toList();
        await salvarListaTabPreco(listaMap);
        setState(() {
          tablesPrice = fetchedData;
        });
      }
    }
  }

  List<PopupMenuItem<String>> buildMenuItemsTPrice(
      List<ListTablePrices> tablesPrice) {
    List<PopupMenuItem<String>> dynamicItems = tablesPrice.map((tables) {
      return PopupMenuItem<String>(
        value: tables.tabelaprecoId,
        key: Key(tables.nome.toString()),
        child: Text(
          (tables.nome).toString(),
          style: TextStyle(
            fontSize: Responsive.h(context, 10),
          ),
        ),
      );
    }).toList();

    return dynamicItems;
  }

  List<PopupMenuItem<String>> buildMenuItemsCompany(
      List<CompanyList> companyList) {
    List<PopupMenuItem<String>> dynamicItems = companyList.map((companys) {
      return PopupMenuItem<String>(
        value: companys.empresaId,
        key: Key(companys.empresaNome.toString()),
        child: Text(
          ('${companys.empresaCodigo} - ${companys.empresaNome}').toString(),
          style: TextStyle(
            fontSize: Responsive.h(context, 10),
          ),
        ),
      );
    }).toList();

    const PopupMenuDivider();

    return dynamicItems;
  }

  Future<void> clearCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool('editarPrevenda', false);
    await sharedPreferences.setBool('aplicarDesconto', false);
    await sharedPreferences.setBool('cadastrarCliente', false);
    await sharedPreferences.setBool('editarCliente', false);
    await sharedPreferences.setBool('criarPedido', false);
    await sharedPreferences.setBool('pedidoEstoqueNegativo', false);
    await sharedPreferences.setBool('faturarPedidoEstoqueNegativo', false);
  }

  Future<void> getPermissions() async {
    try {
      var rawQuery =
          '''usuario%20u%20LEFT%20JOIN%20usuario%20uu%20ON%20u.perfil_id%20=%20uu.usuario_id%20WHERE%20u.usuario_id%20=%20'$usuarioId'/''';
      var urlGet = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
      var response = await http.get(urlGet, headers: {
        // 'auth-token': token,
        'Accept': 'text/html'
      });
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var dataMap = jsonResponse['data'] as Map<String, dynamic>;
        if (dataMap.isNotEmpty) {
          var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica

          var userList = dataMap[dynamicKey] as List;
          if (userList.isNotEmpty) {
            var user = userList.first;
            setState(() {
              perfilUsuario = user['nome_1'] ?? '';
              descontoMaximoPermitido = double.parse(
                  user['descontomaximopermitido']?.toString() ?? '0');
              perfilId = user['perfil_id']?.toString() ?? usuarioId;
              flagPrivilegiado = user['flagprivilegiado'] ?? 0;
            });
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setInt(
                'flagprivilegiado', flagPrivilegiado);
          } else {
            log('Nenhum item encontrado na lista.');
          }
          try {
            var rawQuery =
                '''permissao%20p%20WHERE%20p.usuario_id%20=%20'$perfilId'/''';
            var urlGet = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
            var response = await http.get(urlGet, headers: {
              // 'auth-token': token,
              'Accept': 'text/html'
            });
            if (response.statusCode == 200) {
              var jsonResponse = jsonDecode(response.body);
              var dataMap = jsonResponse['data'] as Map<String, dynamic>;
              if (dataMap.isNotEmpty) {
                var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica
                var dataList = dataMap[dynamicKey] as List;
                var listPermissoes = dataList.toList();
                // bool criarPrevenda = listPermissoes.any((item) {
                //   return item['formname']?.toString() == '4008' &&
                //       item['compname']?.toString() == 'actNovo' &&
                //       item['flag'] == 1;
                // });
                bool editarPrevenda = listPermissoes.any((item) {
                  return item['formname']?.toString() == '4008' &&
                      item['compname']?.toString() == 'actEditar' &&
                      item['flag'] == 1;
                });
                bool criarPedido = listPermissoes.any((item) {
                  return item['formname']?.toString() == '4002' &&
                      item['compname']?.toString() == 'actNovo' &&
                      item['flag'] == 1;
                });
                bool aplicarDesconto = listPermissoes.any((item) {
                  return item['formname']?.toString() == 'frmPrincipalImanager2' &&
                      item['compname']?.toString() ==
                          'actIdeiaPDVDescontoTotal' &&
                      item['flag'] == 1;
                });
                bool cadastrarCliente = listPermissoes.any((item) {
                  return item['formname']?.toString() == '1001' &&
                      item['compname']?.toString() == 'actNovo' &&
                      item['flag'] == 1;
                });
                bool editarCliente = listPermissoes.any((item) {
                  return item['formname']?.toString() == '1001' &&
                      item['compname']?.toString() == 'actEditar' &&
                      item['flag'] == 1;
                });
                bool pedidoEstoqueNegativo = listPermissoes.any((item) {
                  return item['formname']?.toString() == '4002' &&
                      item['compname']?.toString() ==
                          'actPedidoEstoqueNegativo' &&
                      item['flag'] == 1;
                });
                bool faturarPedidoEstoqueNegativo = listPermissoes.any((item) {
                  return item['formname']?.toString() == '4002' &&
                      item['compname']?.toString() ==
                          'actFaturarPedidoEstoqueNegativo' &&
                      item['flag'] == 1;
                });
                bool acessarPedidosUsuarios = listPermissoes.any((item) {
                  return item['formname']?.toString() == '4002' &&
                      item['compname']?.toString() ==
                          'actAcessarPedidosUsuarios' &&
                      item['flag'] == 1;
                });
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                // if (criarPrevenda) {
                //   setState(() {
                //     permNovaPrevenda = criarPrevenda;
                //   });
                //   await sharedPreferences.setBool(
                //       'criarPrevenda', criarPrevenda);
                // }
                if (editarPrevenda) {
                  setState(() {
                    permEditarPrevenda = editarPrevenda;
                  });
                  await sharedPreferences.setBool(
                      'editarPrevenda', editarPrevenda);
                }
                if (criarPedido) {
                  await sharedPreferences.setBool('criarPedido', criarPedido);
                }
                if (aplicarDesconto) {
                  await sharedPreferences.setBool(
                      'aplicarDesconto', aplicarDesconto);
                  await sharedPreferences.setDouble(
                      'descontomaximopermitido', descontoMaximoPermitido);
                }
                if (cadastrarCliente) {
                  await sharedPreferences.setBool(
                      'cadastrarCliente', cadastrarCliente);
                }
                if (editarCliente) {
                  await sharedPreferences.setBool(
                      'editarCliente', editarCliente);
                }
                if (pedidoEstoqueNegativo) {
                  await sharedPreferences.setBool(
                      'pedidoEstoqueNegativo', pedidoEstoqueNegativo);
                }
                if (faturarPedidoEstoqueNegativo) {
                  await sharedPreferences.setBool(
                      'faturarPedidoEstoqueNegativo',
                      faturarPedidoEstoqueNegativo);
                }
                if (acessarPedidosUsuarios) {
                  await sharedPreferences.setBool(
                      'actAcessarPedidosUsuarios', acessarPedidosUsuarios);
                } else {
                  await sharedPreferences.setBool(
                      'actAcessarPedidosUsuarios', acessarPedidosUsuarios);
                }
              }
            }
          } catch (e) {
            log('Erro no endpoint permissoes: $e');
          }
        }
      } else {
        log('Erro na requisição ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Erro durante a requisição getPermissions $e');
    }
  }

  String getUnmaskedText(String maskedText) {
    // Remove todos os caracteres não numéricos
    return maskedText.replaceAll(RegExp(r'\D'), '');
  }

  List<dynamic> clienteFiltrado = [];

  Future<void> searchClient() async {
    try {
      var urlGet = Uri.parse(
          "$urlBasic/ideia/core/getdata/(SELECT%20p.pessoa_id,%20p.nome,%20p.telefone,%20p.cpf,%20p.cnpj,%20p.endereco,%20p.enderecocep,%20p.uf,%20p.enderecobairro,%20p.endereconumero,%20p.enderecocomplemento,%20p.emailcontato,%20c.nome%20AS%20enderecocidade%20FROM%20pessoa%20p%20LEFT%20JOIN%20cidade%20c%20ON%20c.cidade_id%20=%20p.cidade_id%20WHERE%20(p.cpf%20LIKE%20'%25${clientcontroller.text}%25'%20OR%20p.cnpj%20LIKE%20'%25${clientcontroller.text}%25'%20OR%20p.nome%20like%20'%25${clientcontroller.text}%25'%20OR%20p.telefone%20like%20'%25${clientcontroller.text}%25'%20OR%20p.emailcontato%20like%20'%25${clientcontroller.text}%25'))%20as%20p/");
      var response = await http.get(urlGet, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var dynamicKey = jsonData['data'].keys.first;
        var dataList = jsonData['data'][dynamicKey];

        setState(() {
          clienteFiltrado = dataList;
        });
        modalclientList();
      } else {
        log('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Erro na requisição searchCompany: $e');
    }
  }

  modalclientList() {
    showDialog(
      context: context,
      builder: (context) => Modal('Clientes encontrados', [
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: clienteFiltrado.length,
            itemBuilder: (context, index) {
              var cliente = clienteFiltrado[index];
              return ListTile(
                title: Text(
                  cliente['nome'] ?? '',
                  textAlign: TextAlign.center,
                ),
                subtitle: Text(
                    textAlign: TextAlign.center,
                    cliente['cpf'] == null
                        ? cliente['cnpj'] ?? ''
                        : cliente['cpf'] ?? ''),
                onTap: () {
                  setState(() {
                    pessoaid = cliente['pessoa_id'].toString();
                    _cpfcontroller.text = cliente['cpf'] == null
                        ? cliente['cnpj'] ?? ''
                        : cliente['cpf'] ?? '';
                    _telefonecontatocontroller.text = cliente['telefone'] ?? '';
                    _nomecontroller.text = cliente['nome'] ?? '';
                    clientcontroller.text =
                        '${_nomecontroller.text == '' ? '' : _nomecontroller.text}${_cpfcontroller.text == '' ? '' : ' | ${_cpfcontroller.text}'}${_telefonecontatocontroller.text == '' ? '' : ' | ${_telefonecontatocontroller.text}'}';
                    _emailcontroller.text = cliente['emailcontato'] ?? '';
                    _cepcontroller.text = cliente['enderecocep'] ?? '';
                    _logradourocontroller.text = cliente['endereco'] ?? '';
                    _ufcontroller.text = cliente['uf'] ?? '';
                    _bairrocontroller.text = cliente['enderecobairro'] ?? '';
                    _cidadecontroller.text = cliente['enderecocidade'] ?? '';
                    _numerocontroller.text = cliente['endereconumero'] ?? '';
                    _complementocontroller.text =
                        cliente['enderecocomplemento'] ?? '';
                  });
                  Navigator.of(context).pop();
                },
                shape: const Border(
                    bottom: BorderSide(
                  color: ColorsApp.disabledColor,
                  width: 1,
                  style: BorderStyle.solid,
                )),
              );
            },
          ),
        )
      ]),
    );
  }
}
