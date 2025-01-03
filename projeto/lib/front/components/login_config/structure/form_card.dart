import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';

class FormCard extends StatefulWidget {
  //Variável para permitir que sejam inseridos outros elementos dentro do card.
  final List<Widget> children;

  const FormCard({
    super.key,
    required this.children,
  });

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
          Image.asset(
                "assets/images/image_card/image_card.png",
                color: Style.primaryColor,
                height: 75,
              ),
              //Área do container com os widgets de form.
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: widget.children,
            ),
          ),
        ],
      ),
    );
  }
}
