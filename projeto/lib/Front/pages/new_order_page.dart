import 'package:flutter/material.dart';
import 'package:projeto/back/get_cep.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/back/order_details.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderPage extends StatefulWidget {
  final prevendaId;
  final pessoaid;
  final numero;
  final pessoanome;
  final cpfcnpj;
  final telefone;
  final endereco;
  final bairro;
  final cidade;
  final cep;
  final complemento;
  final uf;

  final datahora;
  final valortotal;
  final codigoproduto;

  final noProduct;

  const NewOrderPage({
  super.key,
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
  this.noProduct = '0', // valor padrão
});

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String urlBasic = '';
  String token = '';
  String ibge = '';
  String cidade = '';

  late String pessoaid = '';
  late String nome = '';
  late String codigo = '';
  late String pessoanome = '';
  late String cpfcliente = '';
  late String telefone = '';
  late String enderecocep = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String enderecocidade = '';
  late String endereconumero = '';
  late String enderecocomplemento = '';
  late String uf = '';
  late String email = '';

  late String nomeproduto = '';
  late String codigoproduto = '';
  late String imagemurl = '';
  late String prevendaprodutoid = '';
  late String produtoid = '';
  late double valorunitario = 0.0;
  late double valortotalitem = 0.0;
  late double valortotal = 0.0;
  late double quantidade = 0.0;

  final _complementocontroller2 = TextEditingController();
  final _bairrocontroller = TextEditingController();
  final _localidadecontroller = TextEditingController();
  final _ibgecontroller = TextEditingController();
  final _ufcontroller = TextEditingController();
  final _logradourocontroller = TextEditingController();

  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSavedUrlBasic();
    _loadSavedToken();
    loadData();
    _refreshData();

    // cidade = _localidadecontroller.text;
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
              body: ListView(
                children: [
                  const Navbar(text: 'Novo pedido', children: [
                    NavbarButton(
                        destination: Home(), Icons: Icons.arrow_back_ios_new)
                  ]),
                  SizedBox(
                    height: Style.height_10(context),
                  ),
                  ProductSession(
                      prevendaid: widget.prevendaId.toString(),
                      pessoaid: pessoaid.toString(),
                      pessoanome: widget.pessoanome.toString(),
                      cpfcnpj: widget.cpfcnpj.toString(),
                      telefone: widget.telefone.toString(),
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
                      onProductRemoved: _onProductRemoved),
                  SizedBox(
                    height: Style.height_30(context),
                  ),
                  CustomerSession(
                      pessoanome: widget.pessoanome,
                      pessoaid: pessoaid,
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
                      noProduct: widget.noProduct,),
                  SizedBox(
                    height: Style.height_30(context),
                  ),
                ],
              ),
            ),
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

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
      // _loadSavedCidade(),
    ]);
    await Future.wait([
      fetchDataCliente2(),
      fetchDataOrdersDetails2(widget.prevendaId)
      // initializer(),
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
}
