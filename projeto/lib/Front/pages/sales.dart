import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Global/Elements/Navbar-Button.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Sales/Elements/Details.dart';
import 'package:projeto/Front/components/Sales/Elements/values.dart';
import 'package:projeto/Front/components/Sales/Estructure/Card-Sales.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/home.dart';

class Sales extends StatefulWidget {
  final token;
  final String url;
  final String empresaNome;
  final double valorHoje;
  final double valorOntem;
  final double valorSemana;
  final double valorMes;
  final int ticketHoje;
  final int ticketOntem;

  const Sales(
      {Key? key,
      this.token,
      this.url = '',
      required this.valorHoje,
      required this.empresaNome,
      required this.valorOntem,
      required this.ticketHoje,
      required this.ticketOntem,
      required this.valorSemana,
      required this.valorMes,
      })
      : super(key: key);

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: [
              //Código da Navbar
              Navbar(children: [
                //Chamando os elementos internos da navbar
                ButtonNavbar(
                  destination: Home(
                    url: widget.url,
                    token: widget.token,
                  ),
                  Icons: Icons.arrow_back_ios_new,
                ),
              ], text: 'Vendas'),
              //Widget do card dos números detalhados das vendas
              CardSale(
                children: [
                  //Chamando elementos para dentro do card
                  Text(
                    widget.empresaNome,
                    style: TextStyle(fontSize: 22, color: Style.quarantineColor),
                  ),
                  SizedBox(
                    height: Style.ContentInternalSpace,
                  ),
                  //Widget dos valores
                  Values(
                      valorHoje: widget.valorHoje,
                      valorOntem: widget.valorOntem,
                      valorSemana: widget.valorSemana,
                      valorMes: widget.valorMes,
                      ),
                  SizedBox(
                    height: Style.ContentInternalSpace,
                  ),
                  //Widget dos valores adicionais - rodapé do card
                  Details(
                    ticketHoje: widget.ticketHoje,
                    ticketOntem: widget.ticketOntem,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
