// import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'dart:convert';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cnpj_cpf_formatter_nullsafety/cnpj_cpf_formatter_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/company/table_price.dart';
import 'package:projeto/back/orders/finish_order.dart';
import 'package:projeto/back/customer/get_cep.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/customer/new_customer.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/saveList.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
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
  final empresa_id;
  final empresa_codigo;
  final empresa_nome;
  final tabelapreco_id;
  final tabelapreco;
  final local_id;
  final Function(String) onCpfAtualizado;
  final Function(String) onTelAtualizado;
  final Function(String) onNomeAtualizado;

  const CustomerSession({
    Key? key,
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
    this.valordesconto,
    this.empresa_id,
    this.empresa_codigo,
    this.empresa_nome,
    this.tabelapreco_id,
    this.tabelapreco,
    this.local_id,
    required this.onCpfAtualizado,
    required this.onTelAtualizado,
    required this.onNomeAtualizado,
  }) : super(key: key);

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
        cpfcontroller.text,
        _telefonecontatocontroller.text,
        widget.prevendaid,
        widget.pessoaid,
        vendedorId,
        double.parse(substituirVirgulaPorPonto(valordescontoController.text)) ??
            0.0,
        empresaid,
        tabelapreco_id);
  }

  late BuildContext modalContext;

  String urlBasic = '',
      token = '',
      ibge = '',
      cpf = '',
      tel = '',
      nome = '',
      vendedorId = '',
      empresa_codigo = '',
      empresa_nome = '',
      empresa_id = '',
      empresaid = '',
      tableprice = '',
      tabelapreco_id = '';
  //bool permNovoPedido = homeKey.currentState?.permNovoPedido ?? false;
  bool isCheckedCPF = true,
      isLoading = true,
      isLoadingButton = false,
      isLoadingIconButton = false,
      isLoadingSearchCPF = false,
      isLoadingSearchSeller = false,
      isLoadingSearchCEP = false,
      FlagGerarPedido = false,
      permEditarPrevenda = false,
      permCadastrarCliente = false,
      permEditarCliente = false,
      permAplicarDesconto = false,
      permNovoPedido = false;

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
  final _emailcontroller = TextEditingController();
  final vendedorController = TextEditingController();
  final valordescontoController = TextEditingController();
  final empresaController = TextEditingController();
  final tabelaController = TextEditingController();

  // final _cpfMaskFormatter = MaskTextInputFormatter(mask: '###.###.###-##');
  final _telMaskFormatter = MaskTextInputFormatter(mask: '(##) #####-####');
  final _cepMaskFormatter = MaskTextInputFormatter(mask: '#####-###');
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  final pessoa_id = String;

  List<OrdersDetailsEndpoint> orders = [];
  List<CompanyList> company = [];
  List<ListTablePrices> tables_price = [];
  List<Map<String, dynamic>> clienteFiltrado = [];

  String substituirVirgulaPorPonto(String texto) {
    return texto.replaceAll(',', '.');
  }

  String buttonText = 'Cadastrar Cliente';

  @override
  void initState() {
    super.initState();
    loadData();
    print(widget.empresa_id);
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
      cpfcontroller.text = cleanedCpfCnpj.length > 11
          ? MaskTextInputFormatter(mask: '##.###.###/####-##')
              .maskText(cleanedCpfCnpj)
          : MaskTextInputFormatter(mask: '###.###.###-##')
              .maskText(cleanedCpfCnpj);
    } else {
      cpfcontroller.text = ''; // Define vazio se não houver CPF ou CNPJ
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
          const TextTitle(text: 'Dados do pedido'),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.all(Style.height_15(context)),
            child: Column(
              children: [
                // Em COnstrução 🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧🚧
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if (widget.empresa_id.isEmpty)
                    //   Container(
                    //     child: PopupMenuButton<String>(
                    //       itemBuilder: (BuildContext context) =>
                    //           buildMenuItemsCompany(company),
                    //       onSelected: (value) async {
                    //         if (value != '') {
                    //           setState(() {
                    //             empresa_id = value;
                    //             // Busca o nome da empresa correspondente ao ID selecionado
                    //             final selectedCompany = company.firstWhere(
                    //               (company) => company.empresa_id == value,
                    //             );
                    //             empresa_nome = selectedCompany?.empresa_nome ??
                    //                 ''; // Atualiza o nome
                    //             empresa_codigo = selectedCompany?.empresa_codigo ??
                    //                 ''; // Atualiza o nome
                    //           });
                    //           setState(() {
                    //             empresa_id = value;
                    //           });
                    //         } else {
                    //           setState(() {
                    //             empresa_id = '';
                    //             empresa_nome = '';
                    //             empresa_codigo = '';
                    //           });
                    //         }
                    //       },
                    //       child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Icon(
                    //               Icons.arrow_drop_down_rounded,
                    //               color: Theme.of(context).colorScheme.primary,
                    //               size: Style.height_20(context),
                    //             ),
                    //             SizedBox(
                    //               width: Style.height_2(context),
                    //             ),
                    //             Container(
                    //               width: Style.width_180(context),
                    //               child: Text(
                    //                 empresa_nome.isEmpty
                    //                     ? 'Selecione a empresa'
                    //                     : '${empresa_codigo} - ${empresa_nome}',
                    //                 style: TextStyle(
                    //                   color: Style.primaryColor,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: Style.height_12(context),
                    //                 ),
                    //                 //textAlign: TextAlign.center,
                    //                 overflow: TextOverflow
                    //                     .clip, // corta o texto no limite da largura
                    //                 softWrap:
                    //                     true, // permite a quebra de linha conforme necessário
                    //               ),
                    //             )
                    //           ]),
                    //     ),
                    //   )
                    // else
                    //   Container(
                    //     width: Style.width_180(context),
                    //     child: Text(
                    //       '${empresa_codigo} - ${empresa_nome}',
                    //       style: TextStyle(
                    //         color: Style.primaryColor,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: Style.height_12(context),
                    //       ),
                    //       //textAlign: TextAlign.center,
                    //       overflow:
                    //           TextOverflow.clip, // corta o texto no limite da largura
                    //       softWrap:
                    //           true, // permite a quebra de linha conforme necessário
                    //     ),
                    //   ),
                    // if (flagpermitiralterartabela == '1')
                    //   Row(
                    //     children: [
                    //       SizedBox(
                    //         height: Style.height_30(context),
                    //         child: PopupMenuButton<String>(
                    //           itemBuilder: (BuildContext context) =>
                    //               buildMenuItemsTPrice(tables_price),
                    //           onSelected: (value) async {
                    //             setState(() {
                    //               tableprice = value;
                    //             });
                    //             await DataServiceTablePriceId.fetchDataTablePriceId(
                    //                 context, urlBasic, tableprice);
                    //             setState(() {
                    //               tableprice = value;
                    //               fetchDataTablePriceId();
                    //             });
                    //           },
                    //           child: Row(children: [
                    //             Icon(
                    //               Icons.arrow_drop_down_rounded,
                    //               color: Style.primaryColor,
                    //               size: Style.height_20(context),
                    //             ),
                    //             SizedBox(
                    //               width: Style.height_2(context),
                    //             ),
                    //             Container(
                    //               width: Style.width_150(context),
                    //               child: Text(
                    //                 tableprice.isEmpty
                    //                     ? 'Tabela de Preço'
                    //                     : tableprice,
                    //                 style: TextStyle(
                    //                   color: Style.primaryColor,
                    //                   fontWeight: FontWeight.bold,
                    //                   fontSize: Style.height_12(context),
                    //                 ),
                    //                 //textAlign: TextAlign.center,
                    //                 overflow: TextOverflow
                    //                     .clip, // corta o texto no limite da largura
                    //                 softWrap:
                    //                     true, // permite a quebra de linha conforme necessário
                    //               ),
                    //             ),
                    //           ]),
                    //         ),
                    //       ),
                    //     ],
                    //   )
                    // else
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         // width: 150,
                    //         child: Text(
                    //           tableprice,
                    //           style: TextStyle(
                    //             color: Style.quarantineColor,
                    //             fontWeight: FontWeight.bold,
                    //             fontSize: Style.height_12(context),
                    //           ),
                    //           textAlign: TextAlign.center,
                    //           overflow: TextOverflow
                    //               .clip, // corta o texto no limite da largura
                    //           softWrap:
                    //               true, // permite a quebra de linha conforme necessário
                    //         ),
                    //       )
                    //     ],
                    //   ),

                    if (empresaid != '')
                      Container(
                          width: Style.width_150(context),
                          child: InputBlocked(
                            value:
                                '${widget.empresa_codigo} - ${widget.empresa_nome}',
                          ))
                    else
                      Container(
                        width: Style.width_150(context),
                        child: Input(
                          controller: empresaController,
                          text: 'Empresa',
                          type: TextInputType.text,
                          textAlign: TextAlign.left,
                          IconButton: IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoadingIconButton = true;
                              });
                              await searchCompany(empresaController.text);
                              setState(() {
                                isLoadingIconButton = false;
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: Style.primaryColor,
                            ),
                          ),
                        ),
                      ),

                    if (flagpermitiralterartabela != 1)
                      Container(
                          width: Style.width_150(context),
                          child: InputBlocked(
                            value: tabelaController.text,
                          ))
                    else
                      Container(
                        width: Style.width_150(context),
                        child: Input(
                          controller: tabelaController,
                          text: 'Tabela de Preço',
                          type: TextInputType.text,
                          textAlign: TextAlign.left,
                          IconButton: IconButton(
                            onPressed: () async {
                              setState(() {
                                isLoadingIconButton = true;
                              });
                              await searchTablePrice('');
                              setState(() {
                                isLoadingIconButton = false;
                              });
                            },
                            icon: Icon(
                              Icons.search,
                              color: Style.primaryColor,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                Input(
                  text: 'CPF / CNPJ do Cliente',
                  type: TextInputType.text,
                  controller: cpfcontroller,
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
                        // await salvarLista(dataOrder);
                        // List<Map<String, dynamic>> listaSalva = await recuperarLista();
                        // print(listaSalva);
                        await GetCliente.getcliente(
                          context,
                          urlBasic,
                          _nomecontroller,
                          cpfcontroller,
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
                          child: RegisterButton(
                            text: buttonText,
                            color: Style.primaryColor,
                            width: Style.width_150(context),
                            isLoadingButton: isLoadingButton,
                            onPressed: () async {
                              final checkInternet =
                                  await hasInternetConnection();
                              setState(() {
                                isLoadingButton = true;
                              });
                              if (!checkInternet) {
                                final bodyMap = {
                                  'local_id': widget.local_id,
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
                                };
                                await adicionarDadosCliente(bodyMap);
                              } else {
                                await NewCustomer.getCostumer(
                                    context,
                                    urlBasic,
                                    token,
                                    widget.prevendaid,
                                    widget.pessoaid,
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
                                    ibge,
                                    _emailcontroller.text,
                                    _ufcontroller.text,
                                    widget.empresa_id,
                                    widget.tabelapreco_id,
                                    double.parse(substituirVirgulaPorPonto(
                                            valordescontoController.text)) ??
                                        0.0,
                                    permCadastrarCliente,
                                    permEditarCliente,
                                    permEditarPrevenda);
                              }
                              setState(() {
                                isLoadingButton = false;
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
    setState(() {
      permAplicarDesconto = savedAplicarDesconto;
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
      empresaid = savedEmpresaID;
    });
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
      _loadSavedEmpresaID(),
      _loadSavedIbge(),
      _loadSavedCheckCPF(),
      _loadSavedFlagGerarPedido(),
      _loadSavedPermEditarPrevenda(),
      _loadSavedPermCadastrarCliente(),
      _loadSavedPermEditarCliente(),
      _loadSavedPermAplicarDesconto(),
      _loadSavedPermNovoPedido(),
    ]);

    print(empresaid);
    print(widget.tabelapreco_id);

    final hasInternet = await hasInternetConnection();
    final dataCustomer = await recuperarDadosCliente();
    clienteFiltrado = dataCustomer
        .where((dataCustomer) => dataCustomer['local_id'] == widget.local_id)
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
      });
    }
    await Future.wait([
      fetchDataOrders(),
      searchCompany(widget.empresa_id),
      searchTablePrice(widget.tabelapreco_id)
    ]);
    await Future.wait([
      fetchDataSeller(),
    ]);
    //}
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
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao pesquisar vendedor: $e');
    }
  }

  Future<void> searchCompany(String empresa_id) async {
    try {
      var urlGetCompany = Uri.parse(
          '''$urlBasic/ideia/core/getdata/empresa%20e%20WHERE%20(e.empresa_id%20=%20'${empresa_id}'%20OR%20e.empresa_codigo%20=%20'${empresaController.text}'%20OR%20e.empresa_nome%20LIKE%20'${empresaController.text}')/''');
      var response =
          await http.get(urlGetCompany, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var dataList = jsonData['data'].keys.first;
        var dataMap = jsonData['data'] as Map<String, dynamic>;

        if (dataMap.isNotEmpty) {
          var companyList = dataMap[dataList] as List;
          var company = companyList.first;
          setState(() {
            empresaController.text =
                '${company['empresa_codigo']} - ${company['empresa_nome']}';
            flagpermitiralterartabela = company['flagpermitiralterartabela'] ??
                flagpermitiralterartabela;
            // empresaid = company['empresa_id'];
          });
          print(flagpermitiralterartabela);
        } else {
          print('Lista vazia: ${response.body}');
        }
      } else {
        print('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição searchCompany: $e');
    }
  }

  Future<void> searchTablePrice(String tabPrecoId) async {
    try {
      var urlGetCompany = Uri.parse(
          '''$urlBasic/ideia/core/getdata/tabelapreco%20t%20WHERE%20(t.tabelapreco_id%20=%20'${tabPrecoId}'%20OR%20t.codigo%20=%20'${tabelaController.text}'%20OR%20t.nome%20LIKE%20'${tabelaController.text}')/''');
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
            //tabelapreco_id = tabPrice['tabelapreco_id'];
          });
          print(tabelaController.text);
        } else {
          print('Lista vazia: ${response.body}');
        }
      } else {
        print('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição searchCompany: $e');
    }
  }

  Future<void> finishOrder() async {
    if (empresaController.text.isEmpty && tabelaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            'Por favor, selecione a empresa e a tabela de preço para finalizar o pedido.',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
              color: Style.tertiaryColor,
            ),
          ),
          backgroundColor: Style.errorColor,
        ),
      );
      setState(() {
        isLoadingIconButton = false;
      });
      return;
    }
    if (isCheckedCPF == true) {
      if (cpfcontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Por favor, preencha o CPF do cliente',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
        setState(() {
          isLoadingIconButton = false;
        });
      } else if (_telefonecontatocontroller.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Por favor, preencha o telefone do cliente',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Por favor, preencha o nome do cliente',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
        setState(() {
          isLoadingIconButton = false;
        });
      } else if (orders.isEmpty || widget.noProduct == '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Não é possível finalizar o pedido sem produtos.',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
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
    } else if (orders.isEmpty || widget.noProduct == '1') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            'Não é possível finalizar o pedido sem produtos.',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
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
      final data = await DataServiceCliente2.fetchDataCliente2(
          urlBasic, cpfcontroller.text, token);
      var pessoa_id = data['pessoa_id'].toString();
      if (permEditarPrevenda) {
        await NewCustomer.AdjustOrder(
            context,
            urlBasic,
            token,
            _nomecontroller.text,
            cpfcontroller.text,
            _telefonecontatocontroller.text,
            widget.prevendaid,
            pessoa_id,
            vendedorId,
            double.parse(
                    substituirVirgulaPorPonto(valordescontoController.text)) ??
                0.0,
            widget.empresa_id,
            widget.tabelapreco_id);
        _openModal(context);
        setState(() {
          isLoadingIconButton = false;
        });
      } else
        _openModal(context);
    }
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
          height: Style.height_10(context),
        ),
        RegisterIconButton(
          text: 'Aplicar Desconto',
          color: Style.primaryColor,
          width: Style.height_150(context),
          icon: Icons.money_off_csred_rounded,
          onPressed: () async {
            if (permAplicarDesconto == false && flagprivilegiado == 0) {
              showDialog(
                  context: context, builder: (_) => AlertDialogDefault());
            } else {
              await NewCustomer.AdjustOrder(
                  context,
                  urlBasic,
                  token,
                  _nomecontroller.text,
                  cpfcontroller.text,
                  _telefonecontatocontroller.text,
                  widget.prevendaid,
                  pessoa_id.toString(),
                  vendedorId,
                  double.parse(substituirVirgulaPorPonto(
                          valordescontoController.text)) ??
                      0.0,
                  widget.empresa_id,
                  widget.tabelapreco_id);
              Navigator.of(context).pop();
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

  Future<void> fetchDataListTablesPrice(String empresa_id) async {
    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final listTablePricesOff = await recuperarListaTabPreco();
      setState(() {
        flagpermitiralterartabela = 1;
        tables_price = listTablePricesOff;
      });
    } else {
      List<ListTablePrices>? fetchedData =
          await DataServiceListTablePrices.fetchDataListTablePrices(
              context, urlBasic, empresa_id, token);
      if (fetchedData != null) {
        final listaMap = fetchedData.map((e) => e.toJson()).toList();
        await salvarListaTabPreco(listaMap);
        setState(() {
          tables_price = fetchedData;
        });
      }
    }
  }

  List<PopupMenuItem<String>> buildMenuItemsTPrice(
      List<ListTablePrices> tablesPrice) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tab. Preço'),
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

    List<PopupMenuItem<String>> dynamicItems = tablesPrice.map((tables) {
      return PopupMenuItem<String>(
        value: tables.nome,
        child: Text((tables.nome).toString()),
      );
    }).toList();

    return staticItems + dynamicItems;
  }

  List<PopupMenuItem<String>> buildMenuItemsCompany(
      List<CompanyList> companyList) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Empresa'),
              Container(
                margin: EdgeInsets.only(bottom: Style.height_5(context)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Style.height_5(context)),
                    color: Style.errorColor),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

    List<PopupMenuItem<String>> dynamicItems = companyList.map((companys) {
      return PopupMenuItem<String>(
        value: companys.empresa_id,
        child: Text(('${companys.empresa_codigo} - ${companys.empresa_nome}')
            .toString()),
        key: Key(companys.empresa_nome.toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return staticItems + dynamicItems;
  }

  Future<void> fetchDataTablePriceId() async {
    Map<String, dynamic>? fetchedDataTablePriceId =
        await DataServiceTablePriceId.fetchDataTablePriceId(
            context, urlBasic, tableprice);
    if (fetchedDataTablePriceId != null) {
      setState(() {
        tabelapreco_id = fetchedDataTablePriceId['tabelapreco_id'] ?? '';
      });
    }
  }

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
        empresaid,
      );

      if (fetchedData != null) {
        final listaMap = fetchedData.map((e) => e.toJson()).toList();
        await salvarListaEmpresa(listaMap);
        setState(() {
          company = fetchedData;
        });
        if (empresaid.isNotEmpty) {
          setState(() {
            empresa_nome = company.first.empresa_nome.toString();
            empresa_codigo = company.first.empresa_codigo.toString();
          });
        }
      }
    }
  }
}
