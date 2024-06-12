import 'package:flutter/material.dart';
import 'package:projeto/back/login_function.dart';
import 'package:projeto/back/save_user_function.dart';
import 'package:projeto/front/components/Login_Config/Elements/input.dart';
import 'package:projeto/front/components/Login_Config/elements/button.dart';
import 'package:projeto/front/components/Login_Config/elements/config_button.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/login_config/structure/form_card.dart';
import 'package:projeto/front/pages/config.dart';
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
  String urlController = '';
  final SaveUserService saveUserService = SaveUserService();
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userController.text = '';
    _passwordController.text = '';

    _loadSavedUrl();
    saveUserService.listenAndSaveUser(context, _userController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedUser();
    _loadSavedUrl();
  }

  Future<void> _loadSavedUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrl = sharedPreferences.getString('saveUrl') ?? '';
    setState(() {
      urlController = savedUrl;
    });
  }

  Future<void> _loadSavedUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUser = await sharedPreferences.getString('saveUser') ?? '';
    setState(() {
      _userController.text = savedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Chamando a navbar
              Navbar(children: [
                //Chamando os elementos internos da navbar
              ], text: 'Login'),
              Container(
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
                          validator: (user) {
                            if (user == null || user.isEmpty) {
                              saveUserService.saveUser(context, _userController.text);
                            }
                          },
                        ),
                        SizedBox(
                          height: Style.InputSpace(context),
                        ),
                        Input(
                          text: 'Senha',
                          type: TextInputType.text,
                          obscureText: true,
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: Style.InputToButtonSpace(context),
                        ),
                        ButtonConfig(
                          text: 'Entrar',
                          onPressed: () async {
                            if (_userController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty) {
                              await LoginFunction.login(
                                context,
                                urlController,
                                _userController,
                                _passwordController,
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
                          },
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                        ButtomInitial(
                          text: 'Configurar',
                          destination: ConfigPage(initialUrl: urlController),
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
