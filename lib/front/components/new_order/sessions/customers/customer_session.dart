import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/company/alter_table_endpoint.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/back/customer/send_customer_offline.dart';
import 'package:projeto/back/orders/finish_order.dart';
import 'package:projeto/back/customer/get_cep.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/customer/new_customer.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';

// Mantido para compatibilidade com ProductSession/ProductList (acoplamento via GlobalKey).

final GlobalKey<CustomerSessionState> customerKey =
    GlobalKey<CustomerSessionState>();

// Mantido também o productKey vindo da página.

class CustomerSession extends StatefulWidget {
  final GlobalKey<ProductSessionState> productKey;
  final String? prevendaid,
      pessoaid,
      vendedorId,
      pessoanome,
      cpfcnpj,
      telefone,
      cep,
      bairro,
      localidade,
      ibge,
      endereco,
      complemento,
      numero,
      cidade,
      uf,
      email,
      numpedido,
      noProduct,
      empresaId,
      empresaCodigo,
      empresaNome,
      tabelaprecoId,
      tabelapreco,
      localId,
      iestadual,
      imunicipal;
  final double? valordesconto, valortotal;
  final Function(String) onCpfAtualizado;
  final Function(String) onTelAtualizado;
  final Function(String) onNomeAtualizado;
  final Function({
    required String empresaId,
    required String empresaCodigo,
    required String empresaNome,
    required String tabelaPrecoId,
    required String tabelaPrecoNome,
    required int flagObrigarVendedor,
    required int flagObrigarCliente,
    required int flagObrigarExpedicao,
  }) onCompanyChanged;
  final int? flagObrigarVendedor;
  final int? flagObrigarCliente;
  final int? flagObrigarExpedicao;

  const CustomerSession(
      {super.key,
      required this.productKey,
      this.prevendaid,
      this.pessoaid,
      this.vendedorId,
      this.pessoanome,
      this.cpfcnpj,
      this.telefone,
      this.cep,
      this.bairro,
      this.localidade,
      this.ibge,
      this.endereco,
      this.complemento,
      this.numero,
      this.cidade,
      this.uf,
      this.numpedido,
      this.noProduct,
      this.email,
      this.valordesconto,
      this.empresaId,
      this.empresaCodigo,
      this.empresaNome,
      this.tabelaprecoId,
      this.tabelapreco,
      this.localId,
      this.iestadual,
      this.imunicipal,
      this.valortotal,
      required this.onCpfAtualizado,
      required this.onTelAtualizado,
      required this.onNomeAtualizado,
      required this.onCompanyChanged,
      this.flagObrigarVendedor,
      this.flagObrigarCliente,
      this.flagObrigarExpedicao});

  @override
  State<CustomerSession> createState() => CustomerSessionState();
}

