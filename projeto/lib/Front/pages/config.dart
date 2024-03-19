import 'package:flutter/material.dart';
import 'package:projeto/Back/SaveUrl.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Login_Config/Elements/ButtonConfig.dart';
import 'package:projeto/Front/components/Login_Config/Elements/input.dart';
import 'package:projeto/Front/components/Login_Config/Estructure/form-card.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  final String initialUrl;

  const ConfigPage({super.key, this.initialUrl = ''});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  TextEditingController urlController = TextEditingController();
  final SaveUrlService saveUrlService = SaveUrlService();

  @override
  void initState() {
    super.initState();
    urlController.text = widget.initialUrl;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _loadSavedUrl();
  // }

  Future<void> _loadSavedUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrl = sharedPreferences.getString('saveUrl') ?? '';
    setState(() {
      urlController.text = savedUrl;
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
              ], text: 'Configurações'),
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
                          height: Style.ImageToInputSpace,
                        ),
                        //Chamando elementos para dentro do container
                        Input(
                          type: TextInputType.text,
                          text: 'Configuração de IP',
                          obscureText: false,
                          controller: urlController,
                        ),
                        SizedBox(
                          height: Style.InputToButtonSpace,
                        ),
                        Column(
                          children: [
                            Row(
                              //Alinhamento dos buttons
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Chamando os button
                                ButtonConfig(
                                  text: 'Salvar',
                                  onPressed: () {
                                    saveUrlService.saveUrl(
                                        context, urlController.text);
                                  },
                                  height:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                SizedBox(
                                  width: Style.ButtonSpace,
                                ),
                                ButtonConfig(
                                  text: 'Voltar',
                                  onPressed: () async {
                                    String url = urlController.text;
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LoginPage(url: url),
                                      ),
                                    );
                                  },
                                  height:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ],
                            ),
                          ],
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
