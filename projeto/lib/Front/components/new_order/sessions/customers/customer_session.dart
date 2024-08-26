import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:projeto/back/finish_order.dart';
import 'package:projeto/back/get_cep.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/new_customer.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSession extends StatefulWidget {
  final prevendaid;
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

  final numpedido;

  const CustomerSession(
      {Key? key,
      this.prevendaid,
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
      this.numpedido});

  @override
  State<CustomerSession> createState() => _CustomerSessionState();
}

class _CustomerSessionState extends State<CustomerSession> {
  late BuildContext modalContext;

  String urlBasic = '';
  String token = '';
  String ibge = '';
  String cpf = '';

  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    print(widget.cidade);
    _cepcontroller.text = widget.cep;
    _bairrocontroller.text = widget.bairro.toString();
    _localidadecontroller.text = widget.cidade ?? '';
    _numerocontroller.text = widget.numero ?? '';
    _ibgecontroller.text = widget.ibge.toString();
    _complementocontroller.text = widget.complemento.toString();
    _ufcontroller.text = widget.uf.toString();
    _logradourocontroller.text = widget.endereco.toString();
    _nomecontroller.text = widget.pessoanome == null ? '' : widget.pessoanome;
    _cpfcontroller.text = widget.cpfcnpj;
    _telefonecontatocontroller.text = widget.telefone;
  }

  @override
  Widget build(BuildContext context) {
    //  if (isLoading) {
    //   return Material(
    //     child:  Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    return Material(
      child: Column(
        children: [
          TextTitle(text: 'Dados do cliente'),
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
                  controller: _cpfcontroller == null ? '' : _cpfcontroller,
                  inputFormatters: [MaskedInputFormatter('000.000.000-00')],
                  textAlign: TextAlign.start,
                  IconButton: IconButton(
                      onPressed: () async {
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
                        );
                      },
                      icon: Icon(Icons.person_search)),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Telefone',
                  type: TextInputType.text,
                  controller: _telefonecontatocontroller == null
                      ? ''
                      : _telefonecontatocontroller,
                  textAlign: TextAlign.start,
                  inputFormatters: [MaskedInputFormatter('(00) 00000-0000')],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Nome do cliente',
                  type: TextInputType.text,
                  controller: _nomecontroller.text.isEmpty ? '' : _nomecontroller,
                  textAlign: TextAlign.start,
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
                  IconButton: IconButton(
                      onPressed: () async {
                        await GetCep.getcep(
                          _cepcontroller,
                          _logradourocontroller,
                          _complementocontroller,
                          _bairrocontroller,
                          _ufcontroller,
                          _localidadecontroller,
                          _ibgecontroller,
                        );
                      },
                      icon: Icon(Icons.screen_search_desktop_sharp)),
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.width_215(context),
                          child: Input(
                              controller: _logradourocontroller,
                              textAlign: TextAlign.start,
                              text: 'Endereço',
                              type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_100(context),
                          child: Input(
                              controller: _ufcontroller,
                              textAlign: TextAlign.start,
                              text: 'UF',
                              type: TextInputType.text),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.width_140(context),
                          child: Input(
                              controller: _bairrocontroller,
                              textAlign: TextAlign.start,
                              text: 'Bairro',
                              type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_180(context),
                          child: Input(
                              controller: _localidadecontroller,
                              textAlign: TextAlign.start,
                              text: 'Cidade',
                              type: TextInputType.text),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.width_215(context),
                          child: Input(
                              controller: _complementocontroller,
                              textAlign: TextAlign.start,
                              text: 'Complemento',
                              type: TextInputType.text),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_100(context),
                          child: Input(
                              controller: _numerocontroller,
                              textAlign: TextAlign.start,
                              text: 'Número',
                              type: TextInputType.text),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: Style.height_20(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: Style.width_150(context),
                          child: RegisterButton(
                            text: 'Cadastrar cliente',
                            color: Style.primaryColor,
                            width: Style.width_150(context),
                            onPressed: () async {
                              await NewCustomer.getcliente(
                                  context,
                                  urlBasic,
                                  token,
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
                                  _ufcontroller.text);
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: Style.width_150(context),
                          child: Column(
                            children: [
                              RegisterIconButton(
                                onPressed: () async {
                                  if (_cpfcontroller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(
                                            Style.SaveUrlMessagePadding(
                                                context)),
                                        content: Text(
                                          'Por favor, preencha o CPF do cliente',
                                          style: TextStyle(
                                            fontSize: Style.SaveUrlMessageSize(
                                                context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.errorColor,
                                      ),
                                    );
                                  } else if (_telefonecontatocontroller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(
                                            Style.SaveUrlMessagePadding(
                                                context)),
                                        content: Text(
                                          'Por favor, preencha o telefone do cliente',
                                          style: TextStyle(
                                            fontSize: Style.SaveUrlMessageSize(
                                                context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.errorColor,
                                      ),
                                    );
                                  } else if (_nomecontroller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        padding: EdgeInsets.all(
                                            Style.SaveUrlMessagePadding(
                                                context)),
                                        content: Text(
                                          'Por favor, preencha o nome do cliente',
                                          style: TextStyle(
                                            fontSize: Style.SaveUrlMessageSize(
                                                context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.errorColor,
                                      ),
                                    );
                                  } else {
                                     _openModal(context);
                                  }
                                },
                                text: 'Finalizar pedido',
                                color: Style.sucefullColor,
                                width: Style.width_150(context),
                                icon: Icons.check_rounded,
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
        return Container(
            //Configurações de tamanho e espaçamento do modal
            height: Style.height_300(context),
            child: WillPopScope(
                child: Container(
                  //Tamanho e espaçamento interno do modal
                  height: Style.InternalModalSize(context),
                  margin: EdgeInsets.only(
                      left: Style.ModalMargin(context),
                      right: Style.ModalMargin(context)),
                  padding: EdgeInsets.all(Style.InternalModalPadding(context)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          Style.ModalBorderRadius(context))),
                  child: Column(
                    //Conteúdo interno do modal
                    children: [
                      Row(
                        children: [
                          Text(
                            'Como deseja finalizar este pedido?',
                            style: TextStyle(
                              fontSize: Style.height_15(context),
                              color: Style.primaryColor,
                            ),
                            overflow: TextOverflow.clip,
                            softWrap: true,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Style.height_30(context),
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
                                  widget.numpedido);
                            },
                            child: Container(
                              // width: Style.width_200(context),
                              // height: Style.ButtonExitHeight(context),
                              padding: EdgeInsets.all(
                                  Style.ButtonExitPadding(context)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Style.ButtonExitBorderRadius(context)),
                                  color: Style.primaryColor),
                              child: Text(
                                'Apenas Finalizar ✅',
                                style: TextStyle(
                                  color: Style.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Style.height_10(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
                                      widget.numpedido);
                            },
                            child: Container(
                              // width: Style.ButtonCancelWidth(context),
                              // height: Style.ButtonCancelHeight(context),
                              padding: EdgeInsets.all(
                                  Style.ButtonCancelPadding(context)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Style.ButtonExitBorderRadius(context)),
                                border: Border.all(
                                    width: Style.WidthBorderImageContainer(
                                        context),
                                    color: Style.tertiaryColor),
                                color: Style.primaryColor,
                              ),
                              child: Text(
                                'Finalizar e imprimir local 🖨️',
                                style: TextStyle(
                                  color: Style.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Style.height_10(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
                                      widget.numpedido);
                            },
                            child: Container(
                              // width: Style.ButtonCancelWidth(context),
                              // height: Style.ButtonCancelHeight(context),
                              padding: EdgeInsets.all(
                                  Style.ButtonCancelPadding(context)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Style.ButtonExitBorderRadius(context)),
                                border: Border.all(
                                    width: Style.WidthBorderImageContainer(
                                        context),
                                    color: Style.primaryColor),
                                color: Style.primaryColor,
                              ),
                              child: Text(
                                'Finalizar e imprimir na rede ⇅',
                                style: TextStyle(
                                  color: Style.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Style.height_10(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
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

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
    ]);
    await Future.wait([
      // fetchDataCliente2(),
      // initializer(),
    ]);
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }
}
