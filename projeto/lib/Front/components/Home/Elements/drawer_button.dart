import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/home/elements/modal_button.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String token = '';
  String login = '';
  String image = '';
  String url = '';
  String urlBasic = '';
  String email = '';

  // bool check = true;

  bool isCheckedCPF = true;
  bool isCheckedProduct = false;

  bool flagService = false;
  bool flagGerarPedido = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  void _closeDrawer() {
    //Função para fechar o modal
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: WillPopScope(
            child: Drawer(
                // width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        // height: Style.DrawerHeaderSize(context),
                        decoration:
                            const BoxDecoration(color: Style.primaryColor),
                        child: Container(
                          padding: EdgeInsets.all(Style.height_15(context)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: _closeDrawer,
                                    icon: const Icon(Icons.close),
                                    iconSize:
                                        Style.IconCloseDrawerSize(context),
                                    alignment: Alignment.topRight,
                                    style: const ButtonStyle(
                                      iconColor: WidgetStatePropertyAll(
                                          Style.tertiaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: Style.SalesCardSpace(context),
                              // ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: Style.height_25(context))),
                                      SizedBox(
                                        width: Style.AccountNameWidth(context),
                                        height: Style.AccountNameWidth(context),
                                        // decoration: BoxDecoration(shape: BoxShape.circle),
                                        child: ClipOval(
                                          child: image.isNotEmpty
                                              ? Image.network(
                                                  urlBasic + image,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ) // Exibe a imagem
                                              : Image.asset(
                                                  "assets/images/icon_person/icon_person.png",
                                                  color: Style.tertiaryColor,
                                                  alignment:
                                                      Alignment.topCenter,
                                                  fit: BoxFit.cover,
                                                  filterQuality:
                                                      FilterQuality.high,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Style.height_10(context),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Olá, $login!',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize:
                                                  Style.LoginFontSize(context),
                                              color: Style.tertiaryColor,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            email,
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize:
                                                  Style.EmailFontSize(context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Style.ModalButtonSpace(context),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    child: const ModalButton(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: Style.height_15(context),
                        top: Style.height_12(context),
                        bottom: Style.height_8(context),
                      ),
                      child: Text(
                        '⚙️ Configurações',
                        style: TextStyle(
                            fontSize: Style.height_15(context),
                            fontWeight: FontWeight.bold,
                            color: Style.primaryColor),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Checkbox(
                      value: isCheckedCPF,
                      onChanged: (value) async {
                        setState(() {
                          isCheckedCPF = value!;
                        });
                        print('Value: $isCheckedCPF');
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setBool(
                            'checkCPF', isCheckedCPF);
                      },
                    ),
                    Text(
                      'Ativar CPF obrigatório?',
                      style: TextStyle(
                          color: Style.primaryColor,
                          fontSize: Style.height_12(context)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedProduct,
                      onChanged: (value) async {
                        setState(() {
                          isCheckedProduct = value!;
                        });
                        print('Value: $isCheckedProduct');
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setBool(
                            'checkProduct', isCheckedProduct);
                      },
                    ),
                    Container(
                      width: Style.width_225(context),
                      child: Text(
                        'Ativar adicionar produtos em massa ao pedido?',
                        style: TextStyle(
                            color: Style.primaryColor,
                            fontSize: Style.height_12(context)),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: flagService,
                      onChanged: (value) async {
                        setState(() {
                          flagService = value!;
                        });
                        print('Value: $flagService');
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setBool(
                            'flagService', flagService);
                      },
                    ),
                    Container(
                      width: Style.width_225(context),
                      child: Text(
                        'Ativar modo venda de serviços?',
                        style: TextStyle(
                            color: Style.primaryColor,
                            fontSize: Style.height_12(context)),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: flagGerarPedido,
                      onChanged: (value) async {
                        setState(() {
                          flagGerarPedido = value!;
                        });
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setBool(
                            'flagGerarPedido', flagGerarPedido);
                      },
                    ),
                   Container(
                      width: Style.width_225(context),
                      child: Text(
                        'Gerar pedido de venda ao finalizar pré-venda',
                        style: TextStyle(
                            color: Style.primaryColor,
                            fontSize: Style.height_12(context)),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    Container(
                      width: Style.height_30(context),
                      height: Style.height_15(context),
                      decoration: BoxDecoration(
                        color: Style.primaryColor,
                        borderRadius: BorderRadius.circular(
                          Style.height_10(context)
                        )
                      ),
                      child: Center(
                        child: Text(
                        'Beta',
                        style: TextStyle(
                          color: Style.tertiaryColor,
                          fontSize: Style.height_8(context)
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ) 
                    )
                  ],
                ),
              ],
            )),
            onWillPop: () async {
              _closeDrawer();
              return true;
            }));
  }

  Future<void> loadData() async {
    await _loadSavedFlagService();
    await _loadSavedCheckCPF();
    await _loadSavedCheckProduct();
    await Future.wait([
      _loadSavedUrl(),
      _loadSavedToken(),
      _loadSavedLogin(),
      _loadSavedImage(),
      _loadSavedUrlBasic(),
      _loadSavedEmail(),
      _loadSavedFlagGerarPedido(),
    ]);
  }

  Future<void> _loadSavedFlagService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagService = sharedPreferences.getBool('flagService') ?? false; // Carrega o valor salvo (padrão: false)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagGerarPedido = sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      flagGerarPedido = savedFlagGerarPedido;
    });
  }

  Future<void> _loadSavedCheckCPF() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckCPF = sharedPreferences.getBool('checkCPF') ?? true; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedCPF = savedCheckCPF; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedCheckProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ?? false; // Carrega o valor salvo (padrão: false)
    setState(() {
      isCheckedProduct = savedCheckProduct; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrl = sharedPreferences.getString('url') ?? '';
    setState(() {
      url = savedUrl;
    });
  }

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
    });
  }

  Future<void> _loadSavedLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedLogin = sharedPreferences.getString('login') ?? '';
    setState(() {
      login = savedLogin;
    });
  }

  Future<void> _loadSavedImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedImage = sharedPreferences.getString('image') ?? '';
    setState(() {
      image = savedImage;
    });
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _loadSavedEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = sharedPreferences.getString('email') ?? '';
    setState(() {
      email = savedEmail;
    });
  }
}
