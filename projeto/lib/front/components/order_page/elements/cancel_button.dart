import 'package:flutter/material.dart';
import 'package:projeto/front/components/Style.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/pages/home.dart';

class CancelButton extends StatefulWidget {
  const CancelButton({Key? key}) : super(key: key);

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  late BuildContext modalContext;

  void _openModal(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        modalContext = context;
        return Container(
          //Configurações de tamanho e espaçamento do modal
          height: Style.ModalSize(context),
          child: Container(
            //Tamanho e espaçamento interno do modal
            height: Style.InternalModalSize(context),
            margin: EdgeInsets.only(
                left: Style.ModalMargin(context),
                right: Style.ModalMargin(context)),
            padding: EdgeInsets.all(Style.InternalModalPadding(context)),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(Style.ModalBorderRadius(context))),
            child: Column(
              //Conteúdo interno do modal
              children: [
                Row(
                  children: [
                    Container(
                      width: Style.width_250(context),
                      child: Text(
                      'Deseja cancelar este pedido?',
                      style: TextStyle(
                        fontSize: Style.height_15(context),
                        color: Style.primaryColor,
                      ),
                      overflow: TextOverflow.clip,
                      softWrap: true,
                    ),
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
                        _cancelar();
                      },
                      child: Container(
                        width: Style.ButtonExitWidth(context),
                        // height: Style.ButtonExitHeight(context),
                        padding:
                            EdgeInsets.all(Style.ButtonExitPadding(context)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Style.ButtonExitBorderRadius(context)),
                            color: Style.primaryColor),
                        child: Text(
                          'Cancelar',
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
                        padding:
                            EdgeInsets.all(Style.ButtonCancelPadding(context)),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              Style.ButtonExitBorderRadius(context)),
                          border: Border.all(
                              width: Style.WidthBorderImageContainer(context),
                              color: Style.secondaryColor),
                          color: Style.tertiaryColor,
                        ),
                        child: Text(
                          'Desistir',
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
        );
      },
    );
  }

  void _closeModal() {
    //Função para fechar o modal
    Navigator.of(modalContext).pop();
  }

  void _cancelar() {
   Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RegisterIconButton(
          onPressed: () {
            _openModal(context);
          },
          text: 'Cancelar Pedido',
          color: Style.errorColor,
          width: Style.height_150(context),
          icon: Icons.cancel),
    );
  }
}
