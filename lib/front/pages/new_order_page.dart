import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projeto/back/customer/get_cep.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto/back/system/pdf_generator.dart';

class NewOrderPage extends StatefulWidget {
  final String? prevendaId,
      pessoaid,
      vendedorId,
      numero,
      pessoanome,
      cpfcnpj,
      telefone,
      endereco,
      bairro,
      cidade,
      cep,
      complemento,
      uf,
      codigoproduto,
      noProduct,
      operador,
      empresaId,
      empresaCodigo,
      empresaNome,
      tabelaprecoId,
      tabelapreco,
      localId;
  final DateTime? datahora;
  final double? valortotal, valordesconto;
  final int? flagObrigarVendedor, flagObrigarCliente, flagObrigarExpedicao;

  const NewOrderPage({
    super.key,
    this.prevendaId,
    this.pessoaid,
    this.vendedorId,
    this.numero,
    this.pessoanome,
    this.cpfcnpj,
    this.telefone,
    this.endereco,
    this.bairro,
    this.cidade,
    this.cep,
    this.complemento,
    this.uf,
    this.codigoproduto,
    this.operador,
    this.noProduct = '0',
    this.empresaId,
    this.empresaCodigo,
    this.empresaNome,
    this.tabelaprecoId,
    this.tabelapreco,
    this.localId,
    this.datahora,
    this.valortotal,
    this.valordesconto,
    this.flagObrigarVendedor,
    this.flagObrigarCliente,
    this.flagObrigarExpedicao,
  });

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String urlBasic = '', token = '', ibge = '', cidade = '';

  final GlobalKey<ProductSessionState> productKey =
      GlobalKey<ProductSessionState>();

  List<dynamic> options = [];

  late String pessoaid = '',
      nome = '',
      codigo = '',
      pessoanome = '',
      cpfcliente = '',
      telefone = '',
      enderecocep = '',
      endereco = '',
      enderecobairro = '',
      enderecocidade = '',
      endereconumero = '',
      enderecocomplemento = '',
      uf = '',
      email = '',
      nomeproduto = '',
      codigoproduto = '',
      imagemurl = '',
      prevendaprodutoid = '',
      produtoid = '',
      cpfInformado = '',
      telInformado = '',
      nomeInformado = '',
      iestadual = '',
      imunicipal = '',
      noProduct = widget.noProduct ?? '0';

  String empresaId = '',
      empresaCodigo = '',
      empresaNome = '',
      tabelaPrecoId = '',
      tabelaPrecoNome = '';

  late double valorunitario = 0.0,
      valortotalitem = 0.0,
      valortotal = 0.0,
      quantidade = 0.0;

  bool flagGerarPedido = false,
      isLoading = true,
      loadSaveOrder = false,
      permEditarPrevenda = false;

  int flagObrigarVendedor = 0, flagObrigarCliente = 0, flagObrigarExpedicao = 0;

  late int flagprivilegiado;

