import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:projeto/back/products/add_product.dart';
import 'package:projeto/back/products/get_image.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/login_config/elements/input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ProductAdd extends StatefulWidget {
  final String? url,
      localId,
      prevendaid,
      produtoid,
      empresaid,
      nomeproduto,
      codigoproduto,
      codigoean,
      unidade,
      expedicaoId,
      imagem,
      produtounidademedidaId;
  final double? precopromocional,
      precotabela,
      quantidadeEstq,
      quantidadeUnMedida;
  final int? flagunidadefracionada, flagObrigarExpedicao;
  final ValueChanged<Map<String, dynamic>>? onProductAdded;
  final ValueChanged<String>? onExpedicaoChanged;
  final List? expeditions;

  const ProductAdd(
      {super.key,
      this.url,
      this.localId,
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
      this.quantidadeEstq,
      this.quantidadeUnMedida,
      this.imagem,
      this.produtounidademedidaId,
      this.expeditions,
      this.flagObrigarExpedicao,
      this.onExpedicaoChanged});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

List expedition = [];
String urlBasic = '',
    token = '',
    text = '',
    expedicaoId = '',
    expedicaoNome = '',
    expedicaoCodigo = '';
bool flagService = false,
    flagGerarPedido = false,
    isCheckedProduct = true,
    permPedidoEstoqueNegativo = false,
    isLoadingButton = false,
    flagAction = false;

int flagprivilegiado = 0;

late dynamic _quantity;

