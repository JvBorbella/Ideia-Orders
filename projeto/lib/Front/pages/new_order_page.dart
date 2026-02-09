import 'package:flutter/material.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/back/customer/get_cep.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/orders/order_details.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/global/elements/modal.dart';
import 'package:projeto/front/components/login_config/elements/config_button.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderPage extends StatefulWidget {
  final prevendaId,
      pessoaid,
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
      datahora,
      valortotal,
      codigoproduto,
      noProduct,
      operador,
      empresa_id,
      local_id,
      valordesconto;

  const NewOrderPage(
      {super.key,
      this.prevendaId,
      this.pessoaid,
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
      this.datahora,
      this.valortotal,
      this.codigoproduto,
      this.operador,
      this.noProduct = '0',
      this.empresa_id,
      this.local_id,
      this.valordesconto});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String urlBasic = '', token = '', ibge = '', cidade = '';

  final GlobalKey<CustomerSessionState> customerKey =
      GlobalKey<CustomerSessionState>();

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
      nomeInformado = '';

  late double valorunitario = 0.0,
      valortotalitem = 0.0,
      valortotal = 0.0,
      quantidade = 0.0;

  bool FlagGerarPedido = false,
      isLoading = true,
      loadSaveOrder = false,
      permEditarPrevenda = false;

  final _complementocontroller2 = TextEditingController(),
      _bairrocontroller = TextEditingController(),
      _localidadecontroller = TextEditingController(),
      _ibgecontroller = TextEditingController(),
      _ufcontroller = TextEditingController(),
      _logradourocontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    _refreshData();
    print(widget.cpfcnpj);
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
        child: WillPopScope(
            child: Scaffold(
                body: Column(
              children: [
                Navbar(text: 'Novo pedido', children: [
                  const NavbarButton(
                      destination: Home(), Icons: Icons.arrow_back_ios_new),
                  Container(
                    padding: EdgeInsets.only(right: Style.height_5(context)),
                    child: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) =>
                          buildMenuItems(options),
                      onSelected: (value) async {
                        switch (value) {
                          case 'finalizar':
                            await customerKey.currentState?.finishOrder();
                          case 'gravar':
                            if (permEditarPrevenda == false) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialogDefault());
                            } else {
                              await customerKey.currentState?.saveOrder();
                            }
                            ;
                          case 'desconto':
                            await customerKey.currentState?.openModalDesc();
                            break;
                        }
                      },
                      child: Icon(
                        Icons.more_vert_rounded,
                        color: Style.tertiaryColor,
                        size: Style.height_20(context),
                      ),
                    ),
                  )
                ]),
                Expanded(
                  child: ListView(
                    children: [
                      ProductSession(
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
                        valortotal: valortotal.toDouble(),
                        quantidade: quantidade.toDouble(),
                        imagemurl: imagemurl.toString(),
                        onProductRemoved: _onProductRemoved,
                        empresa_id: widget.empresa_id,
                        valordesconto: widget.valordesconto,
                        local_id: widget.local_id,
                      ),
                      SizedBox(
                        height: Style.height_15(context),
                      ),
                      CustomerSession(
                        key: customerKey,
                        pessoanome: widget.pessoanome,
                        pessoaid: widget.pessoaid,
                        cpfcnpj: widget.cpfcnpj,
                        telefone: widget.telefone,
                        cep: enderecocep,
                        bairro: enderecobairro,
                        numero: endereconumero,
                        endereco: endereco,
                        complemento: enderecocomplemento,
                        cidade: _localidadecontroller.text,
                        uf: uf,
                        email: email,
                        prevendaid: widget.prevendaId,
                        numpedido: widget.numero.toString(),
                        noProduct: widget.noProduct,
                        valordesconto: widget.valordesconto,
                        empresa_id: widget.empresa_id,
                        local_id: widget.local_id,
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
                      ),
                      SizedBox(
                        height: Style.height_30(context),
                      ),
                    ],
                  ),
                )
              ],
            )),
            onWillPop: () async {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Home()));
              return true;
            }));
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

  //   Future<void> _loadSavedCidade() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String savedCidade = sharedPreferences.getString('localidade') ?? '';
  //   setState(() {
  //     cidade = savedCidade;
  //   });
  // }
  Future<void> _loadSavedPermEditarPrevenda() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool savedEditarPrevenda =
        sharedPreferences.getBool('editarPrevenda') ?? false;
    setState(() {
      permEditarPrevenda = savedEditarPrevenda;
    });
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      _loadSavedToken(),
      _loadSavedPermEditarPrevenda()
    ]);
    final hasInternet = await hasInternetConnection();

    if (!hasInternet) {} 
    else {
      await Future.wait(
        [fetchDataCliente2(), //fetchDataOrdersDetails2(widget.prevendaId)
        ]);
    await GetCep.getcep(
        enderecocep,
        _logradourocontroller,
        _complementocontroller2,
        _bairrocontroller,
        _ufcontroller,
        _localidadecontroller,
        _ibgecontroller,
        ibge);
    }
    
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  void _onProductRemoved() {
    // Recarrega a página inteira, passando '1' como valor para noProduct
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NewOrderPage(
          prevendaId: widget.prevendaId,
          numero: widget.numero,
          pessoanome: widget.pessoanome,
          cpfcnpj: widget.cpfcnpj,
          telefone: widget.telefone,
          endereco: widget.endereco,
          bairro: widget.bairro,
          cidade: widget.cidade,
          cep: widget.cep,
          complemento: widget.complemento,
          uf: widget.uf,
          datahora: widget.datahora,
          valortotal: widget.valortotal,
          codigoproduto: widget.codigoproduto,
          noProduct: '1',
        ),
      ),
    );
  }

  Future<void> fetchDataCliente2() async {
    final data = await DataServiceCliente2.fetchDataCliente2(
        urlBasic, widget.cpfcnpj, token);
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
    });
  }

  Future<void> fetchDataOrdersDetails2(String prevendaId) async {
    final data = await DataServiceOrdersDetails2.fetchDataOrdersDetails2(
        urlBasic, prevendaId);
    setState(() {
      pessoanome = data['pessoa_nome'].toString();
      cpfcliente = data['cpfcnpj'].toString();
      telefone = data['telefone'].toString();
      codigoproduto = data['codigo'].toString();
      nomeproduto = data['nome'].toString();
      imagemurl = data['imagem_url'].toString();
      prevendaprodutoid = data['prevendaproduto_id'].toString();
      produtoid = data['produto_id'].toString();
      valorunitario = double.parse(data['valorunitario'] ?? '0.0');
      valortotalitem = double.parse(data['valortotalitem'] ?? '0.0');
      valortotal = double.parse(data['valortotal'] ?? '0.0');
      quantidade = double.parse(data['quantidade'] ?? '0.0');
    });
  }

  List<PopupMenuItem<String>> buildMenuItems(List<dynamic> options) {
    List<PopupMenuItem<String>> staticItems = [
      PopupMenuItem(
          enabled: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Text('Empresa'),
              Container(
                margin: EdgeInsets.only(bottom: Style.height_5(context)),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Style.height_5(context)),
                    color: Style.errorColor),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

    List<PopupMenuItem<String>> optionItems = [
      PopupMenuItem(
        value: 'gravar',
        child: Text('Gravar'),
      ),
      PopupMenuItem(
        value: 'finalizar',
        child: Text('Finalizar'),
      ),
      PopupMenuItem(
        value: 'desconto',
        child: Text(
          'Aplicar Desconto',
          //style: TextStyle(fontSize: Style.height_10(context)),
        ),
      ),
    ];

    const PopupMenuDivider();

    return staticItems + optionItems;
  }
}
