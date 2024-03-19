import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/login.dart';

class NavbarButton extends StatefulWidget {
  const NavbarButton({Key? key}) : super(key: key);

  @override
  State<NavbarButton> createState() => _NavbarButtonState();
}

class _NavbarButtonState extends State<NavbarButton> {
  late BuildContext modalContext;

  void _openModal(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return Container(
          //Configurações de tamanho e espaçamento do modal
          height: 200,
          width: double.maxFinite,
          padding: EdgeInsets.all(8),
          child: Container(
            //Tamanho e espaçamento interno do modal
            height: 150,
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              //Conteúdo interno do modal
              children: [
                Row(
                  children: [
                    Text(
                      'Deseja sair da aplicação?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Style.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  //Espaçamento entre os Buttons
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Buttom de sair
                    TextButton(
                      onPressed: () async {
                        _sair();
                      },
                      child: Container(
                        width: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Style.primaryColor),
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Style.tertiaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //Buttom para fechar o modal
                    TextButton(
                      onPressed: () {
                        _closeModal();
                      },
                      child: Container(
                        width: 110,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(width: 2, color: Style.secondaryColor),
                          color: Style.tertiaryColor,
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Style.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _closeModal() {
    //Função para fechar o modal
    Navigator.of(modalContext).pop();
  }

  void _sair() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 70,
        width: 70,
        //Área externa do button que abre o modal
        color: Style.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              //Função para abrir o modal
              onTap: () {
                _openModal(context);
              },
              child: ButtonTheme(
                //Estilização do Buttom
                child: Icon(
                  Icons.exit_to_app,
                  color: Style.tertiaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
