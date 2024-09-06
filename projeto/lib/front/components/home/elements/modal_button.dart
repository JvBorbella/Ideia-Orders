import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/pages/login.dart';


class ModalButton extends StatefulWidget {
  const ModalButton({super.key});

  @override
  State<ModalButton> createState() => _ModalButtonState();
}

class _ModalButtonState extends State<ModalButton> {
  late BuildContext modalContext;

  void openModal(BuildContext context) {
    _openModal(context);
  }

  void _openModal(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          height: Style.ModalSize(context),
          child: WillPopScope(
            child: Container(
            //Tamanho e espaçamento interno do modal
            height: Style.InternalModalSize(context),
            margin: EdgeInsets.only(left: Style.ModalMargin(context), right: Style.ModalMargin(context)),
            padding: EdgeInsets.all(Style.InternalModalPadding(context)),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(Style.ModalBorderRadius(context))),
            child: Column(
              //Conteúdo interno do modal
              children: [
                Row(
                  children: [
                    Text(
                      'Deseja sair da aplicação?',
                      style: TextStyle(
                        fontSize: Style.height_15(context),
                        color: Style.primaryColor,
                      ),
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    ),
                  ],
                ),
                SizedBox(
                  height: Style.height_30(context),
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
                        width: Style.ButtonExitWidth(context),
                        // height: Style.ButtonExitHeight(context),
                        padding: EdgeInsets.all(Style.ButtonExitPadding(context)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Style.ButtonExitBorderRadius(context)),
                            color: Style.primaryColor),
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Style.tertiaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Style.height_10(context),
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
                        // width: Style.ButtonCancelWidth(context),
                        // height: Style.ButtonCancelHeight(context),
                        padding: EdgeInsets.all(Style.ButtonCancelPadding(context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Style.ButtonExitBorderRadius(context)),
                          border:
                              Border.all(width: Style.WidthBorderImageContainer(context), color: Style.secondaryColor),
                          color: Style.tertiaryColor,
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: Style.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Style.height_10(context),
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
            onWillPop: () async {
              _closeModal();
              return true;
            }
            ) 
            
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
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        //Área externa do button que abre o modal
        color: Style.primaryColor,
        // padding: EdgeInsets.only(left: 10, top: 5),
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
                  child: Row(
                children: [
                  Text(
                    'Sair',
                    style: TextStyle(
                      color: Style.tertiaryColor, 
                      fontSize: Style.TextModalButtonSize(context)
                      ),
                  ),
                  Icon(
                    Icons.exit_to_app,
                    color: Style.tertiaryColor,
                    size: Style.IconModalButtonSize(context),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
