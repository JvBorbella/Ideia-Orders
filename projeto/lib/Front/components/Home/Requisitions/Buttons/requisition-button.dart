import 'package:flutter/material.dart';
import 'package:projeto/Front/pages/solicitacion.dart';

class RequisitionButtom extends StatefulWidget {
  //Variável para que seja definido o texto do button na página em que está sendo chamado
  final String text;
  final int solicitacoesremotas;
  final token;
  final String url;
  final String urlBasic;

  const RequisitionButtom(
      {Key? key,
      required this.text,
      required this.solicitacoesremotas,
      this.token,
      this.url = '',
      this.urlBasic = '',
      })
      : super(key: key);

  @override
  State<RequisitionButtom> createState() => _RequisitionButtomState();
}

class _RequisitionButtomState extends State<RequisitionButtom> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          //Estilização
          border: Border.all(width: 2, color: Color(0xff42B9F0)),
          borderRadius: BorderRadius.circular(5),
        ),
        //Conteúdo interno do button
        child: Column(
          //Alinhamento interno
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              //Função acionada ao ser clicado
              onPressed: () {
                //Método para verificar se há requisições ou não.
                checkRequisitionsAndNavigate(context);
              },
              //Texto retornado da página em que está sendo chamado o button
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Color(0xff42b9f0),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        //Tamanho e espaçamento
        width: 160,
        padding: EdgeInsets.all(0),
      ),
    );
  }

  //Método para verificar o número de requisições, caso seja 0, será exibida uma mensagem,
  //caso seja diferente de 0, o usuário será direcionado à outra página
  void checkRequisitionsAndNavigate(BuildContext context) {
    //chamando a váriável do widget onde está sendo definido o número de requisições
    int numberOfRequisitions = widget.solicitacoesremotas;

    //Verificação
    if (numberOfRequisitions == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Não há nenhuma solicitação no momento!',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              Solicitacion(url: widget.url, token: widget.token, urlBasic: widget.urlBasic),
        ),
      );
    }
  }
}
