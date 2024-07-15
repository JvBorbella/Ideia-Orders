import 'package:flutter/material.dart';
import 'package:projeto/back/get_cep.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/Login_Config/Elements/input.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerSession extends StatefulWidget {
  const CustomerSession({super.key});

  @override
  State<CustomerSession> createState() => _CustomerSessionState();
}

class _CustomerSessionState extends State<CustomerSession> {
  String urlBasic = '';
  
  final _cepcontroller = TextEditingController();
  final _complementocontroller = TextEditingController();
  final _bairrocontroller = TextEditingController();
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
    _cepcontroller.text = '';
    _bairrocontroller.text = '';
    _complementocontroller.text = '';
    _ufcontroller.text = '';
    _logradourocontroller.text = '';
    _nomecontroller.text = '';
    _cpfcontroller.text = '';
    _telefonecontatocontroller.text = '';
    // _loadSavedComplemento();
    // _loadSavedLogradouro();
  }

  @override
  Widget build(BuildContext context) {
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
                          _complementocontroller,
                          _bairrocontroller,
                          _ufcontroller,
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
                  ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  text: 'Nome do cliente', 
                  type: TextInputType.text,
                  controller: _nomecontroller,
                  ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Input(
                  controller: _cepcontroller,
                  text: 'CEP',
                  type: TextInputType.number,
                  IconButton: IconButton(
                      onPressed: () async {
                        await GetCep.getcep(
                          _cepcontroller,
                          _logradourocontroller,
                          _complementocontroller,
                          _bairrocontroller,
                          _ufcontroller,
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
                              controller: _complementocontroller,
                              text: 'Complemento',
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
                                onPressed: () {
                                  print('teste');
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
}
