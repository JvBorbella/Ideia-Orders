import 'package:flutter/material.dart';
import 'package:projeto/back/get_cliente.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/components/new_order/sessions/product/product_session.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewOrderPage extends StatefulWidget {
  final prevendaId;
  final numero;
  final pessoanome;
  final cpfcnpj;
  final telefone;
  final endereco;
  final bairro;
  final cep;
  final complemento;
  final uf;

  final datahora;
  final valortotal;
  final codigoproduto;

  const NewOrderPage({
    Key? key,
    this.prevendaId,
    this.numero,
    this.pessoanome,
    this.cpfcnpj,
    this.telefone,
    this.endereco,
    this.bairro,
    this.cep,
    this.complemento,
    this.uf,

    this.datahora,
    this.valortotal,
    this.codigoproduto,
  }) : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String urlBasic = '';
  String token = '';

  late String pessoaid = '';
  late String nome = '';
  late String codigo = '';
  late String cpfcliente = '';
  late String telefone = '';
  late String enderecocep = '';
  late String endereco = '';
  late String enderecobairro = '';
  late String endereconumero = '';
  late String enderecocomplemento = '';
  late String uf = '';

  bool isLoading = true;

  // final _cepcontroller = TextEditingController();
  // final _complementocontroller = TextEditingController();
  // final _bairrocontroller = TextEditingController();
  // final _ufcontroller = TextEditingController();
  // final _logradourocontroller = TextEditingController();
  // final _cpfcontroller = TextEditingController();
  // final _nomecontroller = TextEditingController();
  // final _telefonecontatocontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _loadSavedUrlBasic();
    _loadSavedToken();
    // print(widget.cpfcnpj);
    loadData();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
      if (isLoading) {
      return Scaffold(
        body:  Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          Navbar(text: 'Novo pedido', children: [
            NavbarButton(destination: Home(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          ProductSession(
            pessoanome: widget.pessoanome.toString(),
            cpfcnpj: widget.cpfcnpj.toString(),
            telefone: widget.telefone.toString(),
            cep: widget.cep.toString(),
            bairro: widget.bairro.toString(),
            endereco: widget.endereco.toString(),
            complemento: widget.complemento.toString(),
          ),
          SizedBox(
            height: Style.height_30(context),
          ),
          CustomerSession(
            pessoanome: widget.pessoanome,
            cpfcnpj: widget.cpfcnpj,
            telefone: widget.telefone,
            cep: enderecocep,
            bairro: enderecobairro,
            numero: endereconumero,
            endereco: endereco,
            complemento: enderecocomplemento,
          ),
          SizedBox(
            height: Style.height_30(context),
          ),
        ],
      ),
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

  // Future<void> initializer() async {
  //   setState(() {
  //   _cepcontroller.text = widget.cep;
  //   _bairrocontroller.text = widget.bairro.toString();
  //   _complementocontroller.text = widget.complemento.toString();
  //   _ufcontroller.text = '';
  //   _logradourocontroller.text = widget.endereco.toString();
  //   _nomecontroller.text = widget.pessoanome.toString();
  //   _cpfcontroller.text = cpf;
  //   _cepcontroller.text = enderecocep;
  //   });
  // }

  Future<void> loadData() async {
    await Future.wait([
      _loadSavedUrlBasic(),
    ]);
    await Future.wait([
      fetchDataCliente2(),
      // initializer(),
    ]);
  }

  Future<void> _refreshData() async {
    await loadData();
    setState(() {
      isLoading = false;
    });
  }
  Future<void> fetchDataCliente2() async {
  final data = await DataServiceCliente2.fetchDataCliente2(urlBasic, widget.cpfcnpj);
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
    uf = data['uf'].toString();
    codigo = data['codigo'].toString();

    // Atualiza os controladores com os novos valores
    // _cepcontroller.text = enderecocep;
    // _bairrocontroller.text = enderecobairro;
    // _complementocontroller.text = enderecocomplemento;
    // _ufcontroller.text = uf;
    // _logradourocontroller.text = endereco;
    // _nomecontroller.text = nome;
    // _cpfcontroller.text = cpfcliente;
    // _telefonecontatocontroller.text = telefone;
  });
}
}
