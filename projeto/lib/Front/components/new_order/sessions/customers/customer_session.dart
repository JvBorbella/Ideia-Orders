// import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'dart:convert';

import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/finish_order.dart';
import 'package:projeto/back/get_cep.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/new_customer.dart';
import 'package:projeto/back/orders_endpoint.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/login_config/elements/button.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/components/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final GlobalKey<CustomerSessionState> customerKey =
    GlobalKey<CustomerSessionState>();

class CustomerSession extends StatefulWidget {
  final prevendaid;
  final pessoaid;
  final pessoanome;
  final cpfcnpj;
  final telefone;
  final cep;
  final bairro;
  final localidade;
  final ibge;
  final endereco;
  final complemento;
  final numero;
  final cidade;
  final uf;
  final email;
  final numpedido;
  final noProduct;
  final valordesconto;

  const CustomerSession(
      {Key? key,
      this.prevendaid,
      this.pessoaid,
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
      this.valordesconto})
      : super(key: key);

  @override
  State<CustomerSession> createState() => CustomerSessionState();
}

class CustomerSessionState extends State<CustomerSession> {
  Future<void> saveOrder() async {
    await NewCustomer.AdjustOrder(
        context,
        urlBasic,
        token,
        _nomecontroller.text,
        _cpfcontroller.text,
        _telefonecontatocontroller.text,
        widget.prevendaid,
        widget.pessoaid,
        vendedorId,
        double.parse(substituirVirgulaPorPonto(valordescontoController.text)) ?? 0.0);
  }

  late BuildContext modalContext;

  String urlBasic = '';
  String token = '';
  String ibge = '';
  String cpf = '';
  String vendedorId = '';
  bool isCheckedCPF = true;

  bool isLoading = true;
  bool isLoadingButton = false;
  bool isLoadingIconButton = false;
  bool isLoadingSearchCPF = false, isLoadingSearchSeller = false;
  bool isLoadingSearchCEP = false;

  bool FlagGerarPedido = false;

  final _cepcontroller = TextEditingController();
  final _complementocontroller = TextEditingController();
  final _bairrocontroller = TextEditingController();
  final _cidadecontroller = TextEditingController();
  final _numerocontroller = TextEditingController();
  final _localidadecontroller = TextEditingController();
  final _ibgecontroller = TextEditingController();
  final _ufcontroller = TextEditingController();
  final _logradourocontroller = TextEditingController();
  final _cpfcontroller = TextEditingController();
  final _nomecontroller = TextEditingController();
  final _telefonecontatocontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final vendedorController = TextEditingController();
  final valordescontoController = TextEditingController();

  // final _cpfMaskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telMaskFormatter = MaskTextInputFormatter(mask: '(##) #####-####');
  final _cepMaskFormatter = MaskTextInputFormatter(mask: '#####-###');
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  final pessoa_id = String;

  List<OrdersDetailsEndpoint> orders = [];

  String substituirVirgulaPorPonto(String texto) {
    return texto.replaceAll(',', '.');
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _localidadecontroller.text = widget.cidade ?? '';
    _cepcontroller.text = _cepMaskFormatter.maskText(widget.cep);
    _bairrocontroller.text = widget.bairro.toString();
    _numerocontroller.text = widget.numero ?? '';
    _ibgecontroller.text = widget.ibge.toString();
    _complementocontroller.text = widget.complemento.toString();
    _ufcontroller.text = widget.uf.toString();
    _logradourocontroller.text = widget.endereco.toString();
    _nomecontroller.text = widget.pessoanome == 'null' ? '' : widget.pessoanome;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: '',
    );

    // se widget.valordesconto vier como número (ex: double)
    if (widget.valordesconto != null && widget.valordesconto!.isNotEmpty) {
      final value = double.tryParse(widget.valordesconto!) ?? 0.0;
      valordescontoController.text = formatter.format(value);
    } else {
      valordescontoController.text = '0,00';
    }
    final cpfcnpj = widget.cpfcnpj ?? '';
    final cleanedCpfCnpj = cpfcnpj.replaceAll(
        RegExp(r'\D'), ''); // Remove caracteres não numéricos

