import 'package:flutter/material.dart';
import 'package:projeto/back/system/save_user_function.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/home/elements/modal_button.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:projeto/front/pages/help_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      // overrideMode: AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        darkTheme: darkTheme,
        home: const CustomDrawer(),
      ),
      debugShowFloatingThemeButton: true,
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final String? pass, perfilUsuario, empresaCodigo, empresaNome;
  const CustomDrawer({
    this.pass,
    this.perfilUsuario,
    this.empresaCodigo,
    this.empresaNome,
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final SaveUserService saveUserService = SaveUserService();

  String token = '',
      login = '',
      image = '',
      url = '',
      urlBasic = '',
      email = '',
      empresaId = '';

  bool isCheckedCPF = true,
      isCheckedProduct = false,
      flagService = false,
      flagGerarPedido = false,
      permCriarPedido = false,
      _isExpandedConfig = false,
      _isExpandedMonit = false,
      flagRememberMe = false;
  int flagprivilegiado = 0;

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
      child: PopScope(
        canPop: false,
        // onPopInvokedWithResult: (didPop, result) => _closeDrawer(),
        child: Drawer(
          // width: MediaQuery.of(context).size.width * 0.8,
          child: ListView(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      // height: Style.DrawerHeaderSize(context),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(Responsive.h(context, 15)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: _closeDrawer,
                                  icon: const Icon(Icons.close),
                                  iconSize: Responsive.h(context, 30),
                                  alignment: Alignment.topRight,
                                  style: const ButtonStyle(
                                    iconColor: WidgetStatePropertyAll(
                                      ColorsApp.tertiaryColor,
                                    ),
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
                                        left: Responsive.h(context, 25),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Responsive.h(context, 70),
                                      height: Responsive.h(context, 70),
                                      // decoration: BoxDecoration(shape: BoxShape.circle),
                                      child: ClipOval(
                                        child: image.isNotEmpty
                                            ? Image.network(
                                                urlBasic + image,
                                                alignment: Alignment.topCenter,
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                              ) // Exibe a imagem
                                            : Image.asset(
                                                "assets/images/icon_person/icon_person.png",
                                                color: ColorsApp.tertiaryColor,
                                                alignment: Alignment.topCenter,
                                                fit: BoxFit.cover,
                                                filterQuality:
                                                    FilterQuality.high,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: Responsive.h(context, 10)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: Responsive.w(context, 200),
                                          child: Text(
                                            'Olá, $login!',
                                            style: TextStyle(
                                              fontFamily: 'Poppins-Regular',
                                              fontSize:
                                                  Responsive.h(context, 20),
                                              color: ColorsApp.tertiaryColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // if (widget.perfilUsuario.isNotEmpty)
                                    Row(
                                      children: [
                                        Text(
                                          'Perfil: ${widget.perfilUsuario}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize: Responsive.h(context, 12),
                                            color: ColorsApp.tertiaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (empresaId.isNotEmpty)
                                      SizedBox(
                                        width: Responsive.w(context, 200),
                                        child: Text(
                                          '${widget.empresaCodigo} - ${widget.empresaNome}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Medium',
                                            fontSize: Responsive.h(context, 12),
                                            color: ColorsApp.tertiaryColor,
                                          ),
                                        ),
                                      ),
                                    Row(
                                      children: [
                                        Text(
                                          email,
                                          style: TextStyle(
                                            fontFamily: 'Poppins-Regular',
                                            fontSize: Responsive.h(context, 12),
                                            color: ColorsApp.tertiaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: Responsive.h(context, 20)),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  //Área externa do button que abre o modal
                                  color: Theme.of(context).colorScheme.primary,
                                  // padding: EdgeInsets.only(left: 10, top: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        //Função para abrir o modal
                                        onTap: () {
                                          ModalExit.modalExit(context);
                                        },
                                        child: ButtonTheme(
                                            //Estilização do Buttom
                                            child: Row(
                                          children: [
                                            Text(
                                              'Sair',
                                              style: TextStyle(
                                                  color:
                                                      ColorsApp.tertiaryColor,
                                                  fontSize: Responsive.h(
                                                      context, 10)),
                                            ),
                                            Icon(
                                              Icons.exit_to_app,
                                              color: ColorsApp.tertiaryColor,
                                              size: Responsive.h(context, 20),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Responsive.h(context, 5)),
                  Container(
                      padding: EdgeInsets.only(
                        left: Responsive.h(context, 10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help,
                            size: Responsive.h(context, 20),
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondary,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              padding: const WidgetStatePropertyAll(
                                EdgeInsets.zero,
                              ),
                              overlayColor: WidgetStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              'Ajuda',
                              style: TextStyle(
                                  fontSize: Responsive.h(context, 15),
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HelpPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpandedConfig = !_isExpandedConfig;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: Responsive.h(context, 10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: Responsive.h(context, 10)),
                                  Row(
                                    children: [
                                      if (_isExpandedConfig)
                                        Transform.rotate(
                                          angle:
                                              3.1416, // 180 graus em radianos (π)
                                          child: Icon(
                                            Icons.arrow_drop_down_outlined,
                                            size: Responsive.h(context, 20),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: Responsive.h(context, 20),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      Text(
                                        'Preferências',
                                        style: TextStyle(
                                          fontSize: Responsive.h(context, 15),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.h(context, 10)),
                                  AnimatedContainer(
                                    padding: EdgeInsets.only(
                                      left: Responsive.h(context, 12),
                                    ),
                                    duration: const Duration(milliseconds: 300),
                                    // height: _isExpanded
                                    //     ? Responsive.h(context, 50)
                                    //     : 0,
                                    child: Visibility(
                                      visible: _isExpandedConfig,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      maintainSize: false,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Switch(
                                                trackOutlineColor:
                                                    WidgetStatePropertyAll(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary),
                                                inactiveThumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                                activeThumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                                value: AdaptiveTheme.of(
                                                  context,
                                                ).mode.isDark,
                                                onChanged: (value) {
                                                  if (value) {
                                                    AdaptiveTheme.of(
                                                      context,
                                                    ).setDark();
                                                  } else {
                                                    AdaptiveTheme.of(
                                                      context,
                                                    ).setLight();
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Tema escuro',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                                  fontSize: Responsive.h(
                                                    context,
                                                    12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Switch(
                                                trackOutlineColor:
                                                    WidgetStatePropertyAll(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary),
                                                inactiveThumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                                activeThumbColor: Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                                value: flagRememberMe,
                                                onChanged: (value) async {
                                                  SharedPreferences
                                                      sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  if (!value) {
                                                    sharedPreferences.remove(
                                                      'saveUser',
                                                    );
                                                    sharedPreferences.remove(
                                                      'savePass',
                                                    );
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        content: Text(
                                                          'Usuário e senha removidos',
                                                          style: TextStyle(
                                                            fontSize: Responsive
                                                                .h(context, 12),
                                                            color: ColorsApp
                                                                .tertiaryColor,
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            ColorsApp
                                                                .warningColor,
                                                      ),
                                                    );
                                                  } else {
                                                    saveUserService.saveUser(
                                                      context,
                                                      login,
                                                      widget.pass ?? '',
                                                    );
                                                    Message.showReturnOverlay(
                                                      context,
                                                      ColorsApp.sucefullColor,
                                                      Icons
                                                          .check_circle_outline,
                                                      'Usuário salvo com sucesso',
                                                    );
                                                  }
                                                  setState(() {
                                                    flagRememberMe = value;
                                                  });
                                                  await sharedPreferences
                                                      .setBool(
                                                    'rememberMe',
                                                    value,
                                                  );
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                'Lembrar meu login',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                                  fontSize: Responsive.h(
                                                    context,
                                                    12,
                                                  ),
                                                ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                  //SizedBox(height: Responsive.h(context, 10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpandedMonit = !_isExpandedMonit;
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: Responsive.h(context, 10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      if (_isExpandedMonit)
                                        Transform.rotate(
                                          angle:
                                              3.1416, // 180 graus em radianos (π)
                                          child: Icon(
                                            Icons.arrow_drop_down_outlined,
                                            size: Responsive.h(context, 20),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                        )
                                      else
                                        Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: Responsive.h(context, 20),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      Text(
                                        'Operação',
                                        style: TextStyle(
                                          fontSize: Responsive.h(context, 15),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Responsive.h(context, 10)),
                                  AnimatedContainer(
                                    padding: EdgeInsets.only(
                                      left: Responsive.h(context, 12),
                                      top: Responsive.h(context, 2),
                                    ),
                                    duration:
                                        const Duration(milliseconds: 1200),
                                    child: Visibility(
                                      visible: _isExpandedMonit,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      maintainSize: false,
                                      child: Column(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Row(
                                              //   children: [
                                              //     Checkbox(
                                              //       value: isCheckedCPF,
                                              //       onChanged: (value) async {
                                              //         setState(() {
                                              //           isCheckedCPF = value!;
                                              //         });
                                              //         print(
                                              //           'Value: $isCheckedCPF',
                                              //         );
                                              //         SharedPreferences
                                              //             sharedPreferences =
                                              //             await SharedPreferences
                                              //                 .getInstance();
                                              //         await sharedPreferences
                                              //             .setBool(
                                              //           'checkCPF',
                                              //           isCheckedCPF,
                                              //         );
                                              //       },
                                              //     ),
                                              //     Text(
                                              //       'Ativar CPF obrigatório?',
                                              //       style: TextStyle(
                                              //         color: Theme.of(
                                              //           context,
                                              //         ).colorScheme.primary,
                                              //         fontSize: Style.height_12(
                                              //           context,
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              // Row(
                                              //   children: [
                                              //     Checkbox(
                                              //       value: isCheckedProduct,
                                              //       onChanged: (value) async {
                                              //         setState(() {
                                              //           isCheckedProduct =
                                              //               value!;
                                              //         });
                                              //         SharedPreferences
                                              //             sharedPreferences =
                                              //             await SharedPreferences
                                              //                 .getInstance();
                                              //         await sharedPreferences
                                              //             .setBool(
                                              //           'checkProduct',
                                              //           isCheckedProduct,
                                              //         );
                                              //       },
                                              //     ),
                                              //     SizedBox(
                                              //       width: Responsive.w(
                                              //           context, 225),
                                              //       child: Text(
                                              //         'Ativar adicionar produtos em massa ao pedido?',
                                              //         style: TextStyle(
                                              //           color: Theme.of(
                                              //             context,
                                              //           ).colorScheme.primary,
                                              //           fontSize: Responsive.h(
                                              //               context, 12),
                                              //         ),
                                              //         softWrap: true,
                                              //         overflow:
                                              //             TextOverflow.clip,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                    value: flagService,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        flagService = value!;
                                                      });
                                                      SharedPreferences
                                                          sharedPreferences =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      await sharedPreferences
                                                          .setBool(
                                                        'flagService',
                                                        flagService,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: Responsive.w(
                                                        context, 225),
                                                    child: Text(
                                                      'Ativar modo venda de serviços?',
                                                      style: TextStyle(
                                                        color: Theme.of(
                                                          context,
                                                        )
                                                            .colorScheme
                                                            .onSecondary,
                                                        fontSize: Responsive.h(
                                                            context, 12),
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .onSecondary,
                                                    value: flagGerarPedido,
                                                    onChanged: permCriarPedido ==
                                                                false &&
                                                            flagprivilegiado !=
                                                                1
                                                        ? null
                                                        : (value) async {
                                                            setState(() {
                                                              flagGerarPedido =
                                                                  value!;
                                                            });
                                                            SharedPreferences
                                                                sharedPreferences =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            await sharedPreferences
                                                                .setBool(
                                                              'flagGerarPedido',
                                                              flagGerarPedido,
                                                            );
                                                          },
                                                  ),
                                                  SizedBox(
                                                    width: Responsive.w(
                                                        context, 225),
                                                    child: Text(
                                                      'Gerar pedido de venda ao finalizar pré-venda',
                                                      style: TextStyle(
                                                        color: permCriarPedido ==
                                                                    false &&
                                                                flagprivilegiado !=
                                                                    1
                                                            ? ColorsApp
                                                                .quarantineColor
                                                            : Theme.of(context)
                                                                .colorScheme
                                                                .onSecondary,
                                                        fontSize: Responsive.h(
                                                            context, 12),
                                                      ),
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedFlagPrivilegiado(),
      _loadSavedFlagRememberMe(),
      _loadSavedFlagService(),
      _loadSavedCheckCPF(),
      _loadSavedCheckProduct(),
    ]);
    await Future.wait([
      _loadSavedUrl(),
      _loadSavedToken(),
      _loadSavedLogin(),
      _loadSavedImage(),
      _loadSavedUrlBasic(),
      _loadSavedEmail(),
      _loadSavedPermNovoPedido(),
      _loadSavedFlagGerarPedido(),
      _loadSavedEmpresa(),
    ]);
  }

  Future<void> _loadSavedFlagPrivilegiado() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int savedFlagPrivilegiado =
        sharedPreferences.getInt('flagprivilegiado') ?? 0;
    setState(() {
      flagprivilegiado = savedFlagPrivilegiado;
    });
  }

  Future<void> _loadSavedFlagRememberMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? savedFlagRememberMe = sharedPreferences.getBool('rememberMe');
    if (savedFlagRememberMe != null) {
      setState(() {
        flagRememberMe = savedFlagRememberMe;
      });
    }
  }

  Future<void> _loadSavedFlagService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagService = sharedPreferences.getBool('flagService') ??
        false; // Carrega o valor salvo (padrão: false)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedPermNovoPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedNovoPedido = sharedPreferences.getBool('criarPedido') ?? false;
    setState(() {
      permCriarPedido = savedNovoPedido;
    });
  }

  Future<void> _loadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    if (permCriarPedido == false && flagprivilegiado != 1) {
      await sharedPreferences.setBool('flagGerarPedido', false);
      setState(() {
        flagGerarPedido = false;
      });
    } else {
      setState(() {
        flagGerarPedido = savedFlagGerarPedido;
      });
    }
  }

  Future<void> _loadSavedCheckCPF() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckCPF = sharedPreferences.getBool('checkCPF') ??
        true; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedCPF = savedCheckCPF; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedCheckProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ??
        false; // Carrega o valor salvo (padrão: false)
    setState(() {
      isCheckedProduct =
          savedCheckProduct; // Atualiza o estado com o valor salvo
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

  Future<void> _loadSavedEmpresa() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String savedEmpresa = sharedPreferences.getString('empresa_id') ?? '';
    setState(() {
      empresaId = savedEmpresa;
    });
  }
}
