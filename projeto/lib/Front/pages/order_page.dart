import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:projeto/front/components/Global/Elements/text_title.dart';
import 'package:projeto/front/components/order_page/elements/name_inputblocked.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:projeto/front/components/order_page/elements/cancel_button.dart';
import 'package:projeto/front/components/order_page/elements/input_blocked.dart';
import 'package:projeto/front/components/order_page/elements/products_order.dart';
import 'package:projeto/front/pages/home.dart';

class OrderPage extends StatefulWidget {
  final String prevendaId;
  final String numero;
  final String nome;
  final String cpfcnpj;
  final String telefonecontato;
  final String endereco;
  final String enderecobairro;
  final String enderecocep;
  final String enderecocomplemento;
  final String uf;
  final DateTime data;
  final DateTime datahora;
  final double valorsubtotal;

  const OrderPage({
    Key? key, 
    required this.prevendaId,
    required this.numero,
    required this.nome,
    required this.cpfcnpj,
    required this.telefonecontato,
    required this.endereco,
    required this.enderecobairro,
    required this.enderecocep,
    required this.enderecocomplemento,
    required this.uf,
    required this.data,
    required this.datahora,
    required this.valorsubtotal,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

   NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

      String formatCpfCnpj(String cpfCnpj) {
    if (cpfCnpj.length == 11) {
      // CPF
      return UtilBrasilFields.obterCpf(cpfCnpj);
    } else if (cpfCnpj.length == 14) {
      // CNPJ
      return UtilBrasilFields.obterCnpj(cpfCnpj);
    } else {
      // Não formatado
      return cpfCnpj;
    }
  }
   String formatTel(String telefonecontato) {
    if (telefonecontato.length > 10) {
      // CPF
      return UtilBrasilFields.obterTelefone(telefonecontato);
    } else {
      // Não formatado
      return telefonecontato;
    }
  }
  
  final cepFormatter = MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: ListView(
        children: [
          Navbar(text: 'Pedido', children: [
            NavbarButton(destination: Home(), Icons: Icons.arrow_back_ios_new)
          ]),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            height: Style.height_35(context),
            margin: EdgeInsets.only(
              left: Style.height_8(context),
              right: Style.height_8(context),
            ),
            padding: EdgeInsets.all(Style.height_8(context)),
            decoration: BoxDecoration(
              color: Style.primaryColor,
              borderRadius: BorderRadius.circular(Style.height_15(context)),
            ),
            child: Text(
              'Nº do pedido - ' + widget.numero,
              style: TextStyle(
                  fontSize: Style.height_15(context),
                  color: Style.tertiaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Style.height_5(context),
          ),
          Container(
            padding: EdgeInsets.only(left: Style.height_12(context)),
            child: Text(
              'Data do pedido - ' + DateFormat('dd/MM/yyyy hh:mm:ss').format(widget.datahora),
              style: TextStyle(
                  color: Style.primaryColor,
                  fontSize: Style.height_12(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: Style.height_10(context),
          ),
          TextTitle(text: 'Produto(s)'),
          SizedBox(
            height: Style.height_10(context),
          ),
          // ProductsOrder(),
          // ProductsOrder(),
          // ProductsOrder(),
          SizedBox(
            height: Style.height_10(context),
          ),
          Center(
            child: Text(
              'Total - ' + currencyFormat.format(widget.valorsubtotal),
              style: TextStyle(
                  color: Style.primaryColor,
                  fontSize: Style.height_15(context),
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextTitle(text: 'Dados do Cliente'),
          SizedBox(
            height: Style.height_10(context),
          ),
          Container(
            padding: EdgeInsets.only(
                left: Style.height_15(context),
                right: Style.height_15(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameInputblocked(text: 'Nome'),
                InputBlocked(value: widget.nome),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'CPF/CNPJ'),
                          InputBlocked(value: formatCpfCnpj(widget.cpfcnpj))
                          ],
                      ),
                    ),
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'Telefone'),
                          InputBlocked(value: formatTel(widget.telefonecontato))],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                NameInputblocked(text: 'Endereço'),
                InputBlocked(value: widget.endereco),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_225(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'Complemento'),
                          InputBlocked(value: widget.enderecocomplemento)],
                      ),
                    ),
                    Container(
                      width: Style.width_80(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'UF'),
                          InputBlocked(value: widget.uf)],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_10(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'Bairro'),
                          InputBlocked(value: widget.enderecobairro)],
                      ),
                    ),
                    Container(
                      width: Style.width_150(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NameInputblocked(text: 'CEP'),
                          InputBlocked(value: cepFormatter.maskText(widget.enderecocep))
                          ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_20(context),
                ),
                Container(
                  alignment: Alignment.center,
                  child: CancelButton(),
                ),
                
                SizedBox(
                  height: Style.height_10(context),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
