import 'package:flutter/material.dart';
import 'package:projeto/back/finish_order.dart';
import 'package:projeto/back/get_cep.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/new_customer.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Login_Config/Elements/input.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/pages/home.dart';
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
  String urlBasic = '';
  String token = '';
  String ibge = '';
  String cpf = '';

  // late String pessoaid = '';
  // late String nome = '';
  // late String codigo = '';
  // late String cpfcliente = '';
  // late String telefone = '';
  // late String enderecocep = '';
  // late String endereco = '';
  // late String enderecobairro = '';
  // late String enderecocomplemento = '';
  // late String uf = '';

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
    // TODO: implement initState
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    // loadData();
    // cpf = widget.cpfcnpj;
    _cepcontroller.text = widget.cep;
    _bairrocontroller.text = widget.bairro.toString();
    _localidadecontroller.text = widget.cidade ?? '';
    _numerocontroller.text = widget.numero ?? '';
    _ibgecontroller.text = widget.ibge.toString();
    _complementocontroller.text = widget.complemento.toString();
    _ufcontroller.text = widget.uf.toString();
    _logradourocontroller.text = widget.endereco.toString();
    _nomecontroller.text = widget.pessoanome;
    _cpfcontroller.text = widget.cpfcnpj;
    _telefonecontatocontroller.text = widget.telefone;
    print(widget.prevendaid);
    // print(widget.cpfcnpj);
    // _loadSavedComplemento();
    // _loadSavedLogradouro();
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
                  controller: _cpfcontroller,
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
                  controller: _telefonecontatocontroller,
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Nome do cliente',
                  type: TextInputType.text,
                  controller: _nomecontroller,
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
                                  await DataServiceFinishOrder
                                      .fetchDataFinishOrder(
                                    context,
                                    urlBasic,
                                    token,
                                    widget.prevendaid.toString(),
                                    widget.numpedido.toString(),
                                  );
                                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => Home()));
                                },
                                text: 'Finalizar pedido',
                                color: Style.sucefullColor,
                                width: Style.height_150(context),
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

  // Future<void> initializer() async {
  //   setState(() {
  //     _cepcontroller.text = enderecocep;
  //   });
  // }

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

//   Future<void> fetchDataCliente2() async {
//   final data = await DataServiceCliente2.fetchDataCliente2(urlBasic, widget.cpfcnpj);
//   setState(() {
//     pessoaid = data['pessoa_id'].toString();
//     nome = data['nome'].toString();
//     cpfcliente = data['cpf'].toString();
//     telefone = data['telefone'].toString();
//     endereco = data['endereco'].toString();
//     enderecobairro = data['enderecobairro'].toString();
//     enderecocomplemento = data['enderecocomplemento'].toString();
//     enderecocep = data['enderecocep'].toString();
//     uf = data['uf'].toString();
//     codigo = data['codigo'].toString();

//     // Atualiza os controladores com os novos valores
//     _cepcontroller.text = enderecocep;
//     _bairrocontroller.text = enderecobairro;
//     _complementocontroller.text = enderecocomplemento;
//     _ufcontroller.text = uf;
//     _logradourocontroller.text = endereco;
//     _nomecontroller.text = nome;
//     _cpfcontroller.text = cpfcliente ;
//     _telefonecontatocontroller.text = telefone;
//   });
// }
}