  final _complementocontroller2 = TextEditingController(),
      _bairrocontroller = TextEditingController(),
      _localidadecontroller = TextEditingController(),
      _ibgecontroller = TextEditingController(),
      _ufcontroller = TextEditingController(),
      _logradourocontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFlagPrivilegiado();
    _loadData();
    _refreshData();
  }

  Future<void> _loadFlagPrivilegiado() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int savedFlagPrivilegiado =
        sharedPreferences.getInt('flagprivilegiado') ?? 0;
    setState(() {
      flagprivilegiado = savedFlagPrivilegiado;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (customerKey.currentState?.isCustomerSaved == false) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Atenção'),
              content: const Text('A pré-venda não foi salva'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                  child: const Text('Sair mesmo assim'),
                ),
                TextButton(
                  onPressed: () async {
                    await customerKey.currentState?.saveOrder();
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const Home()));
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()));
        }
      },
      child: Scaffold(
          body: Column(
        children: [
          Navbar(text: 'Novo pedido #PV${widget.numero}', children: [
            NavbarButton(
                onPressed: () {
                  if (customerKey.currentState?.isCustomerSaved == false) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Atenção'),
                        content: const Text('A pré-venda não foi salva'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const Home()));
                            },
                            child: const Text('Sair mesmo assim'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await customerKey.currentState?.saveOrder();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Home()));
                              }
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Home()));
                  }
                },
                icons: Icons.arrow_back_ios_new),
            Container(
              padding: EdgeInsets.only(right: Responsive.h(context, 5)),
              child: PopupMenuButton<String>(
                itemBuilder: (BuildContext context) => buildMenuItems(options),
                onSelected: (value) async {
                  switch (value) {
                    case 'finalizar':
                      await customerKey.currentState?.finishOrder();
                      break;
                    case 'gravar':
                      if (permEditarPrevenda == false &&
                          flagprivilegiado != 1) {
                        showDialog(
                            context: context,
                            builder: (_) => const AlertDialogDefault());
                      } else {
                        await customerKey.currentState?.saveOrder();
                      }
                      break;
                    case 'pdf':
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PdfGeneratorViewer(
                            prevendaId: widget.prevendaId,
                            numero: widget.numero,
                            urlBasic: urlBasic,
                            token: token,
                            vendedor: '',
                            valordesconto: widget.valordesconto ?? 0.0,
                            empresa:
                                '${widget.empresaCodigo} - ${widget.empresaNome}',
                            products: productKey.currentState?.orders,
                            valortotal: (widget.valortotal ?? 0.0) -
                                (widget.valordesconto ?? 0.0),
                          ),
                        ),
                      );
                      break;
                    case 'desconto':
                      await customerKey.currentState?.openModalDesc();
                      break;
                  }
                },
                child: Icon(
                  Icons.more_vert_rounded,
                  color: ColorsApp.tertiaryColor,
                  size: Responsive.h(context, 20),
                ),
              ),
            )
          ]),
          Expanded(
            child: ListView(
              children: [
                ProductSession(
                  key: productKey,
                  prevendaid: widget.prevendaId.toString(),
                  pessoaid: widget.pessoaid.toString(),
                  numpedido: widget.numero.toString(),
                  pessoanome: nomeInformado.isNotEmpty
                      ? nomeInformado
                      : widget.pessoanome.toString(),
                  cpfcnpj: cpfInformado.isNotEmpty
                      ? cpfInformado
                      : widget.cpfcnpj.toString(),
                  telefone: telInformado.isNotEmpty
                      ? telInformado
                      : widget.telefone.toString(),
                  cep: widget.cep.toString(),
                  bairro: widget.bairro.toString(),
                  cidade: widget.cidade.toString(),
                  endereco: widget.endereco.toString(),
                  complemento: widget.complemento.toString(),
                  produtoid: produtoid.toString(),
                  prevendaprodutoid: prevendaprodutoid.toString(),
                  nomeproduto: nomeproduto.toString(),
                  codigoproduto: codigoproduto.toString(),
                  valorunitario: valorunitario.toDouble(),
                  valortotalitem: valortotalitem.toDouble(),
                  valortotal: widget.valortotal ?? 0.0,
                  quantidade: quantidade.toDouble(),
                  imagemurl: imagemurl.toString(),
                  onProductRemoved: _onProductRemoved,
                  onProductAdded: _onProductAdded,
                  empresaId: empresaId == '' ? widget.empresaId : empresaId,
                  empresaCodigo: empresaCodigo == ''
                      ? widget.empresaCodigo
                      : empresaCodigo,
                  empresaNome:
                      empresaNome == '' ? widget.empresaNome : empresaNome,
                  tabelaprecoId: tabelaPrecoId == ''
                      ? widget.tabelaprecoId
                      : tabelaPrecoId,
                  tabelapreco: tabelaPrecoNome == ''
                      ? widget.tabelapreco
                      : tabelaPrecoNome,
                  valordesconto: widget.valordesconto,
                  localId: widget.localId,
                  flagObrigarVendedor: widget.flagObrigarVendedor,
                  flagObrigarCliente: widget.flagObrigarCliente,
                  flagObrigarExpedicao: flagObrigarExpedicao,
                ),
                SizedBox(
                  height: Responsive.h(context, 15),
                ),
                CustomerSession(
                  key: customerKey,
                  productKey: productKey,
                  pessoanome: nome ?? widget.pessoanome,
                  pessoaid: widget.pessoaid,
                  vendedorId: widget.vendedorId,
                  cpfcnpj: widget.cpfcnpj,
                  telefone: telefone ?? widget.telefone,
                  cep: enderecocep,
                  bairro: enderecobairro,
                  numero: endereconumero,
                  endereco: endereco,
                  complemento: enderecocomplemento,
                  cidade: _localidadecontroller.text,
                  uf: uf,
                  email: email,
                  iestadual: iestadual ?? '',
                  imunicipal: imunicipal ?? '',
                  prevendaid: widget.prevendaId,
                  numpedido: widget.numero.toString(),
                  noProduct: noProduct,
                  valordesconto: widget.valordesconto,
                  empresaId: widget.empresaId,
                  empresaCodigo: widget.empresaCodigo,
                  empresaNome: widget.empresaNome,
                  tabelaprecoId: widget.tabelaprecoId,
                  tabelapreco: widget.tabelapreco,
                  localId: widget.localId,
                  valortotal: widget.valortotal,
                  onCpfAtualizado: (cpf) {
                    setState(() {
                      cpfInformado = cpf;
                    });
                  },
                  onTelAtualizado: (telefone) {
                    setState(() {
                      telInformado = telefone;
                    });
                  },
                  onNomeAtualizado: (nome) {
                    setState(() {
                      nomeInformado = nome;
                    });
                  },
                  onCompanyChanged: (
                      {required empresaId,
                      required empresaCodigo,
                      required empresaNome,
                      required tabelaPrecoId,
                      required tabelaPrecoNome,
                      required flagObrigarVendedor,
                      required flagObrigarCliente,
                      required flagObrigarExpedicao}) {
                    setState(() {
                      this.empresaId = empresaId;
                      this.empresaCodigo = empresaCodigo;
                      this.empresaNome = empresaNome;
                      this.tabelaPrecoId = tabelaPrecoId;
                      this.tabelaPrecoNome = tabelaPrecoNome;
                      this.flagObrigarVendedor = flagObrigarVendedor;
                      this.flagObrigarCliente = flagObrigarCliente;
                      this.flagObrigarExpedicao = flagObrigarExpedicao;
                    });
                  },
                ),
                SizedBox(
                  height: Responsive.h(context, 30),
                ),
              ],
            ),
          )
        ],
      )),
    ));
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

  Future<void> _loadSavedPermEditarPrevenda() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedEditarPrevenda =
        sharedPreferences.getBool('editarPrevenda') ?? false;
    setState(() {
      permEditarPrevenda = savedEditarPrevenda;
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
      _loadSavedPermEditarPrevenda()
    ]);
    flagObrigarExpedicao = widget.flagObrigarExpedicao ?? 0;

    if (widget.cpfcnpj != '') {
      await Future.wait([
        fetchDataCliente2(),
      ]);
      await GetCep.getcep(
          enderecocep,
          _logradourocontroller,
          //_complementocontroller2,
          _bairrocontroller,
          _ufcontroller,
          _localidadecontroller,
          _ibgecontroller,
          ibge);
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
    setState(() {
      isLoading = false;
    });
  }

  void _onProductRemoved() {
    customerKey.currentState?.hasProduct = false;
  }

  void _onProductAdded() {
    // Em vez de recriar a página, apenas avisa o CustomerSession
    customerKey.currentState?.hasProduct = true;
    customerKey.currentState?.markProductAdded();
  }

  Future<void> fetchDataCliente2() async {
    final data = await DataServiceCliente2.fetchDataCliente2(
        urlBasic, widget.cpfcnpj ?? '', token);
    setState(() {
      pessoaid = data['pessoa_id'].toString();
      nome = data['nome'].toString();
      cpfcliente = data['cpf'].toString();
      telefone = data['telefone'].toString();
      endereco = data['endereco'].toString();
      enderecobairro = data['enderecobairro'].toString();
      endereconumero = data['endereconumero'].toString();
      enderecocomplemento = data['enderecocomplemento'].toString();
      enderecocep = data['enderecocep'].toString();
      enderecocidade = data['enderecocidade'].toString();
      uf = data['uf'].toString();
      codigo = data['codigo'].toString();
      email = data['emailcontato'].toString();
      iestadual = data['inscricaoestadual'].toString();
      imunicipal = data['inscricaomunicipal'].toString();
    });
  }

  List<PopupMenuItem<String>> buildMenuItems(List<dynamic> options) {
    List<PopupMenuItem<String>> optionItems = [
      const PopupMenuItem(
        value: 'gravar',
        child: Text('Gravar'),
      ),
      const PopupMenuItem(
        value: 'pdf',
        child: Text('Gerar PDF'),
      ),
      // const PopupMenuItem(
      //   value: 'finalizar',
      //   child: Text('Finalizar'),
      // ),
      const PopupMenuItem(
        value: 'desconto',
        child: Text(
          'Aplicar Desconto',
          //style: TextStyle(fontSize: Responsive.h(context, 10)),
        ),
      ),
    ];

    const PopupMenuDivider();

    return optionItems;
  }
}
