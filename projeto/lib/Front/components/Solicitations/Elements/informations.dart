import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class Informations extends StatefulWidget {
  final url;
  final token;
  final String usuarioLogin;
  final String empresaNome;
  final String imagem;
  final String urlBasic;

  const Informations({
    Key? key,
    this.token,
    this.url = '',
    required this.usuarioLogin,
    required this.empresaNome,
    required this.imagem,
    this.urlBasic = '',
  });

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //Código dos elementos que ficam dentro do card na tela de solicitações
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    child: ClipOval(
                      child: widget.imagem.isNotEmpty
                          ? Image.network(
                              widget.urlBasic + widget.imagem,
                              fit: BoxFit.cover,
                            ) // Exibe a imagem
                          : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/4519/4519678.png',
                              width: 70,
                              height: 70,
                              color: Style.primaryColor,
                              fit: BoxFit.cover,
                            ),
                    ),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border:
                            Border.all(width: 2, color: Style.primaryColor)),
                  ),
                ],
              ),
              SizedBox(
                width: 10, // Espaçamento entre a imagem e os outros elementos
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4, // largura desejada
                    child: Text(
                      widget.usuarioLogin,
                      style: TextStyle(
                        color: Style.primaryColor,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow
                          .clip, // corta o texto no limite da largura
                      softWrap:
                          true, // permite a quebra de linha conforme necessário
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4, // largura desejada
                    child: Text(
                      widget.empresaNome,
                      style: TextStyle(
                        color: Style.primaryColor,
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip, // corta o texto no limite da largura
                      softWrap: true, // permite a quebra de linha conforme necessário
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
