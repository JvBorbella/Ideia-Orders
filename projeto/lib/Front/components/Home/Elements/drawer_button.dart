import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Home/Elements/ModalButtom.dart';
import 'package:projeto/Front/components/Style.dart';

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
      child: Drawer(
          // width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  // height: Style.DrawerHeaderSize(context),
                  decoration: BoxDecoration(color: Style.primaryColor),
                  child: Container(
                    padding: EdgeInsets.all(Style.PaddingContainerDrawerHeader(context)),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: _closeDrawer,
                              icon: Icon(Icons.close),
                              iconSize: Style.IconCloseDrawerSize(context),
                              alignment: Alignment.topRight,
                              style: ButtonStyle(
                                iconColor: MaterialStatePropertyAll(
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
                                Container(
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
                                      'Olá, ' + login + '!',
                                      style: TextStyle(
                                        fontFamily: 'Poppins-Medium',
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
                                        fontFamily: 'Poppins-Medium',
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
                              child: ModalButton(),
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
          //                   fontFamily: 'Poppins-Medium'),
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
          //                   fontFamily: 'Poppins-Medium'),
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
          //                   fontFamily: 'Poppins-Medium'),
          //             ),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // )
        ],
      )),
    );
  }

  Future<void> _loadSavedUrl() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrl = await sharedPreferences.getString('url') ?? '';
    setState(() {
      url = savedUrl;
    });
  }

  Future<void> _loadSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedToken = await sharedPreferences.getString('token') ?? '';
    setState(() {
      token = savedToken;
    });
  }

  Future<void> _loadSavedLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedLogin = await sharedPreferences.getString('login') ?? '';
    setState(() {
      login = savedLogin;
    });
  }

  Future<void> _loadSavedImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedImage = await sharedPreferences.getString('image') ?? '';
    setState(() {
      image = savedImage;
    });
  }

  Future<void> _loadSavedUrlBasic() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedUrlBasic = await sharedPreferences.getString('urlBasic') ?? '';
    setState(() {
      urlBasic = savedUrlBasic;
    });
  }

  Future<void> _loadSavedEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmail = await sharedPreferences.getString('email') ?? '';
    setState(() {
      email = savedEmail;
    });
  }
}
