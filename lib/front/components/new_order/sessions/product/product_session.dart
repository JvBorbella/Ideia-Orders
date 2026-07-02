import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/customer/send_customer_offline.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/products/add_product.dart';
import 'package:projeto/back/products/rm_product.dart';
import 'package:projeto/back/products/send_products_offline.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/login_config/elements/balancing_button.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/pages/product_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:projeto/back/products/get_image.dart';
import 'package:http/http.dart' as http;

final GlobalKey<ProductSessionState> productKey =
    GlobalKey<ProductSessionState>();

class ProductSession extends StatefulWidget {
  final String? prevendaid,
      pessoaid,
      numpedido,
      pessoanome,
      cpfcnpj,
      telefone,
      cep,
      bairro,
      cidade,
      endereco,
      complemento,
      produtoid,
      prevendaprodutoid,
      nomeproduto,
      codigoproduto,
      imagemurl,
      empresaId,
      empresaCodigo,
      empresaNome,
      tabelaprecoId,
      tabelapreco,
      localId;
  final double? valorunitario,
      valortotalitem,
      valortotal,
      quantidade,
      valordesconto;
  final int? flagObrigarVendedor;
  final int? flagObrigarCliente;
  final int? flagObrigarExpedicao;
  final VoidCallback? onProductRemoved;
  final VoidCallback onProductAdded;

  const ProductSession(
      {super.key,
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
      required this.onProductAdded,
      this.empresaId = '',
      this.empresaCodigo,
      this.empresaNome,
      this.tabelaprecoId = '',
      this.tabelapreco,
      this.valordesconto,
      this.localId,
      this.flagObrigarVendedor,
      this.flagObrigarCliente,
      this.flagObrigarExpedicao});

  @override
  State<ProductSession> createState() => ProductSessionState();
}

class ProductSessionState extends State<ProductSession> {
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  List<OrdersDetailsEndpoint> orders = [];
  List<Map<String, dynamic>> listRemovedsOffline = [];
  bool isLoading = true,
      flagcam = false,
      _scanned = false,
      checkInternet = false,
      desabilitarEnvio = false;

  String urlBasic = '',
      token = '',
      expedicaoId = '',
      expedicaoNome = '',
      expedicaoCodigo = '',
      produtoId = '';

  double totalValue = 0.0;

  List expedition = [];