    if (cleanedCpfCnpj.isNotEmpty) {
      _cpfcontroller.text = cleanedCpfCnpj.length > 11
          ? MaskTextInputFormatter(mask: '##.###.###/####-##')
              .maskText(cleanedCpfCnpj)
          : MaskTextInputFormatter(mask: '###.###.###-##')
              .maskText(cleanedCpfCnpj);
    } else {
      _cpfcontroller.text = ''; // Define vazio se não houver CPF ou CNPJ
    }
    _telefonecontatocontroller.text = widget.telefone == 'null'
        ? ''
        : _telMaskFormatter.maskText(widget.telefone);
    _emailcontroller.text = widget.email ?? '';

    print('Número: ' + widget.numero);
    print('Número: ' + widget.numpedido);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const TextTitle(text: 'Desconto'),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Style.height_15(context)),
            child: Input(
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
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  } catch (e) {
                    return oldValue;
                  }
                }),
              ],
            ),
          ),
          SizedBox(
            height: Style.height_10(context),
          ),
          ButtonConfig(
            text: 'Aplicar Desconto',
            height: Style.height_12(context),
            onPressed: () async {
              await NewCustomer.AdjustOrder(
                  context,
                  urlBasic,
                  token,
                  _nomecontroller.text,
                  _cpfcontroller.text,
                  _telefonecontatocontroller.text,
                  widget.prevendaid,
                  pessoa_id.toString(),
                  vendedorId,
                  double.parse(substituirVirgulaPorPonto(
                          valordescontoController.text)) ??
                      0.0);
            },
          ),
          const TextTitle(text: 'Dados do cliente'),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.all(Style.height_15(context)),
            child: Column(
              children: [
                Input(
                  text: 'CPF',
                  type: TextInputType.text,
                  controller: _cpfcontroller,
                  isLoadingButton: isLoadingSearchCPF,
                  inputFormatters: [
                    CnpjCpfFormatter(
                      eDocumentType: EDocumentType.BOTH,
                    )
                  ],
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.unspecified,
                  IconButton: IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoadingSearchCPF = true;
                        });
                        await GetCliente.getcliente(
                          context,
                          urlBasic,
                          _nomecontroller,
                          _cpfcontroller,
                          _telefonecontatocontroller,
                          _cepcontroller,
                          _logradourocontroller,
                          _ufcontroller,
                          _bairrocontroller,
                          _numerocontroller,
                          _complementocontroller,
                          _cidadecontroller,
                          _emailcontroller,
                        );
                        setState(() {
                          isLoadingSearchCPF = false;
                        });
                      },
                      icon: const Icon(Icons.person_search)),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Telefone',
                  type: TextInputType.text,
                  controller: _telefonecontatocontroller,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.unspecified,
                  inputFormatters: [MaskedInputFormatter('(00) 00000-0000')],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Nome do cliente',
                  type: TextInputType.text,
                  controller: _nomecontroller,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.unspecified,
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Email do cliente',
                  type: TextInputType.emailAddress,
                  controller: _emailcontroller,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.unspecified,
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Pesquise pelo Vendedor',
                  controller: vendedorController,
                  type: TextInputType.text,
                  textAlign: TextAlign.start,
                  textInputAction: TextInputAction.unspecified,
                  IconButton: Icon(Icons.person_search_rounded),
                  onTap: () async {
                    setState(() {
                      isLoadingSearchSeller = true;
                    });
                    try {
                      var urlGet = Uri.parse(
                          '''$urlBasic/ideia/core/getdata/pessoa%20p%20WHERE%20p.flagvendedor%20=%201%20AND%20p.codigo%20='${vendedorController.text}'/''');
                      var response = await http.get(
                        urlGet,
                        headers: {'Accept': 'text/html'},
                      );

                      print(urlGet);
                      if (response.statusCode == 200) {
                        var jsonData = json.decode(response.body);
                        var dynamicKey = jsonData['data'].keys.first;
                        print('Chave dinâmica encontrada: $dynamicKey');

                        // Verifica se o valor associado à chave é uma lista
                        var dataList = jsonData['data'][dynamicKey];
                        var data = dataList;
                        var vendedor_id = data[0]['pessoa_id'];
                        var codigo = data[0]['codigo'];
                        var nome = data[0]['nome'];
                        // Tenta imprimir o pessoa_id de forma segura
                        try {
                          if (data is List && data.isNotEmpty) {
                            print('data is list ' + data[0]['pessoa_id']);
                            setState(() {
                              vendedorId = vendedor_id;
                            });
                            print(vendedorId);
                          } else {
                            print('Estrutura inesperada em data.');
                          }
                        } catch (e) {
                          print('Erro ao acessar pessoa_id: $e');
                        }

                        if (data != null &&
                            (data is List ? data.isNotEmpty : true)) {
                          setState(() {
                            vendedorId = data is List
                                ? data[0]['pessoa_id'].toString()
                                : data['pessoa_id'].toString();
                            vendedorController.text = '$codigo - $nome';
                          }); // Ajuste conforme a estrutura real dos dados
                          print('ID do vendedor encontrado: $vendedorId');
                        } else {
                          setState(() {
                            vendedorController.text = 'Vendedor não encontrado';
                          });
                          print('Vendedor não encontrado.');
                        }
                      } else {
                        print('Erro na requisição: ${response.statusCode}');
                      }
                    } catch (e) {
                      print('Erro ao pesquisar vendedor: $e');
                    }
                    setState(() {
                      isLoadingSearchSeller = false;
                    });
                  },
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  controller: _cepcontroller,
                  text: 'CEP',
                  type: TextInputType.number,
                  textAlign: TextAlign.start,
                  inputFormatters: [MaskedInputFormatter('00000-000')],
                  isLoadingButton: isLoadingSearchCEP,
                  textInputAction: TextInputAction.unspecified,
                  IconButton: IconButton(
                      onPressed: () async {
                        setState(() {
                          isLoadingSearchCEP = true;
                        });
                        await GetCep.getcep(
                          _cepcontroller.text,
                          _logradourocontroller,
                          _complementocontroller,
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
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Style.width_250(context),
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
                            width: Style.width_50(context),
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
                  height: Style.height_10(context),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Style.width_140(context),
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
                            width: Style.width_180(context),
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
                  height: Style.height_10(context),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: Style.width_100(context),
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
                            width: Style.width_215(context),
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
                SizedBox(
                  height: Style.height_20(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: Style.width_150(context),
                          child: RegisterButton(
                            text: 'Cadastrar cliente',
                            color: Style.primaryColor,
                            width: Style.width_150(context),
                            isLoadingButton: isLoadingButton,
                            onPressed: () async {
                              setState(() {
                                isLoadingButton = true;
                              });
                              await NewCustomer.getCostumer(
                                  context,
                                  urlBasic,
                                  token,
                                  widget.prevendaid,
                                  widget.pessoaid,
                                  vendedorId,
                                  _nomecontroller.text,
                                  _cpfcontroller.text,
                                  _telefonecontatocontroller.text,
                                  _cepcontroller.text,
                                  _bairrocontroller.text,
                                  _logradourocontroller.text,
                                  _localidadecontroller.text,
                                  _complementocontroller.text,
                                  _numerocontroller.text,
                                  ibge,
                                  _emailcontroller.text,
                                  _ufcontroller.text,
                                  double.parse(substituirVirgulaPorPonto(valordescontoController.text)) ??
                                      0.0);
                              print('pessoa_id: ' + widget.pessoaid);
                              setState(() {
                                isLoadingButton = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: Style.width_150(context),
                          child: Column(
                            children: [
                              RegisterIconButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoadingIconButton = true;
                                  });
                                  if (isCheckedCPF == true) {
                                    if (_cpfcontroller.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Style.SaveUrlMessagePadding(
                                                  context)),
                                          content: Text(
                                            'Por favor, preencha o CPF do cliente',
                                            style: TextStyle(
                                              fontSize:
                                                  Style.SaveUrlMessageSize(
                                                      context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: Style.errorColor,
                                        ),
                                      );
                                      setState(() {
                                        isLoadingIconButton = false;
                                      });
                                    } else if (_telefonecontatocontroller
                                        .text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Style.SaveUrlMessagePadding(
                                                  context)),
                                          content: Text(
                                            'Por favor, preencha o telefone do cliente',
                                            style: TextStyle(
                                              fontSize:
                                                  Style.SaveUrlMessageSize(
                                                      context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: Style.errorColor,
                                        ),
                                      );
                                      setState(() {
                                        isLoadingIconButton = false;
                                      });
                                    } else if (_nomecontroller.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Style.SaveUrlMessagePadding(
                                                  context)),
                                          content: Text(
                                            'Por favor, preencha o nome do cliente',
                                            style: TextStyle(
                                              fontSize:
                                                  Style.SaveUrlMessageSize(
                                                      context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: Style.errorColor,
                                        ),
                                      );
                                      setState(() {
                                        isLoadingIconButton = false;
                                      });
                                    } else if (orders.isEmpty ||
                                        widget.noProduct == '1') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Style.SaveUrlMessagePadding(
                                                  context)),
                                          content: Text(
                                            'Não é possível finalizar o pedido sem produtos.',
                                            style: TextStyle(
                                              fontSize:
                                                  Style.SaveUrlMessageSize(
                                                      context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: Style.errorColor,
                                        ),
                                      );
                                      setState(() {
                                        isLoadingIconButton = false;
                                      });
                                    } else {
                                      _openModal(context);
                                      setState(() {
                                        isLoadingIconButton = false;
                                      });
                                    }
                                  } else if (orders.isEmpty ||
                                      widget.noProduct == '1') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(
                                            Style.SaveUrlMessagePadding(
                                                context)),
                                        content: Text(
                                          'Não é possível finalizar o pedido sem produtos.',
                                          style: TextStyle(
                                            fontSize: Style.SaveUrlMessageSize(
                                                context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.errorColor,
                                      ),
                                    );
                                    setState(() {
                                      isLoadingIconButton = false;
                                    });
                                  } else {
                                    setState(() {
                                      isLoadingIconButton = true;
                                    });
                                    final data = await DataServiceCliente2
                                        .fetchDataCliente2(urlBasic,
                                            _cpfcontroller.text, token);
                                    var pessoa_id =
                                        data['pessoa_id'].toString();
                                    await NewCustomer.AdjustOrder(
                                        context,
                                        urlBasic,
                                        token,
                                        _nomecontroller.text,
                                        _cpfcontroller.text,
                                        _telefonecontatocontroller.text,
                                        widget.prevendaid,
                                        pessoa_id,
                                        vendedorId,
                                        double.parse(substituirVirgulaPorPonto(
                                                valordescontoController
                                                    .text)) ??
                                            0.0);
                                    _openModal(context);
                                    setState(() {
                                      isLoadingIconButton = false;
                                    });
                                  }
                                },
                                text: 'Finalizar pedido',
                                color: Style.sucefullColor,
                                width: Style.width_150(context),
                                icon: Icons.check_rounded,
                                isLoadingButton: isLoadingIconButton,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
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
            height: Style.height_400(context),
            child: WillPopScope(
                child: Container(
                  //Tamanho e espaçamento interno do modal
                  height: Style.InternalModalSize(context),
                  margin: EdgeInsets.only(
                      left: Style.ModalMargin(context),
                      right: Style.ModalMargin(context)),
                  //padding: EdgeInsets.all(Style.InternalModalPadding(context)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Style.ModalBorderRadius(context))),
                  child: Column(
                    //Conteúdo interno do modal
                    children: [
                      Container(
                        padding: EdgeInsets.all(Style.height_12(context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Como deseja finalizar este pedido?',
                              style: TextStyle(
                                  fontSize: Style.height_12(context),
                                  color: Style.primaryColor,
                                  fontFamily: 'Poppins-Bold'),
                              overflow: TextOverflow.clip,
                              softWrap: true,
                            ),
                            Container(
                              width: Style.height_30(context),
                              height: Style.height_30(context),
                              decoration: BoxDecoration(
                                  color: Style.errorColor,
                                  borderRadius: BorderRadius.circular(
                                      Style.height_10(context))),
                              child: IconButton(
                                  onPressed: () {
                                    _closeModal();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Style.tertiaryColor,
                                    size: Style.height_15(context),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await DataServiceFinishOrder.fetchDataFinishOrder(
                                  context,
                                  urlBasic,
                                  token,
                                  widget.prevendaid,
                                  widget.numpedido,
                                  FlagGerarPedido);
                            },
                            child: Container(
                                width: Style.width_300(context),
                                height: Style.height_80(context),
                                padding: EdgeInsets.all(
                                    Style.ButtonExitPadding(context)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Style.ButtonExitBorderRadius(context)),
                                    color: Style.primaryColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/finish_order.png',
                                      height: Style.height_30(context),
                                    ),
                                    Text(
                                      'Apenas Finalizar >',
                                      style: TextStyle(
                                        color: Style.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Style.height_10(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Row(
                        //Espaçamento entre os Buttons
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await DataServiceFinishOrderPrintLocal
                                  .fetchDataFinishOrderPrintLocal(
                                      context,
                                      urlBasic,
                                      token,
                                      widget.prevendaid,
                                      widget.numpedido,
                                      FlagGerarPedido);
                            },
                            child: Container(
                                width: Style.width_300(context),
                                height: Style.height_80(context),
                                padding: EdgeInsets.all(
                                    Style.ButtonExitPadding(context)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Style.ButtonExitBorderRadius(context)),
                                    color: Style.primaryColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/finish_local.png',
                                      height: Style.height_30(context),
                                    ),
                                    Text(
                                      'Finalizar e imprimir local >',
                                      style: TextStyle(
                                        color: Style.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Style.height_10(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () async {
                              await DataServiceFinishOrderPrintNetwork
                                  .fetchDataFinishOrderPrintNetwork(
                                      context,
                                      urlBasic,
                                      token,
                                      widget.prevendaid,
                                      widget.numpedido.toString(),
                                      FlagGerarPedido);
                            },
                            child: Container(
                                width: Style.width_300(context),
                                height: Style.height_80(context),
                                padding: EdgeInsets.all(
                                    Style.ButtonExitPadding(context)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Style.ButtonExitBorderRadius(context)),
                                    color: Style.primaryColor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/finish_network.png',
                                      height: Style.height_30(context),
                                    ),
                                    Text(
                                      'Finalizar e imprimir na rede >',
                                      style: TextStyle(
                                        color: Style.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Style.height_10(context),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                onWillPop: () async {
                  _closeModal();
                  return true;
                }));
      },
    );
  }

  void _closeModal() {
    //Função para fechar o modal
    Navigator.of(modalContext).pop();
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

  Future<void> _loadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      FlagGerarPedido = savedFlagGerarPedido;
    });
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
      _loadSavedIbge(),
      _loadSavedCheckCPF(),
      _loadSavedFlagGerarPedido()
    ]);

    await Future.wait([
      fetchDataOrders(),
    ]);
    await Future.wait([
      fetchDataSeller(),
    ]);
  }

  Future<void> fetchDataOrders() async {
    List<OrdersDetailsEndpoint>? fetchData =
        await DataServiceOrdersDetails.fetchDataOrdersDetails(
            urlBasic, widget.prevendaid, token);
    if (fetchData != null) {
      setState(() {
        orders = fetchData;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDataSeller() async {
    try {
      var urlGet = Uri.parse(
          '''$urlBasic/ideia/core/getdata/prevenda%20p%20LEFT%20JOIN%20pessoa%20pp%20ON%20pp.pessoa_id%20=%20p.vendedor_pessoa_id%20WHERE%20p.prevenda_id%20=%20'${widget.prevendaid}'/''');
      var response = await http.get(
        urlGet,
        headers: {'Accept': 'text/html'},
      );

      print(urlGet);
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;
        print('Chave dinâmica encontrada: $dynamicKey');

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        var data = dataList;
        var vendedor_pessoa_id = data[0]['vendedor_pessoa_id'];
        var codigo = data[0]['codigo'];
        var nome = data[0]['nome'];
        // Tenta imprimir o pessoa_id de forma segura
        try {
          if (data is List && data.isNotEmpty) {
            print('data is list ' + data[0]['vendedor_pessoa_id']);
            setState(() {
              vendedorId = vendedor_pessoa_id.toString();
              vendedorController.text = '$codigo - $nome';
            });
            print(vendedorId);
          } else {
            print('Estrutura inesperada em data.');
          }
        } catch (e) {
          print('Erro ao acessar pessoa_id: $e');
        }
        // if (data != null && (data is List ? data.isNotEmpty : true)) {
        //   setState(() {
        //     vendedorId = data is List
        //         ? data[0]['vendedor_pessoa_id'].toString()
        //         : data['vendedor_pessoa_id'].toString();
        //     vendedorController.text = '$codigo - $nome';
        //   }); // Ajuste conforme a estrutura real dos dados
        //   print('ID do vendedor encontrado: $vendedorId');
        // } else {
        //   setState(() {
        //     vendedorController.text = 'Vendedor não encontrado';
        //   });
        //   print('Vendedor não encontrado.');
        // }
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao pesquisar vendedor: $e');
    }
  }
}
