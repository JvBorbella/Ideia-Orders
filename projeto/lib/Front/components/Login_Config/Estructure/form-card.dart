import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class FormCard extends StatefulWidget {
  //Variável para permitir que sejam inseridos outros elementos dentro do card.
  final List<Widget> children;

  const FormCard({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      //Código do form container.
      child: Column(
        children: [
          // Imagem usada nas telas de login e config.
          Image.network(
                'https://bdc.ideiatecnologia.com.br/wp/wp-content/uploads/2024/02/IDEIA-LOGO-AZUL-e1707321339855.png',
                color: Style.primaryColor,
                height: 75,
              ),
              //Área do container com os widgets de form.
          Container(
            child: Column(
              children: widget.children,
            ),
            //Espaçamento interno do container.
            padding: EdgeInsets.only(left: 20, right: 20),
          ),
        ],
      ),
    );
  }
}