  TextEditingController valordescontoController = TextEditingController(),
      eanController = TextEditingController(),
      codigoController = TextEditingController(),
      nomeController = TextEditingController(),
      quantidadeController = TextEditingController(),
      nomeExpedicaoController = TextEditingController(),
      valorUnitarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkConection();
      startMonitoring();
    });
    checkConection();
    totalValue =
        widget.valortotal ?? 0.0; // Inicializa com o valor total original
    quantidadeController.text = '1.0';
  }

  void _closeModal() {
    // Função para fechar o modal
    Navigator.of(context).pop();
  }

  // final hasInternet = await hasInternetConnection();

  String substituirVirgulaPorPonto(String texto) {
    return texto.replaceAll(',', '.');
  }

  double converterStringParaDouble(String valorFormatado) {
    // Remove R$, pontos e espaços, troca vírgula por ponto
    String limpandoValor = valorFormatado
        .replaceAll(RegExp(r'[R$\s.]'), '') // Remove R$, . e espaços
        .replaceAll(',', '.'); // Troca vírgula por ponto

    return double.tryParse(limpandoValor) ?? 0.0;
  }

  Future<void> sendDataProducts(String prevendaId, String localId) async {
    await DataServiceSendProductsOff().sendDataProducts(urlBasic, prevendaId,
        localId, widget.empresaId ?? '', widget.tabelaprecoId ?? '', context,
        isBackground: true);
    await DataServiceSendCustomer().sendDataCustomer(context, prevendaId,
        localId, widget.empresaId ?? '', widget.tabelaprecoId ?? '', urlBasic);
    await fetchDataOrders();
    setState(() {
      desabilitarEnvio = true;
    });
  }

  Timer? _connectionTimer;

  Future<void> checkConection() async {
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) async {
        final checkConect = await hasInternetConnection();

        if (!mounted) return;

        setState(() {
          checkInternet = checkConect;
        });
        // checkClientData();
      },
    );
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    super.dispose();
  }

  bool hasInvalidClientData = false, hasProductRemoved = false;

  void startMonitoring() {
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        final internet = await hasInternetConnection();
        final client = await recuperarClientePorLocalId(widget.localId ?? '');
        final removeds = listRemovedsOffline;

        if (!mounted) return;

        setState(() {
          checkInternet = internet;
          hasInvalidClientData = client.contains((e) => e['flag_sync'] == 0);
          hasProductRemoved = removeds.isNotEmpty;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        SizedBox(
          height: Responsive.h(context, 10),
        ),
        const TextTitle(text: 'Produto(s)'),
        SizedBox(
          height: Responsive.h(context, 5),
        ),
        if ((orders.any((order) => order.flagSync == 0) ||
                hasInvalidClientData == true ||
                hasProductRemoved) &&
            checkInternet == true &&
            !desabilitarEnvio)
          InfiniteSwing(
            child: RegisterIconButton(
              text: '',
              color: Theme.of(context).colorScheme.primary,
              width: Responsive.w(context, 100),
              icon: Icons.cloud_upload_rounded,
              onPressed: () => sendDataProducts(
                  widget.prevendaid ?? '', widget.localId ?? ''),
            ),
          ),
        SizedBox(
          height: Responsive.h(context, 5),
        ),
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var qntdController = TextEditingController();
              qntdController.text = orders[index]
                  .quantidade
                  .toString()
                  .replaceAll(RegExp(r'\.0*$'), '');
              return GestureDetector(
                  onLongPress: () {
                    expedicaoId = orders[index].expedicaoId ?? '';

                    if (expedicaoId.isNotEmpty) {
                      final selectedexpedition = expedition.firstWhere(
                        (e) => e['expedicao_id'] == expedicaoId,
                      );

                      expedicaoNome = selectedexpedition['nome'] ?? '';
                      expedicaoCodigo = selectedexpedition['codigo'] ?? '';
                    }
                    showDialog(
                        context: context,
                        builder: (context) =>
                            StatefulBuilder(builder: (context, setModalState) {
                              return Modal(orders[index].nomeproduto, [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: Responsive.h(context, 30),
                                        child: PopupMenuButton<String>(
                                          initialValue:
                                              orders[index].expedicaoId ?? '',
                                          itemBuilder: (BuildContext context) =>
                                              buildMenuItemsexpedition(
                                                  expedition),
                                          onSelected: (value) async {
                                            if (value != '') {
                                              setModalState(() {
                                                expedicaoId = value;
                                                // Busca o nome da empresa correspondente ao ID selecionado
                                                final selectedexpedition =
                                                    expedition.firstWhere(
                                                  (expedition) =>
                                                      expedition[
                                                          'expedicao_id'] ==
                                                      value,
                                                );
                                                expedicaoNome =
                                                    selectedexpedition[
                                                            'nome'] ??
                                                        ''; // Atualiza o nome
                                                expedicaoCodigo =
                                                    selectedexpedition[
                                                            'codigo'] ??
                                                        ''; // Atualiza o nome
                                              });
                                              setState(() {
                                                expedicaoId = value;
                                              });
                                            } else {
                                              setState(() {
                                                expedicaoId =
                                                    orders[index].expedicaoId ??
                                                        '';
                                                expedicaoNome = '';
                                                expedicaoCodigo = '';
                                              });
                                            }
                                          },
                                          child: Text(
                                            expedicaoNome.isEmpty
                                                ? 'Selecione a expedição'
                                                : 'Exped: $expedicaoCodigo - $expedicaoNome',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  Responsive.h(context, 12),
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow
                                                .ellipsis, // corta o texto no limite da largura
                                            softWrap:
                                                true, // permite a quebra de linha conforme necessário
                                          ),
                                        )),
                                  ],
                                ),
                                Input(
                                  text: 'Quantidade',
                                  type: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: qntdController,
                                  onTap: () => qntdController.clear(),
                                ),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                RegisterButton(
                                  text: 'Salvar alterações',
                                  color: ColorsApp.primaryColor,
                                  width: double.maxFinite,
                                  onPressed: () async {
                                    var checkInternet =
                                        await hasInternetConnection();
                                    if (!checkInternet) {
                                      await adicionarProdutoParaRemocao(
                                        orders[index].localId ?? '',
                                        orders[index].prevendaprodutoid,
                                      );

                                      await atualizarValorPedido(
                                        widget.localId ?? '',
                                        (-orders[index].valortotalitem),
                                      );

                                      final bodyMap = {
                                        'local_id': orders[index].localId,
                                        'flag_sync': 0,
                                        'produto_id': '',
                                        // Preserve o prevendaproduto_id do item atual
                                        'prevendaproduto_id': const Uuid().v4(),
                                        'codigoproduto':
                                            orders[index].codigoproduto,
                                        'nomeproduto':
                                            orders[index].nomeproduto,
                                        'nome': expedicaoNome,
                                        'expedicao_id': expedicaoId,
                                        'valorunitario':
                                            orders[index].valorunitario,
                                        'quantidade': double.parse(
                                          qntdController.text.isEmpty
                                              ? orders[index]
                                                  .quantidade
                                                  .toString()
                                              : qntdController.text,
                                        ),
                                        'valortotal': double.parse(
                                              qntdController.text.isEmpty
                                                  ? orders[index]
                                                      .quantidade
                                                      .toString()
                                                  : qntdController.text,
                                            ) *
                                            orders[index].valorunitario,
                                        'ean': eanController.text,
                                      };
                                      await removerItemProduto(
                                          orders[index].prevendaprodutoid,
                                          widget.localId ?? '');
                                      await adicionarItemProduto(bodyMap);
                                      // await atualizarItem(
                                      //     orders[index].prevendaprodutoid,
                                      //     orders[index].localId ?? '',
                                      //     qntdController.text.isEmpty
                                      //         ? orders[index]
                                      //             .quantidade
                                      //             .toString()
                                      //         : qntdController.text,
                                      //     expedicaoId,
                                      //     expedicaoNome);
                                      await atualizarValorPedido(
                                          widget.localId ?? '',
                                          double.parse(
                                                qntdController.text.isEmpty
                                                    ? orders[index]
                                                        .quantidade
                                                        .toString()
                                                    : qntdController.text,
                                              ) *
                                              orders[index].valorunitario);
                                      setState(() {
                                        totalValue += double.parse(
                                              qntdController.text.isEmpty
                                                  ? orders[index]
                                                      .quantidade
                                                      .toString()
                                                  : qntdController.text,
                                            ) *
                                            orders[index].valorunitario;
                                        // orders.removeAt(index);
                                      });
                                      await fetchDataOrders();
                                    } else {
                                      await DataServiceRmProduct.sendDataOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          widget.prevendaid ?? '',
                                          orders[index].prevendaprodutoid);
                                      await DataServiceAddProduct.sendDataOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          widget.prevendaid ?? '',
                                          widget.empresaId ?? '',
                                          orders[index].produtoid,
                                          '',
                                          qntdController.text.isEmpty
                                              ? orders[index]
                                                  .quantidade
                                                  .toString()
                                              : qntdController.text,
                                          orders[index].flagunidadefracionada,
                                          orders[index].flagservico,
                                          expedicaoId);
                                      await fetchDataOrders();
                                      setState(() {
                                        totalValue = calculateTotal();
                                      });
                                    }
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                            }));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: Responsive.h(context, 2),
                      top: Responsive.h(context, 5),
                      bottom: Responsive.h(context, 5),
                    ),
                    decoration: BoxDecoration(
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
                            SizedBox(
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      if (orders[index].imagem == '')
                                        Icon(
                                          Symbols.hide_image_rounded,
                                          size: Responsive.h(context, 50),
                                        )
                                      else
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            child: TelaExibicaoImagem(
                                              url: urlBasic,
                                              imagem: orders[index].imagem,
                                            )),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Responsive.h(context, 10),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: Responsive.w(context, 130),
                                            child: Text(
                                              orders[index].nomeproduto.isEmpty
                                                  ? ''
                                                  : orders[index].nomeproduto,
                                              overflow: TextOverflow.clip,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontSize:
                                                      Responsive.h(context, 10),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            orders[index].codigoproduto.isEmpty
                                                ? ''
                                                : '${orders[index].codigoproduto} | Estq: ${orders[index].estoqueinicial.toString().replaceAll(RegExp(r'\.0*$'), '')}',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.h(context, 10),
                                              color: ColorsApp.quarantineColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (orders[index]
                                          .nomeexpedicao
                                          .isNotEmpty)
                                        Row(
                                          children: [
                                            Text(
                                              'Exped: ${orders[index].nomeexpedicao}',
                                              style: TextStyle(
                                                fontSize:
                                                    Responsive.h(context, 10),
                                                color:
                                                    ColorsApp.quarantineColor,
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
                            SizedBox(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          if (orders[index].flagSync == 0)
                                            Icon(
                                              Icons.cloud_off,
                                              color: Colors.orange,
                                              size: Responsive.h(context, 15),
                                            ),
                                          if (listRemovedsOffline.any(
                                              (removed) =>
                                                  removed[
                                                      'prevendaproduto_id'] ==
                                                  orders[index]
                                                      .prevendaprodutoid))
                                            Icon(
                                              Icons.delete_outline_rounded,
                                              color: ColorsApp.errorColor,
                                              size: Responsive.h(context, 15),
                                            ),
                                          Text(
                                            currencyFormat
                                                .format(
                                                    orders[index].valorunitario)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    Responsive.h(context, 12),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          Text(
                                            ' x ${orders[index].quantidade.toString().replaceAll(RegExp(r'\.0*$'), '')}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Responsive.h(context, 12),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Subtotal - ${currencyFormat.format(orders[index].valortotalitem)}',
                                            style: TextStyle(
                                                fontSize:
                                                    Responsive.h(context, 10),
                                                color: ColorsApp.warningColor),
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
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: Responsive.w(
                                                        context, 200),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            //width:double.maxFinite,
                                                            child: Text(
                                                              'Deseja remover este item?',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Responsive.h(
                                                                          context,
                                                                          15),
                                                                  color: ColorsApp
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              softWrap: true,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: Responsive.h(
                                                            context, 30),
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
                                                              final checkInternet =
                                                                  await hasInternetConnection();
                                                              if (!checkInternet) {
                                                                // Marca este item para remoção futura no servidor
                                                                await adicionarProdutoParaRemocao(
                                                                  widget.localId ??
                                                                      '',
                                                                  orders[index]
                                                                      .prevendaprodutoid,
                                                                );

                                                                // Atualiza pedido e lista locais normalmente
                                                                await atualizarValorPedido(
                                                                    widget.localId ??
                                                                        '',
                                                                    (-orders[
                                                                            index]
                                                                        .valortotalitem));
                                                                await removerItemProduto(
                                                                    orders[index]
                                                                        .prevendaprodutoid,
                                                                    widget.localId ??
                                                                        '');
                                                                setState(() {
                                                                  orders
                                                                      .removeAt(
                                                                          index);
                                                                  totalValue =
                                                                      calculateTotal();
                                                                });
                                                                _closeModal();
                                                                fetchDataOrders();
                                                              } else {
                                                                // (mantém o bloco online exatamente como já está hoje)
                                                                await DataServiceRmProduct.sendDataOrder(
                                                                    context,
                                                                    urlBasic,
                                                                    token,
                                                                    widget.prevendaid ??
                                                                        '',
                                                                    orders[index]
                                                                        .prevendaprodutoid);
                                                                await removerItemProduto(
                                                                    orders[index]
                                                                        .prevendaprodutoid,
                                                                    widget.localId ??
                                                                        '');
                                                                _closeModal();

                                                                setState(() {
                                                                  orders
                                                                      .removeAt(
                                                                          index);
                                                                  totalValue =
                                                                      calculateTotal();
                                                                });

                                                                if (orders
                                                                    .isEmpty) {
                                                                  //setState(() {});
                                                                  if (widget
                                                                          .onProductRemoved !=
                                                                      null) {
                                                                    widget
                                                                        .onProductRemoved!();
                                                                  }
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              width:
                                                                  Responsive.w(
                                                                      context,
                                                                      100),
                                                              padding: EdgeInsets
                                                                  .all(Responsive
                                                                      .h(context,
                                                                          8)),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(
                                                                      Responsive.r(
                                                                          context,
                                                                          10)),
                                                                  color: ColorsApp
                                                                      .errorColor),
                                                              child: Text(
                                                                'Remover',
                                                                style:
                                                                    TextStyle(
                                                                  color: ColorsApp
                                                                      .tertiaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      Responsive.h(
                                                                          context,
                                                                          10),
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                          //Buttom para fechar o modal
                                                          TextButton(
                                                            onPressed: () {
                                                              _closeModal();
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .all(Responsive
                                                                      .h(context,
                                                                          8)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Responsive.r(
                                                                            context,
                                                                            10)),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onSecondary),
                                                                color: Colors
                                                                    .transparent,
                                                              ),
                                                              child: Text(
                                                                'Cancelar',
                                                                style:
                                                                    TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .onSecondary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      Responsive.h(
                                                                          context,
                                                                          10),
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
                                          color: ColorsApp.errorColor,
                                          size: Responsive.h(context, 20),
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
                  ));
            }),
        SizedBox(
          height: Responsive.h(context, 10),
        ),
        Center(
          child: Text(
            'Total - ${currencyFormat.format(totalValue).toString()}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: Responsive.h(context, 15),
                fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.valordesconto != 0.0)
          Center(
            child: Text(
              'Desc. Total - ${currencyFormat.format(double.parse(widget.valordesconto.toString())).toString()}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: Responsive.h(context, 15),
                  fontWeight: FontWeight.bold),
            ),
          ),
        SizedBox(
          height: Responsive.h(context, 10),
        ),
        RegisterIconButton(
            text: 'Adicionar Produto',
            color: Theme.of(context).colorScheme.primary,
            width: Responsive.h(context, 150),
            icon: Icons.add_circle,
            onPressed: () async {
              final checkInternet = await hasInternetConnection();
              if (!checkInternet) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                        builder: (context, setModalState) => Modal(
                              'Adição de Produto',
                              [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: Responsive.h(context, 20),
                                      child: PopupMenuButton<String>(
                                        itemBuilder: (BuildContext context) =>
                                            buildMenuItemsexpedition(
                                                expedition),
                                        onSelected: (value) async {
                                          if (value != '') {
                                            setModalState(() {
                                              expedicaoId = value;
                                              // Busca o nome da empresa correspondente ao ID selecionado
                                              final selectedexpedition =
                                                  expedition.firstWhere(
                                                (expedition) =>
                                                    expedition[
                                                        'expedicao_id'] ==
                                                    value,
                                              );
                                              expedicaoNome =
                                                  selectedexpedition['nome'] ??
                                                      ''; // Atualiza o nome
                                              expedicaoCodigo =
                                                  selectedexpedition[
                                                          'codigo'] ??
                                                      ''; // Atualiza o nome
                                            });
                                            setState(() {
                                              expedicaoId = value;
                                            });
                                          } else {
                                            setState(() {
                                              expedicaoId = '';
                                              expedicaoNome = '';
                                              expedicaoCodigo = '';
                                            });
                                          }
                                        },
                                        child: SizedBox(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondary,
                                                  size:
                                                      Responsive.h(context, 20),
                                                ),
                                                SizedBox(
                                                  child: Text(
                                                    expedicaoNome.isEmpty
                                                        ? 'Expedição'
                                                        : '$expedicaoCodigo - $expedicaoNome',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSecondary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Responsive.h(
                                                          context, 12),
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
                                    ),
                                    IconButton.outlined(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        style: ButtonStyle(
                                            side: WidgetStatePropertyAll(
                                                BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary,
                                                    width: 2.0))),
                                        onPressed: () {
                                          setModalState(() {
                                            flagcam = !flagcam;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          size: Responsive.h(context, 20),
                                        ))
                                  ],
                                ),
                                if (flagcam)
                                  Container(
                                    padding: EdgeInsets.all(
                                        Responsive.h(context, 8)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: Responsive.h(context, 2)),
                                          borderRadius: BorderRadius.circular(
                                              Responsive.h(context, 5))),
                                      height: Responsive.h(context, 200),
                                      child: MobileScanner(
                                        //allowDuplicates: false,
                                        onDetect: (barcodeCapture) {
                                          final String? code = barcodeCapture
                                              .barcodes.first.displayValue;
                                          if (code != null && !_scanned) {
                                            setState(() {
                                              codigoController.text = code;
                                              eanController.text = code;
                                              _scanned =
                                                  false; // evita múltiplas leituras
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                Input(
                                    text: 'EAN do produto',
                                    controller: eanController,
                                    type: TextInputType.text,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                Input(
                                    text: 'Código do produto',
                                    controller: codigoController,
                                    type: TextInputType.text,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                Input(
                                    text: 'Nome do produto',
                                    controller: nomeController,
                                    type: TextInputType.text,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                Input(
                                    text: 'Quantidade*',
                                    controller: quantidadeController,
                                    type: TextInputType.number,
                                    textAlign: TextAlign.center),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                Input(
                                  text: 'Valor Unitário*',
                                  controller: valorUnitarioController,
                                  type: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    TextInputFormatter.withFunction(
                                        (oldValue, newValue) {
                                      try {
                                        if (newValue.text.isEmpty) {
                                          return newValue;
                                        }
                                        final number = double.parse(
                                                newValue.text.replaceAll(
                                                    RegExp(r'[^0-9]'), '')) /
                                            100;
                                        final formatted =
                                            currencyFormat.format(number);
                                        return TextEditingValue(
                                          text: formatted,
                                          selection: TextSelection.collapsed(
                                              offset: formatted.length),
                                        );
                                      } catch (e) {
                                        return oldValue;
                                      }
                                    }),
                                  ],
                                ),
                                SizedBox(
                                  height: Responsive.h(context, 10),
                                ),
                                RegisterIconButton(
                                  text: 'Salvar produto offline',
                                  color: Theme.of(context).colorScheme.primary,
                                  width: Responsive.w(context, 150),
                                  icon: Icons.cloud_off_outlined,
                                  onPressed: () async {
                                    if (valorUnitarioController.text.isEmpty ||
                                        quantidadeController.text.isEmpty) {
                                      return showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          content: const Text(
                                            'Por favor, preencha os campos obrigatórios(*) para que tenhamos uma base do valor total do pedido',
                                            overflow: TextOverflow.clip,
                                          ),
                                          actions: [
                                            ButtonConfig(
                                              text: 'Ok',
                                              height: Responsive.h(context, 15),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            )
                                          ],
                                        ),
                                      );
                                    } else {
                                      final uuid = const Uuid().v4();
                                      final bodyMap = {
                                        'local_id': widget.localId,
                                        'flag_sync': 0,
                                        'produto_id': '',
                                        'prevendaproduto_id': uuid,
                                        'codigoproduto': codigoController.text,
                                        'nomeproduto': nomeController.text,
                                        'nome': expedicaoNome,
                                        'expedicao_id': expedicaoId,
                                        'valorunitario':
                                            converterStringParaDouble(
                                                valorUnitarioController.text),
                                        'quantidade': double.parse(
                                            quantidadeController.text),
                                        'valortotal': double.parse(
                                                quantidadeController.text) *
                                            converterStringParaDouble(
                                                valorUnitarioController.text),
                                        'ean': eanController.text,
                                      };
                                      await adicionarItemProduto(bodyMap);
                                      setState(() {
                                        totalValue += double.parse(
                                                quantidadeController.text) *
                                            converterStringParaDouble(
                                                valorUnitarioController.text);
                                      });
                                      await atualizarValorPedido(
                                          widget.localId ?? '',
                                          double.parse(
                                                  quantidadeController.text) *
                                              converterStringParaDouble(
                                                  valorUnitarioController
                                                      .text));
                                      _closeModal();
                                      fetchDataOrders();
                                      customerKey.currentState?.hasProduct =
                                          true;
                                      widget.onProductAdded();
                                    }
                                  },
                                )
                              ],
                            ));
                  },
                ).then((_) {
                  eanController.clear();
                  codigoController.clear();
                  nomeController.clear();
                  quantidadeController.clear();
                  valorUnitarioController.clear();
                  expedicaoId = '';
                  expedicaoNome = '';
                  expedicaoCodigo = '';
                });
              } else {
                if (widget.tabelaprecoId == null || widget.empresaId == '') {
                  return Message.showReturnOverlay(
                      context,
                      ColorsApp.errorColor,
                      Icons.error,
                      'Selecione e grave uma empresa para adicionar produtos ao pedido.');
                } else if (widget.tabelaprecoId == null ||
                    widget.tabelaprecoId == '') {
                  return Message.showReturnOverlay(
                      context,
                      ColorsApp.errorColor,
                      Icons.error,
                      'Selecione e grave uma tabela de preço para adicionar produtos ao pedido.');
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductList(
                            localId: widget.localId,
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
                            empresaId: widget.empresaId ?? '',
                            empresaCodigo: widget.empresaCodigo ?? '',
                            empresaNome: widget.empresaNome ?? '',
                            valortotal: widget.valortotal ?? 0.0,
                            tabelaprecoId:
                                widget.tabelaprecoId ?? ''.toString(),
                            valordesconto: widget.valordesconto,
                            flagObrigarVendedor: widget.flagObrigarVendedor,
                            flagObrigarCliente: widget.flagObrigarCliente,
                            flagObrigarExpedicao: widget.flagObrigarExpedicao,
                          )));
                }
              }
            }),
      ],
    ));
  }

  double calculateTotal() {
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
    await fetchDataListExpedicao();
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
    final hasInternet = await hasInternetConnection();
    final listOrdersOff =
        await recuperarListaProdutosPedido(widget.localId ?? '');
    final listRemovedsOffline =
        await recuperarProdutosParaRemocao(widget.localId ?? '');

    this.listRemovedsOffline = listRemovedsOffline;
    if (!hasInternet) {
      setState(() {
        orders = listOrdersOff
            .where((e) => e.localId.toString() == widget.localId.toString())
            .toList();
        totalValue = calculateTotal();
        isLoading = false;
      });
    } else {
      List<OrdersDetailsEndpoint>? fetchData =
          await DataServiceOrdersDetails.fetchDataOrdersDetails(context,
              urlBasic, widget.prevendaid ?? '', widget.empresaId ?? '', token);
      if (fetchData != null) {
        final onlineMap = fetchData.map((e) {
          final json = e.toJson();
          json['local_id'] = widget.localId;
          json['flag_sync'] = 1;
          return json;
        }).toList();

        final offlineMap = listOrdersOff
            .where((e) =>
                e.localId.toString() == widget.localId.toString() &&
                e.flagSync == 0)
            .map((e) => e.toJson())
            .toList();

        final mergedList = mergeListsByKey(
          onlineMap,
          offlineMap,
          listRemovedsOffline,
          'prevendaproduto_id',
        );

        //await salvarListaProdutosPedido(mergedList);

        setState(() {
          orders =
              mergedList.map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();
          totalValue = orders.first.valortotalprevenda;
        });
      } else {
        final listOrdersOff =
            await recuperarListaProdutosPedido(widget.localId ?? '');
        setState(() {
          orders = listOrdersOff;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataListExpedicao() async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final listTablePricesOff = await recuperarListaExpedicao();
      setState(() {
        expedition = listTablePricesOff;
      });
    } else {
      try {
        var urlGet = Uri.parse(
            '$urlBasic/ideia/core/getdata/expedicao%20e%20WHERE%20COALESCE(e.flagexcluido,%200)%20<>%201/');
        var response = await http.get(urlGet, headers: {'Accept': 'text/html'});
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          var dynamicKey = jsonData['data'].keys.first;
          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          var data = dataList;
          await salvarListaExpedicao(data);

          setState(() {
            expedition = dataList;
          });
        }
      } catch (e) {
        log('Erro durante a requisição: $e');
      }
    }
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

    return /*staticItems +*/ dynamicItems;
  }
}