class CustomerSessionState extends State<CustomerSession> {
  Future<void> saveOrder() async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final bodyMap = {
        'local_id': widget.localId,
        'cpfcnpj': cpfcontroller.text,
        'telefone': _telefonecontatocontroller.text,
        'nome': _nomecontroller.text,
        'email': _emailcontroller.text,
        'vendedor_codigo': vendedorController.text,
        'cep': _cepcontroller.text,
        'endereco': _logradourocontroller.text,
        'uf': _ufcontroller.text,
        'bairro': _bairrocontroller.text,
        'cidade': _cidadecontroller.text,
        'numero': _numerocontroller.text,
        'complemento': _complementocontroller.text,
        'iestadual': _ieController.text,
        'imunicipal': _icController.text,
        'valordesconto': double.parse(
            substituirVirgulaPorPonto(valordescontoController.text))
      };
      if (!mounted) return;
      await adicionarDadosCliente(bodyMap, context);
      setState(() {
        isCustomerSaved = true;
      });
    } else {
      if (!mounted) return;
      await NewCustomer.adjustOrder(
          context,
          urlBasic,
          token,
          _nomecontroller.text,
          cpfcontroller.text,
          _telefonecontatocontroller.text,
          widget.prevendaid ?? '',
          pessoaId,
          vendedorId,
          double.parse(substituirVirgulaPorPonto(valordescontoController.text)),
          empresaid,
          tabelaprecoId);
      setState(() {
        isCustomerSaved = true;
      });
    }
  }

  BuildContext? modalContext;

  String urlBasic = '',
      token = '',
      ibge = '',
      cpf = '',
      tel = '',
      nome = '',
      vendedorId = '',
      empresaCodigo = '',
      empresaNome = '',
      empresaId = '',
      empresaid = '',
      empresaIdUser = '',
      tableprice = '',
      tabelaprecoId = '',
      pessoaId = '';
  //bool permNovoPedido = homeKey.currentState?.permNovoPedido ?? false;
  bool isCheckedCPF = true,
      isLoading = true,
      isLoadingButton = false,
      isLoadingIconButton = false,
      isLoadingSearchCPF = false,
      isLoadingSearchSeller = false,
      isLoadingSearchCEP = false,
      flagGerarPedido = false,
      permEditarPrevenda = false,
      permCadastrarCliente = false,
      permEditarCliente = false,
      permAplicarDesconto = false,
      permNovoPedido = false,
      hasProduct = false,
      isCustomerSaved = true,
      _isListening = false,
      permFaturarPedidoEstoqueNegativo = false;

  double descontoMaximoPermitido = 0.0;

  int flagprivilegiado = 0, flagpermitiralterartabela = 0;

  final _cepcontroller = TextEditingController();
  final _complementocontroller = TextEditingController();
  final _bairrocontroller = TextEditingController();
  final _cidadecontroller = TextEditingController();
  final _numerocontroller = TextEditingController();
  final _localidadecontroller = TextEditingController();
  final _ibgecontroller = TextEditingController();
  final _ufcontroller = TextEditingController();
  final _logradourocontroller = TextEditingController();
  final cpfcontroller = TextEditingController();
  final _nomecontroller = TextEditingController();
  final _telefonecontatocontroller = TextEditingController();
  // final _clientController = TextEditingController();
  final _emailcontroller = TextEditingController();
  final vendedorController = TextEditingController();
  final valordescontoController = TextEditingController();
  final empresaController = TextEditingController();
  final tabelaController = TextEditingController();
  final _ieController = TextEditingController();
  final _icController = TextEditingController();

  List<TextEditingController> get allControllers => [
        _cepcontroller,
        _complementocontroller,
        _bairrocontroller,
        _cidadecontroller,
        _numerocontroller,
        _localidadecontroller,
        _ibgecontroller,
        _ufcontroller,
        _logradourocontroller,
        cpfcontroller,
        _nomecontroller,
        _telefonecontatocontroller,
        _emailcontroller,
        vendedorController,
        valordescontoController,
        empresaController,
        tabelaController,
        _ieController,
        _icController,
      ];

  // final _cpfMaskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telMaskFormatter = MaskTextInputFormatter(mask: '(##) #####-####');
  final _cepMaskFormatter = MaskTextInputFormatter(mask: '#####-###');
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  final pessoaid = String;

  List<OrdersDetailsEndpoint> orders = [];
  List<CompanyList> company = [];
  List<ListTablePrices> tablesPrice = [];
  List<dynamic> clienteFiltrado = [];
  List<dynamic> vendedorFiltrado = [];

  int flagObrigarVendedor = 0, flagObrigarCliente = 0, flagObrigarExpedicao = 0;

  String substituirVirgulaPorPonto(String texto) {
    return texto.replaceAll(',', '.');
  }

  String buttonText = 'Cadastrar Cliente';

  String getUnmaskedText(String maskedText) {
    // Remove todos os caracteres não numéricos
    return maskedText.replaceAll(RegExp(r'\D'), '');
  }

  String joinWithSpace(List<String> parts) {
    final filtered = parts.where((e) => e.trim().isNotEmpty).toList();
    return filtered.join(' | ');
  }

  @override
  void initState() {
    super.initState();
    pessoaId = widget.pessoaid ?? '';
    vendedorId = widget.vendedorId ?? '';
    empresaid = widget.empresaId ?? '';
    tabelaprecoId = widget.tabelaprecoId ?? '';
    flagObrigarVendedor = widget.flagObrigarVendedor ?? 0;
    flagObrigarCliente = widget.flagObrigarCliente ?? 0;
    flagObrigarExpedicao = widget.flagObrigarExpedicao ?? 0;
    loadData();
    _localidadecontroller.text = widget.cidade ?? '';
    _cepcontroller.text = _cepMaskFormatter.maskText(widget.cep ?? '');
    _bairrocontroller.text = widget.bairro.toString();
    _numerocontroller.text = widget.numero ?? '';
    _ibgecontroller.text = widget.ibge.toString();
    _complementocontroller.text = widget.complemento.toString();
    _ufcontroller.text = widget.uf.toString();
    _logradourocontroller.text = widget.endereco.toString();
    _nomecontroller.text = widget.pessoanome ?? '';
    cpfcontroller.text = formatCPFCNPJ(widget.cpfcnpj ?? '');
    _telefonecontatocontroller.text = widget.telefone == 'null'
        ? ''
        : _telMaskFormatter.maskText(widget.telefone ?? '');

    empresaController.text = widget.empresaId != null
        ? '${widget.empresaCodigo} - ${widget.empresaNome}'
        : '';
    tabelaController.text = widget.tabelapreco ?? '';
    _ieController.text = widget.iestadual ?? '';
    _icController.text = widget.imunicipal ?? '';
    tabelaprecoId = widget.tabelaprecoId ?? '';
    pessoaId = widget.pessoaid ?? '';
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
    );

    // se widget.valordesconto vier como número (ex: double)
    if (widget.valordesconto != null && widget.valordesconto != 0.0) {
      final value = double.tryParse(widget.valordesconto.toString()) ?? 0.0;
      valordescontoController.text = formatter.format(value);
    } else {
      valordescontoController.text = '0,00';
    }
    _emailcontroller.text = widget.email ?? '';

    // Se a página foi aberta já marcando que não há produto, inicia como false,
    // senão assume que já existe ao menos um produto associado.
    hasProduct = widget.noProduct != '1';

    for (var controller in allControllers) {
      controller.addListener(() {
        if (_isListening && isCustomerSaved) {
          setState(() {
            isCustomerSaved = false;
          });
        }
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _isListening = true;
      }
    });
  }

  String formatCPFCNPJ(String cpfcnpj) {
    if (cpfcnpj.isNotEmpty) {
      cpfcontroller.text = cpfcnpj.length > 11
          ? MaskTextInputFormatter(mask: '##.###.###/####-##').maskText(cpfcnpj)
          : MaskTextInputFormatter(mask: '###.###.###-##').maskText(cpfcnpj);
      return cpfcontroller.text;
    } else {
      return ''; // Define vazio se não houver CPF ou CNPJ
    }
  }

  // Permite que outros widgets (como ProductSession) informem que
  // um produto foi adicionado offline, sem precisar reconstruir a página.
  void markProductAdded() {
    if (!hasProduct) {
      setState(() {
        hasProduct = true;
      });
    }
  }

  Future<bool> clientData() async {
    List<Map<String, dynamic>> clientRegister = [];

    clientRegister = await recuperarClientePorLocalId(widget.localId ?? '');

    if (clientRegister.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> sendDataClient() async {
    await DataServiceSendCustomer().sendDataCustomer(
        context,
        widget.prevendaid ?? '',
        widget.localId ?? '',
        widget.empresaId ?? '',
        widget.tabelaprecoId ?? '',
        urlBasic);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const TextTitle(text: 'Dados do pedido'),
          Container(
            padding: EdgeInsets.all(Responsive.h(context, 15)),
            child: Column(
              spacing: 20,
              children: [
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (empresaIdUser != '')
                        SizedBox(
                            width: Responsive.w(context, 150),
                            child: InputBlocked(
                              value:
                                  '${widget.empresaCodigo} - ${widget.empresaNome}',
                            ))
                      else
                        SizedBox(
                          width: Responsive.w(context, 150),
                          child: Input(
                              controller: empresaController,
                              text: 'Empresa',
                              type: TextInputType.text,
                              textAlign: TextAlign.left,
                              readOnly: true,
                              iconButton: PopupMenuButton<String>(
                                  itemBuilder: (BuildContext context) =>
                                      buildMenuItemsCompany(company),
                                  onSelected: (value) async {
                                    if (value != '') {
                                      final selectedCompany =
                                          company.firstWhere(
                                        (company) => company.empresaId == value,
                                      );
                                      setState(() {
                                        empresaid = value;
                                        empresaController.text =
                                            '${selectedCompany.empresaCodigo} - ${selectedCompany.empresaNome}';
                                        tabelaprecoId =
                                            selectedCompany.tabelaprecoId ?? '';
                                        flagObrigarVendedor = selectedCompany
                                                .flagobrigarvendedor ??
                                            0;
                                        flagObrigarCliente = selectedCompany
                                                .flagobrigarcliente ??
                                            0;
                                        flagObrigarExpedicao = selectedCompany
                                                .flagobrigarexpedicao ??
                                            0;
                                      });
                                      widget.onCompanyChanged(
                                        empresaId: value,
                                        empresaCodigo:
                                            selectedCompany.empresaCodigo ?? '',
                                        empresaNome:
                                            selectedCompany.empresaNome ?? '',
                                        tabelaPrecoId:
                                            selectedCompany.tabelaprecoId ?? '',
                                        tabelaPrecoNome: '',
                                        flagObrigarVendedor:
                                            flagObrigarVendedor,
                                        flagObrigarCliente: flagObrigarCliente,
                                        flagObrigarExpedicao:
                                            flagObrigarExpedicao,
                                      );

                                      await fetchDataTablePrice(value);
                                      await searchTablePrice(tabelaprecoId);
                                    } else {
                                      setState(() {
                                        empresaid = '';
                                        empresaNome = '';
                                        empresaCodigo = '';
                                      });
                                    }
                                  },
                                  child: const Icon(
                                      Icons.arrow_drop_down_outlined))),
                        ),
                      if (flagpermitiralterartabela != 1)
                        SizedBox(
                            width: Responsive.w(context, 150),
                            child: InputBlocked(
                              value: tabelaController.text,
                            ))
                      else
                        SizedBox(
                          width: Responsive.w(context, 150),
                          child: Input(
                            controller: tabelaController,
                            text: 'Tabela de Preço',
                            type: TextInputType.text,
                            textAlign: TextAlign.left,
                            iconButton: PopupMenuButton<String>(
                                itemBuilder: (BuildContext context) =>
                                    buildMenuItemsTPrice(tablesPrice),
                                onSelected: (value) async {
                                  await DataServiceTablePriceId
                                      .fetchDataTablePriceId(
                                          context, urlBasic, tableprice);
                                  final selectedTBPrice =
                                      tablesPrice.firstWhere(
                                    (table) => table.tabelaprecoId == value,
                                  );
                                  setState(() {
                                    tabelaController.text =
                                        selectedTBPrice.nome ?? '';
                                    tableprice = selectedTBPrice.nome ?? '';
                                    tabelaprecoId = value;
                                    fetchDataTablePriceId();
                                  });
                                },
                                child:
                                    const Icon(Icons.arrow_drop_down_outlined)),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Input(
                    text: 'Pesquise pelo Vendedor',
                    controller: vendedorController,
                    type: TextInputType.text,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.unspecified,
                    isLoadingButton: isLoadingSearchSeller,
                    iconButton: IconButton(
                      icon: const Icon(Icons.person_search),
                      onPressed: () async {
                        setState(() {
                          isLoadingSearchSeller = true;
                        });
                        try {
                          var urlGet = Uri.parse(
                              '''$urlBasic/ideia/core/getdata/pessoa%20p%20WHERE%20p.flagvendedor%20=%201%20AND%20(p.codigo%20LIKE%20'%25${vendedorController.text}%25'%20OR%20p.nome%20LIKE%20'%25${vendedorController.text}%25')/''');
                          var response = await http.get(
                            urlGet,
                            headers: {'Accept': 'text/html'},
                          );
                          if (response.statusCode == 200) {
                            var jsonData = json.decode(response.body);
                            var dynamicKey = jsonData['data'].keys.first;
                            var dataList = jsonData['data'][dynamicKey];

                            vendedorFiltrado = dataList;
                            modalSellerList();
                          } else {
                            Message.showReturnOverlay(
                                context,
                                ColorsApp.errorColor,
                                Icons.error,
                                response.body);
                            log('Erro na requisição: ${response.statusCode}');
                          }
                        } catch (e) {
                          Message.showReturnOverlay(
                              context, ColorsApp.errorColor, Icons.error, '$e');
                          log('Erro ao pesquisar vendedor: $e');
                        }
                        setState(() {
                          isLoadingSearchSeller = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            spacing: 10,
                            children: [
                              Input(
                                text: 'CPF / CNPJ do Cliente',
                                type: TextInputType.text,
                                controller: cpfcontroller,
                                onChanged: (value) {
                                  widget.onCpfAtualizado(value);
                                },
                                inputFormatters: [
                                  CnpjCpfFormatter(
                                    eDocumentType: EDocumentType.BOTH,
                                  )
                                ],
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.unspecified,
                              ),
                              Input(
                                text: 'Telefone',
                                type: TextInputType.text,
                                controller: _telefonecontatocontroller,
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.unspecified,
                                inputFormatters: [
                                  MaskedInputFormatter('(00) 00000-0000')
                                ],
                              ),
                              Input(
                                text: 'Nome do cliente',
                                type: TextInputType.text,
                                controller: _nomecontroller,
                                textAlign: TextAlign.start,
                                textInputAction: TextInputAction.unspecified,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  isLoadingSearchCPF
                                      ? const CircularProgressIndicator()
                                      : Icon(
                                          Icons.person_search,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 50,
                                        ),
                                  Text(
                                    'Buscar cliente',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: Responsive.h(context, 12),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                setState(() {
                                  isLoadingSearchCPF = true;
                                });

                                await searchClient();

                                if (_nomecontroller.text != '') {
                                  setState(() {
                                    buttonText = 'Salvar Edições';
                                  });
                                }

                                setState(() {
                                  cpf = cpfcontroller.text;
                                  tel = _telefonecontatocontroller.text;
                                  nome = _nomecontroller.text;
                                  isLoadingSearchCPF = false;
                                });

                                widget.onCpfAtualizado(cpf);
                                widget.onTelAtualizado(tel);
                                widget.onNomeAtualizado(nome);
                              },
                            )),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Input(
                    text: 'Email do cliente',
                    type: TextInputType.emailAddress,
                    controller: _emailcontroller,
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.unspecified,
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 175),
                            child: Input(
                                controller: _ieController,
                                textAlign: TextAlign.start,
                                text: 'I. Estadual',
                                textInputAction: TextInputAction.unspecified,
                                inputFormatters: [],
                                type: TextInputType.text),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 175),
                            child: Input(
                                controller: _icController,
                                textAlign: TextAlign.start,
                                text: 'I. Municipal',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                    width: Responsive.w(context, 362),
                    child: Input(
                      controller: _cepcontroller,
                      text: 'CEP',
                      type: TextInputType.number,
                      textAlign: TextAlign.start,
                      inputFormatters: [MaskedInputFormatter('00000-000')],
                      isLoadingButton: isLoadingSearchCEP,
                      textInputAction: TextInputAction.unspecified,
                      iconButton: IconButton(
                          onPressed: () async {
                            setState(() {
                              isLoadingSearchCEP = true;
                            });
                            await GetCep.getcep(
                              _cepcontroller.text,
                              _logradourocontroller,
                              //_complementocontroller,
                              _bairrocontroller,
                              _ufcontroller,
                              _localidadecontroller,
                              _ibgecontroller,
                              ibge,
                            );
                            setState(() {
                              isLoadingSearchCEP = false;
                            });
                          },
                          icon: const Icon(Icons.screen_search_desktop_sharp)),
                    )),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 250),
                            child: Input(
                                controller: _logradourocontroller,
                                textAlign: TextAlign.start,
                                text: 'Endereço',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 70),
                            child: Input(
                                controller: _ufcontroller,
                                textAlign: TextAlign.start,
                                text: 'UF',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 140),
                            child: Input(
                                controller: _bairrocontroller,
                                textAlign: TextAlign.start,
                                text: 'Bairro',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 180),
                            child: Input(
                                controller: _localidadecontroller,
                                textAlign: TextAlign.start,
                                text: 'Cidade',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: Responsive.w(context, 362),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 100),
                            child: Input(
                                controller: _numerocontroller,
                                textAlign: TextAlign.start,
                                text: 'Número',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: Responsive.w(context, 215),
                            child: Input(
                                controller: _complementocontroller,
                                textAlign: TextAlign.start,
                                text: 'Complemento',
                                textInputAction: TextInputAction.unspecified,
                                type: TextInputType.text),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          child: RegisterButton(
                            text: buttonText,
                            color: Theme.of(context).colorScheme.primary,
                            width: Responsive.w(context, 150),
                            isLoadingButton: isLoadingButton,
                            onPressed: () async {
                              final checkInternet =
                                  await hasInternetConnection();
                              setState(() {
                                isLoadingButton = true;
                              });
                              if (!checkInternet) {
                                final bodyMap = {
                                  'local_id': widget.localId,
                                  'cpfcnpj': cpfcontroller.text,
                                  'telefone': _telefonecontatocontroller.text,
                                  'nome': _nomecontroller.text,
                                  'email': _emailcontroller.text,
                                  'vendedor_codigo': vendedorController.text,
                                  'cep': _cepcontroller.text,
                                  'endereco': _logradourocontroller.text,
                                  'uf': _ufcontroller.text,
                                  'ie': _ieController.text,
                                  'im': _icController.text,
                                  'bairro': _bairrocontroller.text,
                                  'cidade': _cidadecontroller.text,
                                  'numero': _numerocontroller.text,
                                  'complemento': _complementocontroller.text,
                                  'valordesconto': double.parse(
                                      substituirVirgulaPorPonto(
                                          valordescontoController.text))
                                };
                                await adicionarDadosCliente(bodyMap, context);
                              } else {
                                await NewCustomer.getCostumer(
                                    context,
                                    urlBasic,
                                    token,
                                    widget.prevendaid ?? '',
                                    widget.pessoaid ?? '',
                                    vendedorId,
                                    _nomecontroller.text,
                                    cpfcontroller.text,
                                    _telefonecontatocontroller.text,
                                    _cepcontroller.text,
                                    _bairrocontroller.text,
                                    _logradourocontroller.text,
                                    _localidadecontroller.text,
                                    _complementocontroller.text,
                                    _numerocontroller.text,
                                    _ibgecontroller.text,
                                    _emailcontroller.text,
                                    _ufcontroller.text,
                                    _ieController.text,
                                    _icController.text,
                                    widget.empresaId ?? '',
                                    tabelaprecoId,
                                    double.parse(substituirVirgulaPorPonto(
                                        valordescontoController.text)),
                                    permCadastrarCliente,
                                    permEditarCliente,
                                    permEditarPrevenda);
                              }
                              setState(() {
                                isLoadingButton = false;
                                isCustomerSaved = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openModal(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          height: Responsive.h(context, 500),
          child: PopScope(
            canPop: false,
            child: Container(
              //Tamanho e espaçamento interno do modal
              height: Responsive.h(context, 300),
              margin: EdgeInsets.only(
                  left: Responsive.h(context, 12),
                  right: Responsive.h(context, 12)),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Column(
                //Conteúdo interno do modal
                children: [
                  Container(
                    padding: EdgeInsets.all(Responsive.h(context, 12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Como deseja finalizar \neste pedido?',
                          style: TextStyle(
                              fontSize: Responsive.h(context, 12),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-Bold'),
                          overflow: TextOverflow.clip,
                          softWrap: true,
                        ),
                        IconButton(
                            onPressed: () {
                              _closeModal();
                            },
                            icon: Icon(
                              Icons.cancel_rounded,
                              color: ColorsApp.errorColor,
                              size: Responsive.h(context, 30),
                            )),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                        width: Responsive.w(context,
                            320), // limite do container para evitar constraints infinitos
                        height: Responsive.h(context, 80),
                        padding: EdgeInsets.all(Responsive.h(context, 8)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/finish_order.png',
                              height: Responsive.h(context, 30),
                            ),
                            Text(
                              'Apenas Finalizar',
                              style: TextStyle(
                                color: ColorsApp.tertiaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.h(context, 10),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                    onTap: () async {
                      await DataServiceFinishOrder.fetchDataFinishOrder(
                          context,
                          urlBasic,
                          token,
                          widget.prevendaid ?? '',
                          widget.numpedido ?? '',
                          flagGerarPedido,
                          0);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await DataServiceFinishOrder.fetchDataFinishOrder(
                          context,
                          urlBasic,
                          token,
                          widget.prevendaid ?? '',
                          widget.numpedido ?? '',
                          flagGerarPedido,
                          1);
                    },
                    child: Container(
                        width: Responsive.w(context, 320),
                        height: Responsive.h(context, 80),
                        padding: EdgeInsets.all(Responsive.h(context, 8)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/finish_local.png',
                              height: Responsive.h(context, 30),
                            ),
                            Text(
                              'Finalizar e imprimir local',
                              style: TextStyle(
                                color: ColorsApp.tertiaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.h(context, 10),
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await DataServiceFinishOrder.fetchDataFinishOrder(
                          context,
                          urlBasic,
                          token,
                          widget.prevendaid ?? '',
                          widget.numpedido ?? '',
                          flagGerarPedido,
                          2);
                    },
                    child: Container(
                      width: Responsive.w(context, 320),
                      height: Responsive.h(context, 80),
                      padding: EdgeInsets.all(Responsive.h(context, 8)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.primary),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/finish_network.png',
                            height: Responsive.h(context, 30),
                          ),
                          Text(
                            'Finalizar e imprimir na rede',
                            style: TextStyle(
                              color: ColorsApp.tertiaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.h(context, 10),
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _closeModal() {
    // Função para fechar o modal (bottom sheet)
    final c = modalContext;
    if (c == null) return;
    if (Navigator.of(c).canPop()) {
      Navigator.of(c).pop();
    }
  }

  Future<void> _loadSavedPermFaturarPedidoEstoqueNegativo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedPermFaturarPedidoEstoqueNegativo =
        sharedPreferences.getBool('faturarPedidoEstoqueNegativo') ?? false;
    setState(() {
      permFaturarPedidoEstoqueNegativo = savedPermFaturarPedidoEstoqueNegativo;
    });
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

  Future<void> _loadSavedIbge() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedIbge = sharedPreferences.getString('ibge') ?? '';
    setState(() {
      ibge = savedIbge;
    });
  }

  Future<void> _loadSavedCheckCPF() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckCPF = sharedPreferences.getBool('checkCPF') ??
        true; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedCPF = savedCheckCPF; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedflagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedflagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      flagGerarPedido = savedflagGerarPedido;
    });
  }

  Future<void> _loadSavedPermEditarPrevenda() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedEditarPrevenda =
        sharedPreferences.getBool('editarPrevenda') ?? false;
    setState(() {
      permEditarPrevenda = savedEditarPrevenda;
    });
  }

  Future<void> _loadSavedPermCadastrarCliente() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCadastrarCliente =
        sharedPreferences.getBool('cadastrarCliente') ?? false;
    setState(() {
      permCadastrarCliente = savedCadastrarCliente;
    });
  }

  Future<void> _loadSavedPermEditarCliente() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedEditarCliente =
        sharedPreferences.getBool('editarCliente') ?? false;
    setState(() {
      permEditarCliente = savedEditarCliente;
    });
  }

  Future<void> _loadSavedPermAplicarDesconto() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedAplicarDesconto =
        sharedPreferences.getBool('aplicarDesconto') ?? false;
    double savedDescontoMaximoPermitido =
        sharedPreferences.getDouble('descontomaximopermitido') ?? 0.0;
    log('savedDescontoMaximoPermitido: $savedDescontoMaximoPermitido');
    setState(() {
      permAplicarDesconto = savedAplicarDesconto;
      descontoMaximoPermitido = savedDescontoMaximoPermitido;
    });
  }

  Future<void> _loadSavedPermNovoPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedNovoPedido = sharedPreferences.getBool('criarPedido') ?? false;
    setState(() {
      permNovoPedido = savedNovoPedido;
    });
  }

  Future<void> _loadSavedEmpresaID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmpresaID = sharedPreferences.getString('empresa_id') ?? '';
    setState(() {
      empresaIdUser = savedEmpresaID;
    });
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedPermFaturarPedidoEstoqueNegativo(),
      _loadSavedUrlBasic(),
      _loadSavedToken(),
      _loadSavedEmpresaID(),
      // _loadSavedIbge(),
      _loadSavedCheckCPF(),
      _loadSavedflagGerarPedido(),
      _loadSavedPermEditarPrevenda(),
      _loadSavedPermCadastrarCliente(),
      _loadSavedPermEditarCliente(),
      _loadSavedPermAplicarDesconto(),
      _loadSavedPermNovoPedido(),
      _loadSavedFlagPrivilegiado(),
    ]);

    final hasConnection = await hasInternetConnection();

    if (!hasConnection) {
      final dataCustomer = await recuperarDadosCliente();
      clienteFiltrado = dataCustomer
          .where((dataCustomer) => dataCustomer['local_id'] == widget.localId)
          .toList();
      if (clienteFiltrado.isNotEmpty) {
        setState(() {
          cpfcontroller.text = clienteFiltrado.first['cpfcnpj'] ?? '';
          _telefonecontatocontroller.text =
              clienteFiltrado.first['telefone'] ?? '';
          _nomecontroller.text = clienteFiltrado.first['nome'] ?? '';
          _emailcontroller.text = clienteFiltrado.first['email'] ?? '';
          vendedorController.text =
              clienteFiltrado.first['vendedor_codigo'] ?? '';
          _cepcontroller.text = clienteFiltrado.first['cep'] ?? '';
          _logradourocontroller.text = clienteFiltrado.first['endereco'] ?? '';
          _ufcontroller.text = clienteFiltrado.first['uf'] ?? '';
          _bairrocontroller.text = clienteFiltrado.first['bairro'] ?? '';
          _cidadecontroller.text = clienteFiltrado.first['cidade'] ?? '';
          _numerocontroller.text = clienteFiltrado.first['numero'] ?? '';
          _complementocontroller.text =
              clienteFiltrado.first['complemento'] ?? '';
          _ieController.text = clienteFiltrado.first['inscricaoestadual'] ?? '';
          _icController.text =
              clienteFiltrado.first['inscricaomunicipal'] ?? '';
        });
      }
    }

    await Future.wait([
      fetchDataCompany(),
      fetchDataListTablesPrice(empresaid),
      // searchCompany(empresaid),
      fetchDataTablePrice(widget.empresaId ?? ''),
      searchTablePrice(widget.tabelaprecoId ?? ''),
    ]);
    await Future.wait([
      fetchDataSeller(),
    ]);
  }

  Future<void> fetchDataSeller() async {
    try {
      var urlGet = Uri.parse(
          '''$urlBasic/ideia/core/getdata/prevenda%20p%20LEFT%20JOIN%20pessoa%20pp%20ON%20pp.pessoa_id%20=%20p.vendedor_pessoa_id%20WHERE%20p.prevenda_id%20=%20'${widget.prevendaid ?? ''}'/''');
      var response = await http.get(
        urlGet,
        headers: {'Accept': 'text/html'},
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        var data = dataList;
        var vendedorPessoaId = data[0]['vendedor_pessoa_id'];
        var vendedor = '${data[0]['codigo']} - ${data[0]['nome']}';
        // Tenta imprimir o pessoa_id de forma segura
        try {
          if (data is List && data.isNotEmpty) {
            setState(() {
              vendedorId = vendedorPessoaId.toString();
              vendedorController.text =
                  vendedor.contains('${null}') ? '' : vendedor;
            });
          } else {
            Message.showReturnOverlay(
              context,
              ColorsApp.errorColor,
              Icons.error,
              'Dados não encontrados.',
            );
          }
        } catch (e) {
          Message.showReturnOverlay(
            context,
            ColorsApp.errorColor,
            Icons.error,
            '$e',
          );
          log('Erro ao acessar pessoa_id: $e');
        }
      } else {
        Message.showReturnOverlay(
          context,
          ColorsApp.errorColor,
          Icons.error,
          'Erro na requisição: ${response.body}',
        );
      }
    } catch (e) {
      log(
        'Erro ao pesquisar vendedor: $e',
      );
    }
  }

  // Future<void> searchCompany(String empresa_id) async {
  //   try {
  //     var urlGetCompany = Uri.parse(
  //         '''$urlBasic/ideia/core/getdata/empresa%20e%20WHERE%20(e.empresa_id%20LIKE%20'%25${empresa_id}%25'%20OR%20e.empresaCodigo%20=%20'${empresaController.text}'%20OR%20e.empresaNome%20LIKE%20'${empresaController.text}')/''');
  //     var response =
  //         await http.get(urlGetCompany, headers: {'Accept': 'text/html'});

  //     if (response.statusCode == 200) {
  //       var jsonData = jsonDecode(response.body);
  //       log('dataList: ${jsonData}');
  //       var dataList = jsonData['data'].keys.first;
  //       var dataMap = jsonData['data'] as Map<String, dynamic>;

  //       if (dataMap.isNotEmpty) {
  //         var companyList = dataMap[dataList] as List;
  //         var company = companyList.first;
  //         setState(() {
  //           empresaController.text =
  //               '${company['empresa_codigo']} - ${company['empresa_nome']}';
  //           flagpermitiralterartabela = company['flagpermitiralterartabela'] ??
  //               flagpermitiralterartabela;
  //           empresaid = company['empresa_id'];
  //         });
  //         await searchTablePrice(company['tabelapreco_id']);
  //       } else {
  //         log('Lista vazia: ${response.body}');
  //       }
  //     } else {
  //       log('${response.statusCode} - ${response.body}');
  //     }
  //   } catch (e) {
  //     log('Erro na requisição searchCompany: $e');
  //   }
  // }

  Future<void> fetchDataCompany({bool? ascending}) async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final listCompanyOff = await recuperarListaEmpresa();
      setState(() {
        company = listCompanyOff;
      });
    } else {
      List<CompanyList>? fetchedData =
          await DataServiceCompany.fetchDataCompany(
        context,
        urlBasic,
        '',
      );

      if (fetchedData != null) {
        final listaMap = fetchedData.map((e) => e.toJson()).toList();
        await salvarListaEmpresa(listaMap);
        setState(() {
          company = fetchedData;
        });
        await searchTablePrice(company.first.tabelaprecoId ?? '');
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

  Future<void> searchTablePrice(String tabPrecoId) async {
    try {
      var urlGetCompany = Uri.parse(
          '''$urlBasic/ideia/core/getdata/tabelapreco%20t%20WHERE%20(t.tabelapreco_id%20=%20'$tabPrecoId'%20OR%20t.codigo%20=%20'${tabelaController.text}'%20OR%20t.nome%20LIKE%20'${tabelaController.text}')/''');
      var response =
          await http.get(urlGetCompany, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var dataList = jsonData['data'].keys.first;
        var dataMap = jsonData['data'] as Map<String, dynamic>;

        if (dataMap.isNotEmpty) {
          var tabPriceList = dataMap[dataList] as List;
          var tabPrice = tabPriceList.first;
          setState(() {
            tabelaController.text =
                '${tabPrice['codigo']} - ${tabPrice['nome']}';
            tabelaprecoId = tabPrice['tabelapreco_id'];
          });
        } else {
          log('Lista vazia: ${response.body}');
        }
      } else {
        log('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Erro na requisição searchCompany: $e');
    }
  }

  Future<void> searchClient() async {
    final checkInternetConnection = await hasInternetConnection();
    if (!checkInternetConnection) {
      Message.showReturnOverlay(
        context,
        ColorsApp.errorColor,
        Icons.error,
        'Sem conexão com a internet',
      );
      return;
    }
    String searchText = '';
    if (cpfcontroller.text.isNotEmpty) {
      searchText = getUnmaskedText(cpfcontroller.text);
    } else if (_emailcontroller.text.isNotEmpty) {
      searchText = _emailcontroller.text;
    } else if (_nomecontroller.text.isNotEmpty) {
      searchText = _nomecontroller.text;
    } else if (_telefonecontatocontroller.text.isNotEmpty) {
      searchText = getUnmaskedText(_telefonecontatocontroller.text);
    }
    try {
      var urlGet = Uri.parse(
          "$urlBasic/ideia/core/getdata/(SELECT%20p.pessoa_id,%20p.nome,%20p.telefone,%20p.cpf,%20p.cnpj,%20p.endereco,%20p.enderecocep,%20p.uf,%20p.enderecobairro,%20p.endereconumero,%20p.enderecocomplemento,%20p.emailcontato,%20p.inscricaomunicipal,%20p.inscricaoestadual,%20c.nome%20AS%20enderecocidade%20FROM%20pessoa%20p%20LEFT%20JOIN%20cidade%20c%20ON%20c.cidade_id%20=%20p.cidade_id%20WHERE%20(p.cpf%20LIKE%20'%25$searchText%25'%20OR%20p.cnpj%20LIKE%20'%25$searchText%25'%20OR%20p.nome%20like%20'%25$searchText%25'%20OR%20p.telefone%20like%20'%25$searchText%25'%20OR%20p.emailcontato%20like%20'%25$searchText%25'))%20as%20p/");
      var response = await http.get(urlGet, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['success'] == 0) {
          setState(() {
            clienteFiltrado = [];
            isLoadingSearchCPF = false;
          });
          Message.showReturnOverlay(
            context,
            ColorsApp.errorColor,
            Icons.error,
            'Cliente não encontrado.',
          );
          return;
        } else {
          var dynamicKey = jsonData['data'].keys.first;
          var dataList = jsonData['data'][dynamicKey];

          setState(() {
            clienteFiltrado = dataList;
            isLoadingSearchCPF = false;
          });
          modalclientList();
        }
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
                title: Text(cliente['nome'] ?? ''),
                subtitle: Text(cliente['cpf'] == null
                    ? cliente['cnpj'] ?? ''
                    : cliente['cpf'] ?? ''),
                onTap: () {
                  widget.onCpfAtualizado(cliente['cpf'] == null
                      ? cliente['cnpj'] ?? ''
                      : cliente['cpf'] ?? '');
                  setState(() {
                    pessoaId = cliente['pessoa_id'].toString();
                    cpfcontroller.text = cliente['cpf'] == null
                        ? cliente['cnpj'] ?? ''
                        : cliente['cpf'] ?? '';
                    _telefonecontatocontroller.text = cliente['telefone'] ?? '';
                    _nomecontroller.text = cliente['nome'] ?? '';
                    // _clientController.text =
                    //     '${_nomecontroller.text == '' ? '' : _nomecontroller.text}${cpfcontroller.text == '' ? '' : ' | ${cpfcontroller.text}'}${_telefonecontatocontroller.text == '' ? '' : ' | ${_telefonecontatocontroller.text}'}';
                    _emailcontroller.text = cliente['emailcontato'] ?? '';
                    _cepcontroller.text = cliente['enderecocep'] ?? '';
                    _logradourocontroller.text = cliente['endereco'] ?? '';
                    _ufcontroller.text = cliente['uf'] ?? '';
                    _bairrocontroller.text = cliente['enderecobairro'] ?? '';
                    _localidadecontroller.text =
                        cliente['enderecocidade'] ?? '';
                    _numerocontroller.text = cliente['endereconumero'] ?? '';
                    _complementocontroller.text =
                        cliente['enderecocomplemento'] ?? '';
                    _ieController.text = cliente['inscricaoestadual'] ?? '';
                    _icController.text = cliente['inscricaomunicipal'] ?? '';
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

  modalSellerList() {
    showDialog(
      context: context,
      builder: (context) => Modal('Vendedores encontrados', [
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: vendedorFiltrado.length,
            itemBuilder: (context, index) {
              var vendedor = vendedorFiltrado[index];
              return ListTile(
                title: Text(vendedor['nome'] ?? ''),
                subtitle: Text(vendedor['codigo']),
                onTap: () {
                  setState(() {
                    vendedorId = vendedor['pessoa_id'].toString();
                    vendedorController.text =
                        '${vendedor['codigo']} - ${vendedor['nome']}';
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        )
      ]),
    );
  }

  Future<void> finishOrder() async {
    final hasInternet = await hasInternetConnection();
    if (flagObrigarVendedor == 1 && vendedorController.text.isEmpty) {
      Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
          'Por favor, selecione um vendedor para finalizar o pedido.');
      setState(() {
        isLoadingIconButton = false;
      });
      return;
    }
    if (empresaController.text.isEmpty && tabelaController.text.isEmpty) {
      Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
          'Por favor, selecione a empresa e a tabela de preço para finalizar o pedido.');
      setState(() {
        isLoadingIconButton = false;
      });
      return;
    }
    if (widget.flagObrigarCliente == 1 &&
        (cpfcontroller.text.isEmpty &&
            _telefonecontatocontroller.text.isEmpty &&
            _nomecontroller.text.isEmpty)) {
      Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
          'Por favor, informe os dados do cliente para finalizar o pedido.');
      setState(() {
        isLoadingIconButton = false;
      });
    } else if (/*/*orders.isEmpty ||*/*/ !hasProduct) {
      Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
          'Não é possível finalizar o pedido sem produtos.');
      setState(() {
        isLoadingIconButton = false;
      });
    } else if (permFaturarPedidoEstoqueNegativo == false &&
        flagprivilegiado == 0) {
      final hasNegativeStock = orders.any((order) => order.estoqueinicial < 0);
      if (hasNegativeStock) {
        Message.showReturnOverlay(
          context,
          ColorsApp.errorColor,
          Icons.error,
          'Não é possível finalizar o pedido. Existem produtos com estoque negativo.',
        );
        setState(() {
          isLoadingIconButton = false;
        });
        return;
      }
    } else {
      if (!hasInternet) {
        await removerPedido(widget.localId.toString());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()));
        setState(() {
          isLoadingIconButton = false;
        });
        return;
      } else {
        final data = await DataServiceCliente2.fetchDataCliente2(
            urlBasic, cpfcontroller.text, token);
        var pessoaId = data['pessoa_id'].toString();
        if (permEditarPrevenda || flagprivilegiado == 1) {
          await NewCustomer.adjustOrder(
              context,
              urlBasic,
              token,
              _nomecontroller.text,
              cpfcontroller.text,
              _telefonecontatocontroller.text,
              widget.prevendaid ?? '',
              pessoaId,
              vendedorId,
              double.parse(
                  substituirVirgulaPorPonto(valordescontoController.text)),
              widget.empresaId ?? '',
              tabelaprecoId);
          _openModal(context);
          setState(() {
            isLoadingIconButton = false;
          });
        } else {
          _openModal(context);
        }
      }
    }
  }

  double calcularValorFinal(double valor, double desconto) {
    return valor - (valor * (desconto / 100));
  }

  double calcularPercentualDesconto(double valorOriginal, double valorFinal) {
    if (valorOriginal == 0) return 0;
    return ((valorOriginal - valorFinal) / valorOriginal) * 100;
  }

  Future<void> openModalDesc() async {
    showDialog(
      context: context,
      builder: (context) => Modal('Aplicar Desconto', [
        Input(
          text: 'Desconto total',
          controller: valordescontoController,
          type: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            TextInputFormatter.withFunction((oldValue, newValue) {
              try {
                if (newValue.text.isEmpty) return newValue;
                final number = double.parse(
                        newValue.text.replaceAll(RegExp(r'[^0-9]'), '')) /
                    100;
                final formatted = currencyFormat.format(number);
                return TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
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
          text: 'Aplicar Desconto',
          color: Theme.of(context).colorScheme.primary,
          width: Responsive.h(context, 150),
          icon: Icons.money_off_csred_rounded,
          onPressed: () async {
            //var valorfinal = calcularValorFinal(widget.valortotal, double.parse(substituirVirgulaPorPonto(valordescontoController.text)));
            var percentualDesconto = calcularPercentualDesconto(
                (widget.valortotal ?? 0.0),
                (widget.valortotal ?? 0.0) -
                    double.parse(substituirVirgulaPorPonto(
                        valordescontoController.text)));
            if (permAplicarDesconto == false &&
                flagprivilegiado != 1 &&
                percentualDesconto > descontoMaximoPermitido) {
              showDialog(
                  context: context, builder: (_) => const AlertDialogDefault());
            } else {
              final hasInternet = await hasInternetConnection();
              if (!hasInternet) {
                final bodyMap = {
                  'local_id': widget.localId,
                  'cpfcnpj': cpfcontroller.text,
                  'telefone': _telefonecontatocontroller.text,
                  'nome': _nomecontroller.text,
                  'email': _emailcontroller.text,
                  'vendedor_codigo': vendedorController.text,
                  'cep': _cepcontroller.text,
                  'endereco': _logradourocontroller.text,
                  'uf': _ufcontroller.text,
                  'bairro': _bairrocontroller.text,
                  'cidade': _cidadecontroller.text,
                  'numero': _numerocontroller.text,
                  'complemento': _complementocontroller.text,
                  'iestadual': _ieController.text,
                  'imunicipal': _icController.text,
                  'valordesconto': double.parse(
                      substituirVirgulaPorPonto(valordescontoController.text))
                };
                await adicionarDadosCliente(bodyMap, context);
                Navigator.of(context).pop();
              } else {
                await NewCustomer.adjustOrder(
                    context,
                    urlBasic,
                    token,
                    _nomecontroller.text,
                    cpfcontroller.text,
                    _telefonecontatocontroller.text,
                    widget.prevendaid ?? '',
                    pessoaId,
                    vendedorId,
                    double.parse(substituirVirgulaPorPonto(
                        valordescontoController.text)),
                    widget.empresaId ?? '',
                    widget.tabelaprecoId ?? '');
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ]),
    );
  }

  Future<void> _loadSavedFlagPrivilegiado() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int savedFlagPrivilegiado =
        sharedPreferences.getInt('flagprivilegiado') ?? 0;
    setState(() {
      flagprivilegiado = savedFlagPrivilegiado;
    });
  }

  Future<void> fetchDataListTablesPrice(String empresaId) async {
    final hasInternet = await hasInternetConnection();
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
        value: tables.nome,
        child: Text((tables.nome).toString()),
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
            ('${companys.empresaCodigo} - ${companys.empresaNome}').toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return dynamicItems;
  }

  Future<void> fetchDataTablePriceId() async {
    Map<String, dynamic>? fetchedDataTablePriceId =
        await DataServiceTablePriceId.fetchDataTablePriceId(
            context, urlBasic, tableprice);
    if (fetchedDataTablePriceId != null) {
      setState(() {
        tabelaController.text =
            '${fetchedDataTablePriceId['codigo']} - ${fetchedDataTablePriceId['nome']}';
        tabelaprecoId = fetchedDataTablePriceId['tabelapreco_id'] ?? '';
      });
    }
  }
}
