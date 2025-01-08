import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:projeto/back/add_product.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:projeto/front/components/new_order/elements/register_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAdd extends StatefulWidget {
  final prevendaid;
  final produtoid;
  final nomeproduto;
  final codigoproduto;
  final codigoean;
  final unidade;
  final precopromocional;
  final precotabela;
  final flagunidadefracionada;
  final VoidCallback? onProductAdded;

  const ProductAdd({
    Key? key,
    this.prevendaid,
    this.produtoid,
    this.nomeproduto,
    this.codigoproduto,
    this.codigoean,
    this.unidade,
    this.precopromocional,
    this.precotabela,
    this.flagunidadefracionada,
    this.onProductAdded,
  });

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

String urlBasic = '';
String token = '';

String text = '';
bool isCheckedProduct = false;
bool flagService = false;

class _ProductAddState extends State<ProductAdd> {
  late TextEditingController _complementocontroller;
  late TextEditingController _quantidadecontroller;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');

  @override
  void initState() {
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedFlagService();
    _loadSavedCheckProduct();
    _complementocontroller = TextEditingController();
    // _quantidadecontroller = TextEditingController();
    if (widget.flagunidadefracionada == 0 ||
        widget.flagunidadefracionada == null) {
      _quantidadecontroller = TextEditingController(text: '1');
    } else {
      _quantidadecontroller = TextEditingController(text: '1,0');
    }
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
        return Center(
            child: SingleChildScrollView(
                child: AlertDialog(
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
                                onPressed: () async {
                                  // Adiciona o produto ao pedido
                                  if (flagService == true) {
                                    bool success = await DataServiceAddProduct
                                        .sendDataOrder(
                                            context,
                                            urlBasic,
                                            token,
                                            widget.prevendaid,
                                            widget.produtoid,
                                            _complementocontroller.text,
                                            _quantidadecontroller.text,
                                            widget.flagunidadefracionada ?? 0,
                                            1);

                                    // Só chama o callback se o produto foi adicionado com sucesso
                                    if (success &&
                                        widget.onProductAdded != null) {
                                      widget.onProductAdded!();
                                    }

                                    // Verifica se o widget ainda está montado antes de fechar o modal
                                    if (mounted) {
                                      _closeModal(success);
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
                                            widget.produtoid,
                                            _complementocontroller.text,
                                            _quantidadecontroller.text,
                                            widget.flagunidadefracionada ?? 0,
                                            0);

                                    // Só chama o callback se o produto foi adicionado com sucesso
                                    if (success &&
                                        widget.onProductAdded != null) {
                                      widget.onProductAdded!();
                                    }

                                    // Verifica se o widget ainda está montado antes de fechar o modal
                                    if (mounted) {
                                      _closeModal(success);
                                      // Limpa os campos após adicionar o produto
                                      _quantidadecontroller.clear();
                                      _complementocontroller.clear();
                                    }
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
      },
    );
  }

  void _closeModal([bool updateList = false]) {
    Navigator.of(context).pop(updateList);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(Style.height_8(context)),
        decoration: BoxDecoration(
          color: Style.defaultColor,
          border: BorderDirectional(
            bottom: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
            top: BorderSide(
                width: Style.height_05(context), color: Style.quarantineColor),
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
                          Image.asset("assets/images/image_product/Barcode.png")
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
                                } else
                                if (flagService == true) {
                                  bool success =
                                      await DataServiceAddProduct.sendDataOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          widget.prevendaid,
                                          widget.produtoid,
                                          _complementocontroller.text,
                                          _quantidadecontroller.text,
                                          widget.flagunidadefracionada ?? 0,
                                          1);

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
                                  bool success =
                                      await DataServiceAddProduct.sendDataOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          widget.prevendaid,
                                          widget.produtoid,
                                          _complementocontroller.text,
                                          _quantidadecontroller.text,
                                          widget.flagunidadefracionada ?? 0,
                                          0);

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
    bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ?? false; // Carrega o valor salvo (padrão: true)
    setState(() {
      isCheckedProduct = savedCheckProduct; // Atualiza o estado com o valor salvo
    });
  }

  Future<void> _loadSavedFlagService() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedFlagService = sharedPreferences.getBool('flagService') ?? false; // Carrega o valor salvo (padrão: true)
    setState(() {
      flagService = savedFlagService; // Atualiza o estado com o valor salvo
    });
  }
}
