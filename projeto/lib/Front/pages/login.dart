import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/system/login_function.dart';
import 'package:projeto/back/system/save_user_function.dart';
import 'package:projeto/front/components/login_config/elements/button.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/login_config/elements/input_action.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/login_config/structure/form_card.dart';
import 'package:projeto/front/pages/config.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String url;

  const LoginPage({
    super.key,
    this.url = '',
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String urlController = '', token = '', version = '';
  final SaveUserService saveUserService = SaveUserService();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  bool flagLoadEntrar = false, flagRememberMe = false;

  @override
  void initState() {
    super.initState();
    //verifyToken();
    _userController.text = '';
    _passwordController.text = '';
    loadSavedFlagRememberMe();
    _loadSavedUrl();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedUser();
    _loadSavedPassword();
    _loadSavedToken();
    _loadSavedUrl();
  }

  Future<void> _loadSavedUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrl = sharedPreferences.getString('saveUrl') ?? '';
    setState(() {
      urlController = savedUrl;
    });
  }

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
    });
  }

  Future<void> _loadSavedUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUser = sharedPreferences.getString('saveUser') ?? '';
    setState(() {
      _userController.text = savedUser;
    });
  }

  Future<void> _loadSavedPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedPassword = sharedPreferences.getString('savePass') ?? '';
    setState(() {
      _passwordController.text = savedPassword;
    });
  }

  Future<void> verifyToken() async {
    final checkInternet = await hasInternetConnection();
    if (!checkInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 7),
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Style.width_200(context),
                child: Text(
                  overflow: TextOverflow.clip,
                  'Sem conexão com a Internet, porém, token ara login ainda válido',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Home(),
                      ),
                    );
                  },
                  child: Text('Entrar'))
            ],
          ),
          backgroundColor: Style.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Chamando a navbar
              const Navbar(text: 'Login', children: [
                //Chamando os elementos internos da navbar
              ]),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Chamando o container com os elementos para login
                    FormCard(
                      children: [
                        SizedBox(
                          height: Style.height_50(context),
                        ),
                        Input(
                          text: 'Usuário',
                          type: TextInputType.text,
                          obscureText: false,
                          controller: _userController,
                          textAlign: TextAlign.start,
                          validator: (user) {
                            // if (user == null || user.isEmpty) {
                            //   saveUserService.saveUser(
                            //       context, _userController.text);
                            // }
                          },
                        ),
                        SizedBox(
                          height: Style.InputSpace(context),
                        ),
                        InputAction(
                          text: 'Senha',
                          type: TextInputType.text,
                          obscureText: true,
                          controller: _passwordController,
                          textAlign: TextAlign.start,
                          onSubmitted: (value) async {
                            if (_userController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              await LoginFunction.login(
                                context,
                                urlController,
                                _userController.text,
                                _passwordController.text,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Por favor, preencha todos os campos',
                                    style: TextStyle(
                                      fontSize: Style.height_12(context),
                                      color: Style.tertiaryColor,
                                    ),
                                  ),
                                  backgroundColor: Style.errorColor,
                                ),
                              );
                            }
                            setState(() {
                              flagLoadEntrar = false;
                            });
                          },
                        ),
                        SizedBox(
                          height: Style.height_30(context),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Lembrar meu login',
                                style: TextStyle(
                                  fontSize: Style.height_12(context),
                                  color: Style.primaryColor,
                                ),
                              ),
                              SizedBox(
                                width: Style.width_10(context),
                              ),
                              Switch(
                                activeColor: Style.secondaryColor,
                                value: flagRememberMe,
                                onChanged: (value) async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  if (!value) {
                                    sharedPreferences.remove('saveUser');
                                    sharedPreferences.remove('savePass');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Usuário e senha removidos',
                                          style: TextStyle(
                                            fontSize: Style.height_12(context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.warningColor,
                                      ),
                                    );
                                  } else {
                                    saveUserService.saveUser(
                                        context,
                                        _userController.text,
                                        _passwordController.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                          'Usuário e senha salvos para futuras sessões',
                                          style: TextStyle(
                                            fontSize: Style.height_12(context),
                                            color: Style.tertiaryColor,
                                          ),
                                        ),
                                        backgroundColor: Style.sucefullColor,
                                      ),
                                    );
                                  }
                                  setState(() {
                                    flagRememberMe = value;
                                  });
                                  await sharedPreferences.setBool(
                                      'rememberMe', value);
                                },
                              ),
                            ]),
                        SizedBox(
                          height: Style.height_20(context),
                        ),
                        ButtonConfig(
                          isLoadingButton: flagLoadEntrar,
                          text: 'Entrar',
                          onPressed: () async {
                            setState(() {
                              flagLoadEntrar = true;
                            });
                            final checkInternet = await hasInternetConnection();
                            if (flagRememberMe) {
                              saveUserService.saveUser(
                                  context,
                                  _userController.text,
                                  _passwordController.text);
                            }
                            if (!checkInternet) {
                              if (_userController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                await sharedPreferences.setString(
                                    'login_usuario', _userController.text);
                                await sharedPreferences.setString(
                                    'senha_usuario', _passwordController.text);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Por favor, preencha todos os campos',
                                      style: TextStyle(
                                        fontSize: Style.height_12(context),
                                        color: Style.tertiaryColor,
                                      ),
                                    ),
                                    backgroundColor: Style.errorColor,
                                  ),
                                );
                              }
                            } else {
                              if (_userController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                await LoginFunction.login(
                                  context,
                                  urlController,
                                  _userController.text,
                                  _passwordController.text,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                      'Por favor, preencha todos os campos',
                                      style: TextStyle(
                                        fontSize: Style.height_12(context),
                                        color: Style.tertiaryColor,
                                      ),
                                    ),
                                    backgroundColor: Style.errorColor,
                                  ),
                                );
                              }
                            }

                            setState(() {
                              flagLoadEntrar = false;
                            });
                          },
                          height: Style.height_20(context),
                        ),
                        ButtomInitial(
                          text: 'Configurar',
                          destination: ConfigPage(initialUrl: urlController),
                          height: Style.height_20(context),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Style.height_20(context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Versão: $version',
                          style: TextStyle(
                            fontSize: Style.height_10(context),
                            color: Style.quarantineColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadSavedFlagRememberMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      flagRememberMe = sharedPreferences.getBool('rememberMe') ?? false;
    });
  }
}
