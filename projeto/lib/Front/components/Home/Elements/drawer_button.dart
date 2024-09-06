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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSavedUrl();
    _loadSavedToken();
    _loadSavedLogin();
    _loadSavedImage();
    _loadSavedUrlBasic();
    _loadSavedEmail();
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
                  decoration: const BoxDecoration(color: Style.primaryColor),
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
                              iconSize: Style.IconCloseDrawerSize(context),
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
                                Padding(padding: EdgeInsets.only(left: Style.height_25(context))),
                                SizedBox(
                                  width: Style.AccountNameWidth(context),
                                  height: Style.AccountNameWidth(context),
                                  // decoration: BoxDecoration(shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: image.isNotEmpty
                                        ? Image.network(
                                            urlBasic + image,
                                            alignment: Alignment.topCenter,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ) // Exibe a imagem
                                        : Image.network(
                                            'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
                                            color: Style.tertiaryColor,
                                            alignment: Alignment.topCenter,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: Style.height_10(context),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Olá, $login!',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Regular',
                                        fontSize: Style.LoginFontSize(context),
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
                                        fontSize: Style.EmailFontSize(context),
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
          // ListBody(
          //   children: [
          //     Container(
          //       // padding: EdgeInsets.only(left: 15),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: Style.ButtonDrawerSpace(context),
          //           ),
          //           TextButton(
          //             onPressed: () {},
          //             child: Text(
          //               'Promoções',
          //               style: TextStyle(
          //                   color: Style.primaryColor,
          //                   fontSize: Style.ButtonDrawerSize(context),
          //                   fontFamily: 'Poppins-Regular'),
          //             ),
          //           ),
          //           SizedBox(
          //             height: Style.ButtonDrawerSpace(context),
          //           ),
          //           TextButton(
          //             onPressed: () {},
          //             child: Text(
          //               'Produtos negativos',
          //               style: TextStyle(
          //                   color: Style.primaryColor,
          //                   fontSize: Style.ButtonDrawerSize(context),
          //                   fontFamily: 'Poppins-Regular'),
          //             ),
          //           ),
          //           SizedBox(
          //             height: Style.ButtonDrawerSpace(context),
          //           ),
          //           TextButton(
          //             onPressed: () {},
          //             child: Text(
          //               'Funcionários escalados',
          //               style: TextStyle(
          //                   color: Style.primaryColor,
          //                   fontSize: Style.ButtonDrawerSize(context),
          //                   fontFamily: 'Poppins-Regular'),
          //             ),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // )
        ],
      )
      ), 
        onWillPop: () async {
          _closeDrawer();
          return true;
        }
        ) 
        
    );
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
