// import 'package:flutter/material.dart';
// import 'package:projeto/back/get_cliente.dart';
// import 'package:projeto/front/components/style.dart';
// import 'package:projeto/front/pages/order_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ModalNewOrder extends StatefulWidget {
//   final prevendaId;
//   final numero;
//   final pessoanome;
//   final cpfcnpj;
//   final telefone;
//   final endereco;
//   final bairro;
//   final cidade;
//   final cep;
//   final complemento;
//   final uf;
//   final operador;

//   final datahora;
//   final valortotal;
//   final codigoproduto;
//   const ModalNewOrder({ 
//   Key? key,
//     this.prevendaId,
//     this.numero,
//     this.pessoanome,
//     this.cpfcnpj,
//     this.telefone,
//     this.endereco,
//     this.bairro,
//     this.cidade,
//     this.cep,
//     this.complemento,
//     this.uf,
//     this.datahora,
//     this.valortotal,
//     this.codigoproduto,
//     this.operador
//   });

//   @override
//   State<ModalNewOrder> createState() => _ModalNewOrderState();
// }

// class _ModalNewOrderState extends State<ModalNewOrder> {
//   String urlBasic = '';
//   String token = '';

//   late String pessoaid = '';
//   late String nome = '';
//   late String codigo = '';
//   late String pessoanome = '';
//   late String cpfcliente = '';
//   late String telefone = '';
//   late String enderecocep = '';
//   late String endereco = '';
//   late String enderecobairro = '';
//   late String enderecocidade = '';
//   late String endereconumero = '';
//   late String enderecocomplemento = '';
//   late String uf = '';

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: OrderPage(
//         prevendaId: widget.prevendaId, 
//         numero: widget.numero, 
//         pessoanome: nome,  
//         cpfcnpj: cpfcliente, 
//         telefone: telefone, 
//         endereco: endereco, 
//         enderecobairro: enderecobairro, 
//         enderecocep: enderecocep, 
//         enderecocomplemento: enderecocomplemento, 
//         uf: uf, 
//         operador: widget.operador, 
//         datahora: widget.datahora, 
//         valortotal: widget.valortotal, 
//         codigoproduto: widget.codigoproduto)
//     );
//   }

//   Future<void> _loadSavedUrlBasic() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String savedUrlBasic = sharedPreferences.getString('urlBasic') ?? '';
//     setState(() {
//       urlBasic = savedUrlBasic;
//     });
//   }

//   Future<void> _loadSavedToken() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String savedToken = sharedPreferences.getString('token') ?? '';
//     setState(() {
//       token = savedToken;
//     });
//   }

//   Future<void> loadData() async {
//     await Future.wait([
//       _loadSavedUrlBasic(),
//       _loadSavedToken()
//     ]);
//     await Future.wait([
//       fetchDataCliente2(),
//       // initializer(),
//     ]);
//   }

//   Future<void> fetchDataCliente2() async {
//     final data =
//         await DataServiceCliente2.fetchDataCliente2(urlBasic, widget.cpfcnpj);
//     setState(() {
//       pessoaid = data['pessoa_id'].toString();
//       nome = data['nome'].toString();
//       cpfcliente = data['cpf'].toString();
//       telefone = data['telefone'].toString();
//       endereco = data['endereco'].toString();
//       enderecobairro = data['enderecobairro'].toString();
//       endereconumero = data['endereconumero'].toString();
//       enderecocomplemento = data['enderecocomplemento'].toString();
//       enderecocep = data['enderecocep'].toString();
//       enderecocidade = data['enderecocidade'].toString();
//       uf = data['uf'].toString();
//       codigo = data['codigo'].toString();
//     });
//   }
// }