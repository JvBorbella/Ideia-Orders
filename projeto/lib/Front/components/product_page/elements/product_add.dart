import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/add_product.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductAdd extends StatefulWidget {
  final prevendaid;
  final produtoid;
  final empresaid;
  final nomeproduto;
  final codigoproduto;
  final codigoean;
  final unidade;
  final precopromocional;
  final precotabela;
  final flagunidadefracionada;
  final VoidCallback? onProductAdded;
  final expedicaoId;

  const ProductAdd({
    Key? key,
    this.prevendaid,
    this.produtoid,
    this.empresaid,
    this.nomeproduto,
    this.codigoproduto,
    this.codigoean,
    this.unidade,
    this.precopromocional,
    this.precotabela,
    this.flagunidadefracionada,
    this.onProductAdded,
    this.expedicaoId,
  });

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

List expedition = [];
String urlBasic = '';
String token = '';

String text = '';
bool isCheckedProduct = false;
bool flagService = false, flagGerarPedido = false;

String expedicaoId = '', expedicaoNome = '', expedicaoCodigo = '';

class _ProductAddState extends State<ProductAdd> {
  late TextEditingController _complementocontroller;
  late TextEditingController _quantidadecontroller;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  bool isLoadingButton = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedFlagService();
    _loadSavedCheckProduct();
    _loadSavedFlagGerarPedido();
    _complementocontroller = TextEditingController();
    // _quantidadecontroller = TextEditingController();
    if (widget.flagunidadefracionada == 0 ||
        widget.flagunidadefracionada == null) {
      _quantidadecontroller = TextEditingController(text: '1');
    } else {
      _quantidadecontroller = TextEditingController(text: '1,0');
    }
    fetchDataExpedtion();
  }

  @override
  void dispose() {
    _complementocontroller.dispose();
    _quantidadecontroller.dispose();
    super.dispose();
  }

  void _openModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Center(
              child: SingleChildScrollView(
                  child: AlertDialog(
                      backgroundColor: Style.defaultColor,
                      alignment: Alignment.center,
                      content: Container(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.nomeproduto.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Style.height_15(context),
                              color: Style.primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Style.height_5(context),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Código',
                                  style: TextStyle(
                                      fontSize: Style.height_8(context),
                                      color: Style.quarantineColor),
                                ),
                                Text(
                                  widget.codigoproduto,
                                  style: TextStyle(
                                      fontSize: Style.height_15(context),
                                      color: Style.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Pr. Tabela',
                                  style: TextStyle(
                                      fontSize: Style.height_8(context),
                                      color: Style.quarantineColor),
                                ),
                                Text(
                                  currencyFormat
                                      .format(widget.precotabela)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: Style.height_15(context),
                                      color: Style.primaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Unidade',
                                  style: TextStyle(
                                      fontSize: Style.height_8(context),
                                      color: Style.quarantineColor),
                                ),
                                Text(
                                  widget.unidade ?? '',
                                  style: TextStyle(
                                      fontSize: Style.height_15(context),
                                      color: Style.primaryColor,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Qtde a adicionar',
                                  style: TextStyle(
                                      fontSize: Style.height_15(context),
                                      color: Style.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Style.width_130(context),
                                  child: Input(
                                    controller: _quantidadecontroller,
                                    text: 'Informe a quantidade',
                                    type: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    onTap: () => _quantidadecontroller.clear(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        if (flagGerarPedido)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Expedição',
                                    style: TextStyle(
                                        fontSize: Style.height_15(context),
                                        color: Style.primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: Style.height_30(context),
                                    child: PopupMenuButton<String>(
                                      itemBuilder: (BuildContext context) =>
                                          buildMenuItemsexpedition(expedition),
                                      onSelected: (value) async {
                                        if (value != '') {
                                          setModalState(() {
                                            expedicaoId = value;
                                            // Busca o nome da empresa correspondente ao ID selecionado
                                            final selectedexpedition =
                                                expedition.firstWhere(
                                              (expedition) =>
                                                  expedition['expedicao_id'] ==
                                                  value,
                                            );
                                            expedicaoNome =
                                                selectedexpedition['nome'] ??
                                                    ''; // Atualiza o nome
                                            expedicaoCodigo =
                                                selectedexpedition['codigo'] ??
                                                    ''; // Atualiza o nome
                                          });
                                          setState(() {
                                            expedicaoId = value;
                                          });
                                          print(expedicaoId);
                                        } else {
                                          setState(() {
                                            expedicaoId = '';
                                            expedicaoNome = '';
                                            expedicaoCodigo = '';
                                          });
                                        }
                                      },
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_drop_down_rounded,
                                              color: Style.secondaryColor,
                                              size: Style.height_20(context),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Style
                                                        .secondaryColor, // Color of the bottom border
                                                    width: Style.height_2(
                                                        context), // Thickness of the bottom border
                                                    style: BorderStyle
                                                        .solid, // Style of the border (solid, dashed, etc.)
                                                  ),
                                                ),
                                              ),
                                              width: Style.width_150(context),
                                              child: Text(
                                                expedicaoNome.isEmpty
                                                    ? 'Selecione a expedição'
                                                    : '${expedicaoCodigo} - ${expedicaoNome}',
                                                style: TextStyle(
                                                  color: Style.secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      Style.height_12(context),
                                                ),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow
                                                    .ellipsis, // corta o texto no limite da largura
                                                softWrap:
                                                    true, // permite a quebra de linha conforme necessário
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        SizedBox(
                          height: Style.height_10(context),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Complemento',
                                  style: TextStyle(
                                      fontSize: Style.height_15(context),
                                      color: Style.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: Style.width_180(context),
                                  child: TextFormField(
                                    controller: _complementocontroller,
                                    textAlign: TextAlign.start,
                                    textAlignVertical: TextAlignVertical
                                        .top, // Alinha o cursor ao topo
                                    maxLines:
                                        null, // Permite quebra de linha automática
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          top: 20.0,
                                          left: 10.0,
                                          right:
                                              10.0), // Ajuste conforme necessário
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Style.secondaryColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Style.secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
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
                                RegisterButton(
                                  text: 'Adicionar produto',
                                  color: Style.primaryColor,
                                  width: Style.width_100(context),
                                  isLoadingButton: isLoadingButton,
                                  onPressed: () async {
                                    setState(() {
                                      isLoadingButton = true;
                                    });
                                    // Adiciona o produto ao pedido
                                    if (flagService == true) {
                                      bool success = await DataServiceAddProduct
                                          .sendDataOrder(
                                              context,
                                              urlBasic,
                                              token,
                                              widget.prevendaid,
                                              widget.empresaid,
                                              widget.produtoid,
                                              _complementocontroller.text,
                                              _quantidadecontroller.text,
                                              widget.flagunidadefracionada ?? 0,
                                              1,
                                              expedicaoId);

                                      // Só chama o callback se o produto foi adicionado com sucesso
                                      if (success &&
                                          widget.onProductAdded != null) {
                                        widget.onProductAdded!();
                                      }

                                      // Verifica se o widget ainda está montado antes de fechar o modal
                                      if (mounted) {
                                        _closeModal();
                                        // Limpa os campos após adicionar o produto
                                        _quantidadecontroller.clear();
                                        _complementocontroller.clear();
                                      }
                                    } else {
                                      bool success = await DataServiceAddProduct
                                          .sendDataOrder(
                                              context,
                                              urlBasic,
                                              token,
                                              widget.prevendaid,
                                              widget.empresaid,
                                              widget.produtoid,
                                              _complementocontroller.text,
                                              _quantidadecontroller.text,
                                              widget.flagunidadefracionada ?? 0,
                                              0,
                                              expedicaoId);

                                      // Só chama o callback se o produto foi adicionado com sucesso
                                      if (success &&
                                          widget.onProductAdded != null) {
                                        widget.onProductAdded!();
                                      }

                                      // Verifica se o widget ainda está montado antes de fechar o modal
                                      if (mounted) {
                                        _closeModal();
                                        // Limpa os campos após adicionar o produto
                                        _quantidadecontroller.clear();
                                        _complementocontroller.clear();
                                        expedicaoId = '';
                                        expedicaoNome = '';
                                        expedicaoCodigo = '';
                                      }
                                      setState(() {
                                        isLoadingButton = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                RegisterButton(
                                  text: 'Fechar',
                                  color: Style.errorColor,
                                  width: Style.width_100(context),
                                  onPressed: () {
                                    _closeModal();
                                  },
                                )
                              ],
                            )
                          ],
                        )
                      ])))));
        });
      },
    );
  }

  void _closeModal() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(Style.height_8(context)),
            decoration: BoxDecoration(
              color: Style.defaultColor,
              border: BorderDirectional(
                bottom: BorderSide(
                    width: Style.height_05(context),
                    color: Style.quarantineColor),
                top: BorderSide(
                    width: Style.height_05(context),
                    color: Style.quarantineColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                  "assets/images/image_product/Barcode.png")
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: Style.width_130(context),
                                    child: Text(
                                      widget.nomeproduto,
                                      style: TextStyle(
                                          color: Style.primaryColor,
                                          fontSize: Style.height_10(context),
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.codigoproduto,
                                    style: TextStyle(
                                      fontSize: Style.height_10(context),
                                      color: Style.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          if (isCheckedProduct == true)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Vl. Unit',
                                      style: TextStyle(
                                          fontSize: Style.height_8(context),
                                          color: Style.secondaryColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      currencyFormat
                                          .format(widget.precotabela)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: Style.height_12(context),
                                          color: Style.secondaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                          SizedBox(
                            width: Style.height_10(context),
                          ),
                          Column(
                            children: [
                              Container(
                                height: Style.height_30(context),
                                decoration: BoxDecoration(
                                    color: Style.primaryColor,
                                    borderRadius: BorderRadius.circular(
                                        Style.height_5(context))),
                                child: TextButton(
                                  onPressed: () async {
                                    if (isCheckedProduct == false) {
                                      _openModal(context);
                                    } else if (flagService == true) {
                                      setState(() {
                                        isLoadingButton = true;
                                      });
                                      bool success = await DataServiceAddProduct
                                          .sendDataOrder(
                                              context,
                                              urlBasic,
                                              token,
                                              widget.prevendaid,
                                              widget.empresaid,
                                              widget.produtoid,
                                              _complementocontroller.text,
                                              _quantidadecontroller.text,
                                              widget.flagunidadefracionada ?? 0,
                                              1,
                                              widget.expedicaoId ??
                                                  expedicaoId);

                                      // Só chama o callback se o produto foi adicionado com sucesso
                                      if (success &&
                                          widget.onProductAdded != null) {
                                        widget.onProductAdded!();
                                      }

                                      // Verifica se o widget ainda está montado antes de fechar o modal
                                      if (mounted) {
                                        // _closeModal(success);
                                        // Limpa os campos após adicionar o produto
                                        _quantidadecontroller.clear();
                                        _complementocontroller.clear();
                                      }
                                    } else {
                                      bool success = await DataServiceAddProduct
                                          .sendDataOrder(
                                              context,
                                              urlBasic,
                                              token,
                                              widget.prevendaid,
                                              widget.empresaid,
                                              widget.produtoid,
                                              _complementocontroller.text,
                                              _quantidadecontroller.text,
                                              widget.flagunidadefracionada ?? 0,
                                              0,
                                              widget.expedicaoId ??
                                                  expedicaoId);

                                      // Só chama o callback se o produto foi adicionado com sucesso
                                      if (success &&
                                          widget.onProductAdded != null) {
                                        widget.onProductAdded!();
                                      }

                                      // Verifica se o widget ainda está montado antes de fechar o modal
                                      if (mounted) {
                                        // _closeModal(success);
                                        // Limpa os campos após adicionar o produto
                                        _quantidadecontroller.clear();
                                        _complementocontroller.clear();
                                      }

                                      setState(() {
                                        isLoadingButton = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Adicionar',
                                    style: TextStyle(
                                        color: Style.tertiaryColor,
                                        fontSize: Style.height_12(context)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Future<void> _loadSavedCheckProduct() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ??
        false; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedProduct =
          savedCheckProduct; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedFlagService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagService = sharedPreferences.getBool('flagService') ??
        false; // Carrega o valor salvo (padrão: true)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedFlagGerarPedido() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagGerarPedido =
        sharedPreferences.getBool('flagGerarPedido') ?? false;
    setState(() {
      flagGerarPedido = savedFlagGerarPedido;
    });
  }

  List<PopupMenuItem<String>> buildMenuItemsexpedition(List expedition) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: Style.height_5(context)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Style.height_5(context)),
                    color: Style.errorColor),
                child: IconButton(
                  onPressed: () {
                    _closeModal();
                  },
                  icon:
                      Image.asset('assets/images/icon_remove/icon_remove.png'),
                  style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(Style.tertiaryColor)),
                ),
              ),
            ],
          )),
    ];
    const PopupMenuDivider();

    List<PopupMenuItem<String>> dynamicItems = expedition.map((expeditions) {
      return PopupMenuItem<String>(
        value: expeditions['expedicao_id'].toString(),
        child: Text(
            ('${expeditions['codigo']} - ${expeditions['nome']}').toString()),
        key: Key(expeditions['nome'].toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return staticItems + dynamicItems;
  }

  void fetchDataExpedtion() async {
    try {
      var urlGet = Uri.parse(
          '$urlBasic/ideia/core/getdata/expedicao%20e%20WHERE%20COALESCE(e.flagexcluido,%200)%20<>%201/');
      var response = await http.get(urlGet, headers: {'Accept': 'text/html'});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var dynamicKey = jsonData['data'].keys.first;
        print('Chave dinâmica encontrada: $dynamicKey');

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        var data = dataList;
        var expedicaoId = data[0]['expedicao_id'];
        var expedicaoNome = data[0]['nome'];
        var expedicaoCodigo = data[0]['codigo'];

        print(dataList);

        setState(() {
          expedition = dataList;
        });
        print(expedition);
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }
}