class _ProductAddState extends State<ProductAdd> {
  late TextEditingController _complementocontroller;
  late TextEditingController _quantidadecontroller;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  Future<void> _loadSavedFlagPrivilegiado() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int savedFlagPrivilegiado =
        sharedPreferences.getInt('flagprivilegiado') ?? 0;
    setState(() {
      flagprivilegiado = savedFlagPrivilegiado;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedFlagPrivilegiado();
    _loadSavedPermPedidoEstoqueNegativo();
    _loadSavedUrlBasic();
    _loadSavedToken();
    _loadSavedFlagService();
    //_loadSavedCheckProduct();
    _loadSavedFlagGerarPedido();
    _complementocontroller = TextEditingController();

    expedition = widget.expeditions ?? [];

    _quantity = 1.0;

    if (widget.flagunidadefracionada == 0 ||
        widget.flagunidadefracionada == null) {
      // Unidade não fraciona: remove a parte decimal (ex: 2.7 -> 2)
      _quantity = _quantity.toInt();
    } else {
      // Unidade fraciona: mantém como double
      // (não precisa converter, mas deixamos explícito por clareza)
      _quantity = _quantity.toDouble();
    }

    // Atualiza o controller para refletir a quantidade inicial
    _quantidadecontroller = TextEditingController(text: _quantity.toString());
    _quantidadecontroller.addListener(_onQuantityChanged);
  }

  void _onQuantityChanged() {
    if (!mounted) return;
    final text = _quantidadecontroller.text;
    final parsed = double.tryParse(text);
    if (parsed != null && parsed >= 1) {
      if (_quantity != parsed) {
        setState(() {
          _quantity = parsed;
        });
      }
    } else if (text.isEmpty) {
      setState(() {
        _quantity = 1;
        // _quantidadecontroller.text = '1';
      });
    }
  }

  @override
  void dispose() {
    _quantidadecontroller.removeListener(_onQuantityChanged);
    _complementocontroller.dispose();
    _quantidadecontroller.dispose();
    super.dispose();
  }

  // void _openModal(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(builder: (context, setModalState) {
  //         return Center(
  //           child: SingleChildScrollView(
  //             child: AlertDialog(
  //               backgroundColor: Theme.of(context).colorScheme.surface,
  //               alignment: Alignment.center,
  //               content: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       widget.nomeproduto.toString(),
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontSize: Responsive.h(context, 12),
  //                         color: Theme.of(context).colorScheme.primary,
  //                         fontWeight: FontWeight.w900,
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: Responsive.h(context, 5),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Text(
  //                             'Código',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 8),
  //                                 color: ColorsApp.quarantineColor),
  //                           ),
  //                           Text(
  //                             widget.codigoproduto ?? '',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 12),
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       Column(
  //                         children: [
  //                           Text(
  //                             'Pr. Tabela',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 8),
  //                                 color: ColorsApp.quarantineColor),
  //                           ),
  //                           Text(
  //                             currencyFormat
  //                                 .format(widget.precotabela)
  //                                 .toString(),
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 12),
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 fontWeight: FontWeight.bold),
  //                           )
  //                         ],
  //                       ),
  //                       Column(
  //                         children: [
  //                           Text(
  //                             'Unidade',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 8),
  //                                 color: ColorsApp.quarantineColor),
  //                           ),
  //                           Text(
  //                             widget.unidade ?? '',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 12),
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 fontWeight: FontWeight.bold),
  //                           )
  //                         ],
  //                       ),
  //                       Column(
  //                         children: [
  //                           Text(
  //                             'Estoque',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 8),
  //                                 color: ColorsApp.quarantineColor),
  //                           ),
  //                           Text(
  //                             widget.quantidadeEstq
  //                                 .toString()
  //                                 .replaceAll(RegExp(r'\.0*$'), ''),
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 12),
  //                                 color: (widget.quantidadeEstq != null &&
  //                                         num.tryParse(widget.quantidadeEstq
  //                                                 .toString()) !=
  //                                             null &&
  //                                         num.parse(widget.quantidadeEstq
  //                                                 .toString()) <
  //                                             0)
  //                                     ? ColorsApp.errorColor
  //                                     : Theme.of(context).colorScheme.primary,
  //                                 fontWeight: FontWeight.bold),
  //                           )
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: Responsive.h(context, 10),
  //                   ),
  //                   Column(
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             'Qtde a adicionar',
  //                             style: TextStyle(
  //                                 fontSize: Responsive.h(context, 12),
  //                                 color: Theme.of(context).colorScheme.primary,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           SizedBox(
  //                             width: Responsive.w(context, 130),
  //                             child: Input(
  //                               controller: _quantidadecontroller,
  //                               text: 'Informe a quantidade',
  //                               type: TextInputType.number,
  //                               textAlign: TextAlign.center,
  //                               onTap: () => _quantidadecontroller.clear(),
  //                             ),
  //                           ),
  //                         ],
  //                       )
  //                     ],
  //                   ),
  //                   SizedBox(
  //                     height: Responsive.h(context, 10),
  //                   ),
  //                   if (flagGerarPedido)
  //                     Column(
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(
  //                               'Expedição',
  //                               style: TextStyle(
  //                                   fontSize: Responsive.h(context, 12),
  //                                   color:
  //                                       Theme.of(context).colorScheme.primary,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             SizedBox(
  //                                 height: Responsive.h(context, 30),
  //                                 child: PopupMenuButton<String>(
  //                                   itemBuilder: (BuildContext context) =>
  //                                       buildMenuItemsexpedition(expedition),
  //                                   onSelected: (value) async {
  //                                     if (value != '') {
  //                                       setModalState(() {
  //                                         expedicaoId = value;
  //                                         // Busca o nome da empresa correspondente ao ID selecionado
  //                                         final selectedexpedition =
  //                                             expedition.firstWhere(
  //                                           (expedition) =>
  //                                               expedition['expedicao_id'] ==
  //                                               value,
  //                                         );
  //                                         expedicaoNome =
  //                                             selectedexpedition['nome'] ??
  //                                                 ''; // Atualiza o nome
  //                                         expedicaoCodigo =
  //                                             selectedexpedition['codigo'] ??
  //                                                 ''; // Atualiza o nome
  //                                       });
  //                                       setState(() {
  //                                         expedicaoId = value;
  //                                       });
  //                                     } else {
  //                                       setState(() {
  //                                         expedicaoId = '';
  //                                         expedicaoNome = '';
  //                                         expedicaoCodigo = '';
  //                                       });
  //                                     }
  //                                   },
  //                                   child: Container(
  //                                     decoration: BoxDecoration(
  //                                       border: Border.all(
  //                                         color: ColorsApp
  //                                             .secondaryColor, // Color of the bottom border
  //                                         width: Responsive.h(context,
  //                                             2), // Thickness of the bottom border
  //                                         style: BorderStyle
  //                                             .solid, // Style of the border (solid, dashed, etc.)
  //                                       ),
  //                                       borderRadius: BorderRadius.circular(
  //                                           Responsive.h(context, 20)),
  //                                     ),
  //                                     child: Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.center,
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.center,
  //                                         children: [
  //                                           Icon(
  //                                             Icons.arrow_drop_down_rounded,
  //                                             color: Theme.of(context)
  //                                                 .colorScheme
  //                                                 .onSecondary,
  //                                             size: Responsive.h(context, 20),
  //                                           ),
  //                                           SizedBox(
  //                                             width: Responsive.w(context, 150),
  //                                             child: Text(
  //                                               expedicaoNome.isEmpty
  //                                                   ? 'Selecione a expedição'
  //                                                   : '$expedicaoCodigo - $expedicaoNome',
  //                                               style: TextStyle(
  //                                                 color: Theme.of(context)
  //                                                     .colorScheme
  //                                                     .onSecondary,
  //                                                 fontWeight: FontWeight.bold,
  //                                                 fontSize:
  //                                                     Responsive.h(context, 12),
  //                                               ),
  //                                               textAlign: TextAlign.center,
  //                                               overflow: TextOverflow
  //                                                   .ellipsis, // corta o texto no limite da largura
  //                                               softWrap:
  //                                                   true, // permite a quebra de linha conforme necessário
  //                                             ),
  //                                           )
  //                                         ]),
  //                                   ),
  //                                 )),
  //                           ],
  //                         )
  //                       ],
  //                     ),
  //                   SizedBox(
  //                     height: Responsive.h(context, 10),
  //                   ),
  //                   Column(
  //                     children: [
  //                       RegisterButton(
  //                         text: 'Adicionar produto',
  //                         color: Theme.of(context).colorScheme.primary,
  //                         width: double.infinity,
  //                         isLoadingButton: isLoadingButton,
  //                         onPressed: () async {
  //                           if (widget.flagObrigarExpedicao == 1 &&
  //                               (widget.expedicaoId ?? '').isEmpty) {
  //                             Message.showReturnOverlay(
  //                                 context,
  //                                 ColorsApp.errorColor,
  //                                 Icons.error,
  //                                 'Selecione uma expedição.');
  //                             setState(() {
  //                               isLoadingButton = false;
  //                             });
  //                             return;
  //                           }

  //                           setState(() {
  //                             isLoadingButton = true;
  //                           });
  //                           final uuid = const Uuid().v4();
  //                           final bodyMap = {
  //                             'local_id': widget.localId,
  //                             'flag_sync': 1,
  //                             'produto_id': widget.produtoid,
  //                             'prevenda_id': widget.prevendaid,
  //                             'imagem': widget.imagem,
  //                             'prevendaproduto_id': uuid,
  //                             'codigoproduto': widget.codigoproduto,
  //                             'nomeproduto': widget.nomeproduto,
  //                             'nome': expedicaoNome,
  //                             'expedicao_id': expedicaoId,
  //                             'valorunitario': widget.precotabela,
  //                             'quantidade': widget.quantidadeEstq != null &&
  //                                     num.tryParse(widget.quantidadeEstq
  //                                             .toString()) !=
  //                                         null
  //                                 ? widget.quantidadeEstq
  //                                 : 0,
  //                             'valortotal': widget.precotabela != null &&
  //                                     num.tryParse(
  //                                             widget.precotabela.toString()) !=
  //                                         null &&
  //                                     widget.quantidadeEstq != null &&
  //                                     num.tryParse(widget.quantidadeEstq
  //                                             .toString()) !=
  //                                         null
  //                                 ? (widget.precotabela ?? 0.0) *
  //                                     (widget.quantidadeEstq ?? 0.0)
  //                                 : 0,
  //                             'ean': '',
  //                           };
  //                           if (permPedidoEstoqueNegativo == false &&
  //                               flagprivilegiado == 0 &&
  //                               widget.quantidadeEstq != null &&
  //                               num.tryParse(
  //                                       widget.quantidadeEstq.toString()) !=
  //                                   null &&
  //                               num.parse(widget.quantidadeEstq.toString()) <=
  //                                   0) {
  //                             Message.showReturnOverlay(
  //                               context,
  //                               ColorsApp.errorColor,
  //                               Icons.error,
  //                               'Não é possível finalizar o pedido. Existem produtos com estoque negativo.',
  //                             );
  //                             setState(() {
  //                               isLoadingButton = false;
  //                             });
  //                             return; // Impede a adição do produto
  //                           }
  //                           // Adiciona o produto ao pedido
  //                           if (flagService == true) {
  //                             bool success =
  //                                 await DataServiceAddProduct.sendDataOrder(
  //                                     context,
  //                                     urlBasic,
  //                                     token,
  //                                     widget.prevendaid ?? '',
  //                                     widget.empresaid ?? '',
  //                                     widget.produtoid ?? '',
  //                                     _complementocontroller.text,
  //                                     _quantidadecontroller.text,
  //                                     widget.flagunidadefracionada ?? 0,
  //                                     1,
  //                                     expedicaoId);

  //                             // Só chama o callback se o produto foi adicionado com sucesso
  //                             if (success && widget.onProductAdded != null) {
  //                               widget.onProductAdded!(bodyMap);
  //                             }

  //                             // Verifica se o widget ainda está montado antes de fechar o modal
  //                             if (mounted) {
  //                               _closeModal();
  //                               // Limpa os campos após adicionar o produto
  //                               _quantidadecontroller.clear();
  //                               _complementocontroller.clear();
  //                             }
  //                           } else {
  //                             bool success =
  //                                 await DataServiceAddProduct.sendDataOrder(
  //                                     context,
  //                                     urlBasic,
  //                                     token,
  //                                     widget.prevendaid ?? '',
  //                                     widget.empresaid ?? '',
  //                                     widget.produtoid ?? '',
  //                                     _complementocontroller.text,
  //                                     _quantidadecontroller.text,
  //                                     widget.flagunidadefracionada ?? 0,
  //                                     0,
  //                                     expedicaoId);

  //                             // Só chama o callback se o produto foi adicionado com sucesso
  //                             if (success && widget.onProductAdded != null) {
  //                               widget.onProductAdded!(bodyMap);
  //                             }

  //                             // Verifica se o widget ainda está montado antes de fechar o modal
  //                             if (mounted) {
  //                               _closeModal();
  //                               // Limpa os campos após adicionar o produto
  //                               _quantidadecontroller.clear();
  //                               _complementocontroller.clear();
  //                               expedicaoId = '';
  //                               expedicaoNome = '';
  //                               expedicaoCodigo = '';
  //                             }
  //                             setState(() {
  //                               isLoadingButton = false;
  //                             });
  //                           }

  //                           adicionarItemProduto(bodyMap);
  //                         },
  //                       ),
  //                       SizedBox(
  //                         height: Responsive.h(context, 10),
  //                       ),
  //                       RegisterButton(
  //                         text: 'Fechar',
  //                         color: ColorsApp.errorColor,
  //                         width: double.infinity,
  //                         onPressed: () {
  //                           _closeModal();
  //                         },
  //                       )
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  // void _closeModal() {
  //   Navigator.of(context).pop();
  // }

  void _increment() {
    setState(() {
      _quantity++;
      if (widget.flagunidadefracionada == 0 ||
          widget.flagunidadefracionada == null) {
        _quantidadecontroller.text =
            _quantity.toString().replaceAll(RegExp(r'\.0*$'), '');
      } else {
        _quantidadecontroller.text = _quantity.toString();
      }
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        if (widget.flagunidadefracionada == 0 ||
            widget.flagunidadefracionada == null) {
          _quantidadecontroller.text =
              _quantity.toString().replaceAll(RegExp(r'\.0*$'), '');
        } else {
          _quantidadecontroller.text = _quantity.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(
                      width: Responsive.h(context, 0.5),
                      color: ColorsApp.quarantineColor),
                  top: BorderSide(
                      width: Responsive.h(context, 0.5),
                      color: ColorsApp.quarantineColor),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  if (widget.imagem == null ||
                                      widget.imagem == '')
                                    Icon(
                                      Symbols.hide_image_rounded,
                                      size: Responsive.h(context, 50),
                                    )
                                  else
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                        child: TelaExibicaoImagem(
                                          url: widget.url ?? '',
                                          imagem: widget.imagem ?? '',
                                        )),
                                ],
                              ),
                              SizedBox(
                                width: Responsive.h(context, 10),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: Responsive.w(context, 130),
                                        child: Text(
                                          widget.nomeproduto ?? '',
                                          style: TextStyle(
                                              // color: Theme.of(context)
                                              //     .colorScheme
                                              //     .primary,
                                              fontSize:
                                                  Responsive.h(context, 8),
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
                                        widget.codigoproduto ?? '',
                                        style: TextStyle(
                                          fontSize: Responsive.h(context, 10),
                                          // color: Theme.of(context)
                                          //     .colorScheme
                                          //     .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  if (isCheckedProduct == true)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          onPressed: _decrement,
                                        ),
                                        SizedBox(
                                          width: Responsive.w(context, 50),
                                          child: Input(
                                            text: '',
                                            type: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            controller: _quantidadecontroller,
                                            onTap: () {
                                              setState(() {
                                                _quantidadecontroller.clear();
                                              });
                                            },
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSecondary,
                                          onPressed: _increment,
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: Responsive.h(context, 10),
                                  ),
                                  Container(
                                    height: Responsive.h(context, 25),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(
                                            Responsive.h(context, 5))),
                                    child: TextButton(
                                      onPressed: flagAction
                                          ? null : () async {
                                              if ((widget.quantidadeEstq ??
                                                              0.0) <= 0.0 &&
                                                      permPedidoEstoqueNegativo !=
                                                          true &&
                                                  flagprivilegiado != 1) {
                                                Message.showReturnOverlay(
                                                  context,
                                                  ColorsApp.errorColor,
                                                  Icons.error,
                                                  'Você não possui permissão para adicionar produtos com estoque zerado ou negativo.',
                                                );
                                                return;
                                              }
                                              if (widget.flagObrigarExpedicao ==
                                                      1 &&
                                                  (widget.expedicaoId ?? '')
                                                      .isEmpty) {
                                                Message.showReturnOverlay(
                                                    context,
                                                    ColorsApp.errorColor,
                                                    Icons.error,
                                                    'Selecione uma expedição.');
                                                return;
                                              } else {
                                                setState(() {
                                                  flagAction = true;
                                                });
                                                final uuid = const Uuid().v4();
                                                final bodyMap = {
                                                  'local_id': widget.localId,
                                                  'flag_sync': 1,
                                                  'imagem': widget.imagem,
                                                  'produto_id':
                                                      widget.produtoid,
                                                  'prevenda_id':
                                                      widget.prevendaid,
                                                  'prevendaproduto_id': uuid,
                                                  'codigoproduto':
                                                      widget.codigoproduto,
                                                  'nomeproduto':
                                                      widget.nomeproduto,
                                                  'nome': expedicaoNome,
                                                  'expedicao_id': expedicaoId,
                                                  'valorunitario':
                                                      widget.precotabela,
                                                  'quantidade': widget
                                                                  .quantidadeEstq !=
                                                              null &&
                                                          num.tryParse(widget
                                                                  .quantidadeEstq
                                                                  .toString()) !=
                                                              null
                                                      ? widget.quantidadeEstq
                                                      : 0,
                                                  'valortotal': widget
                                                                  .precotabela !=
                                                              null &&
                                                          num.tryParse(widget
                                                                  .precotabela
                                                                  .toString()) !=
                                                              null &&
                                                          widget.quantidadeEstq !=
                                                              null &&
                                                          num.tryParse(widget
                                                                  .quantidadeEstq
                                                                  .toString()) !=
                                                              null
                                                      ? (widget.precotabela ??
                                                              0.0) *
                                                          (widget.quantidadeEstq ??
                                                              0.0)
                                                      : 0,
                                                  'ean': '',
                                                };
                                                // if (isCheckedProduct == false) {
                                                //   _openModal(context);
                                                // } else
                                                if (flagService == true &&
                                                    isCheckedProduct == true) {
                                                  setState(() {
                                                    isLoadingButton = true;
                                                  });
                                                  bool success = await DataServiceAddProduct
                                                      .sendDataOrder(
                                                          context,
                                                          urlBasic,
                                                          token,
                                                          widget.prevendaid ??
                                                              '',
                                                          widget.empresaid ??
                                                              '',
                                                          widget.produtoid ??
                                                              '',
                                                          _complementocontroller
                                                              .text,
                                                          _quantity
                                                                  .toString()
                                                                  .isEmpty
                                                              ? '1'
                                                              : _quantity
                                                                  .toString(),
                                                          widget.flagunidadefracionada ??
                                                              0,
                                                          1,
                                                          widget.expedicaoId ??
                                                              expedicaoId);

                                                  // Só chama o callback se o produto foi adicionado com sucesso
                                                  if (success &&
                                                      widget.onProductAdded !=
                                                          null) {
                                                    widget.onProductAdded!(
                                                        bodyMap);
                                                  }

                                                  // Verifica se o widget ainda está montado antes de fechar o modal
                                                  // if (mounted) {
                                                  //   // _closeModal(success);
                                                  //   // Limpa os campos após adicionar o produto
                                                  //   _quantidadecontroller.clear();
                                                  //   _complementocontroller
                                                  //       .clear();
                                                  // }

                                                  adicionarItemProduto(bodyMap);
                                                } else {
                                                  bool success = await DataServiceAddProduct.sendDataOrder(
                                                      context,
                                                      urlBasic,
                                                      token,
                                                      widget.prevendaid ?? '',
                                                      widget.empresaid ?? '',
                                                      widget.produtounidademedidaId !=
                                                              'coluna_produtounidademedida_id'
                                                          ? widget.produtounidademedidaId ??
                                                              ''
                                                          : widget.produtoid ??
                                                              '',
                                                      _complementocontroller
                                                          .text,
                                                      _quantidadecontroller
                                                          .text,
                                                      widget.flagunidadefracionada ??
                                                          0,
                                                      0,
                                                      widget.expedicaoId ??
                                                          expedicaoId);

                                                  final uuid =
                                                      const Uuid().v4();
                                                  final Map<String, dynamic>
                                                      bodyMap = {
                                                    'local_id': widget.localId,
                                                    'flag_sync': 1,
                                                    'imagem': widget.imagem,
                                                    'produto_id':
                                                        widget.produtoid,
                                                    'prevenda_id':
                                                        widget.prevendaid,
                                                    'prevendaproduto_id': uuid,
                                                    'codigoproduto':
                                                        widget.codigoproduto,
                                                    'nomeproduto':
                                                        widget.nomeproduto,
                                                    'nome': expedicaoNome,
                                                    'expedicao_id': expedicaoId,
                                                    'valorunitario':
                                                        widget.precotabela,
                                                    'quantidade':
                                                        _quantidadecontroller
                                                            .text,
                                                    'valortotal': widget
                                                                    .precotabela !=
                                                                null &&
                                                            num.tryParse(widget
                                                                    .precotabela
                                                                    .toString()) !=
                                                                null &&
                                                            widget.quantidadeEstq !=
                                                                null &&
                                                            num.tryParse(widget
                                                                    .quantidadeEstq
                                                                    .toString()) !=
                                                                null
                                                        ? (widget.precotabela ??
                                                                0.0) *
                                                            (widget.quantidadeEstq ??
                                                                0.0)
                                                        : 0,
                                                    'ean': '',
                                                  };

                                                  // Só chama o callback se o produto foi adicionado com sucesso
                                                  if (success &&
                                                      widget.onProductAdded !=
                                                          null) {
                                                    widget.onProductAdded
                                                        ?.call(bodyMap);
                                                  }

                                                  adicionarItemProduto(bodyMap);

                                                  setState(() {
                                                    isLoadingButton = false;
                                                  });
                                                }
                                                setState(() {
                                                  flagAction = false;
                                                });
                                              }
                                            },
                                      child: flagAction
                                          ? const SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                  color:
                                                      ColorsApp.tertiaryColor,
                                                  strokeWidth: 2),
                                            )
                                          : Text(
                                              'Adicionar',
                                              style: TextStyle(
                                                  color:
                                                      ColorsApp.tertiaryColor,
                                                  fontSize:
                                                      Responsive.h(context, 8)),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isCheckedProduct == true)
                    Row(
                      children: [
                        Text(
                          currencyFormat.format(widget.precotabela).toString(),
                          style: TextStyle(
                              fontSize: Responsive.h(context, 10),
                              // color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(' | '),
                        Text(
                          widget.quantidadeEstq != null
                              ? 'Estq.: ${widget.quantidadeEstq.toString().replaceAll(RegExp(r'\.0*$'), '')}'
                              : 'Sem estoque',
                          style: TextStyle(
                            fontSize: Responsive.h(context, 10),
                            color: (widget.quantidadeEstq != null &&
                                    num.tryParse(
                                            widget.quantidadeEstq.toString()) !=
                                        null &&
                                    num.parse(
                                            widget.quantidadeEstq.toString()) <
                                        0)
                                ? ColorsApp.errorColor
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        )
                      ],
                    )
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _loadSavedPermPedidoEstoqueNegativo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedPermPedidoEstoqueNegativo =
        sharedPreferences.getBool('pedidoEstoqueNegativo') ?? false;
    setState(() {
      permPedidoEstoqueNegativo = savedPermPedidoEstoqueNegativo;
    });
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

  // Future<void> _loadSavedCheckProduct() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   bool savedCheckProduct = sharedPreferences.getBool('checkProduct') ??
  //       false; // Carrega o valor salvo (padrão: true)
  //   setState(() {
  //     isCheckedProduct =
  //         savedCheckProduct; // Atualiza o estado com o valor salvo
  //   });
  // }

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
    List<PopupMenuItem<String>> dynamicItems = expedition.map((expeditions) {
      return PopupMenuItem<String>(
        value: expeditions['expedicao_id'].toString(),
        key: Key(expeditions['nome'].toString()),
        child: Text(
            ('${expeditions['codigo']} - ${expeditions['nome']}').toString()),
      );
    }).toList();

    const PopupMenuDivider();

    return dynamicItems;
  }
}
