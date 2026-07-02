import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/pages/home.dart';

class CancelButton extends StatefulWidget {
  const CancelButton({super.key});

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
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          height: Responsive.h(context, 40),
          child: Container(
            //Tamanho e espaçamento interno do modal
            height: Responsive.h(context, 300),
            margin: EdgeInsets.only(
                left: Responsive.h(context, 12),
                right: Responsive.h(context, 12)),
            padding: EdgeInsets.all(Responsive.h(context, 12)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Responsive.r(context, 10))),
            child: Column(
              //Conteúdo interno do modal
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Responsive.w(context, 250),
                      child: Text(
                        'Deseja cancelar este pedido?',
                        style: TextStyle(
                          fontSize: Responsive.h(context, 15),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Responsive.h(context, 30),
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
                        width: Responsive.w(context, 100),
                        // height: Style.ButtonExitHeight(context),
                        padding: EdgeInsets.all(Responsive.h(context, 8)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Responsive.r(context, 10)),
                            color: Theme.of(context).colorScheme.primary),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: ColorsApp.tertiaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.h(context, 10),
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
                        padding: EdgeInsets.all(Responsive.h(context, 8)),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Responsive.r(context, 10)),
                          border: Border.all(
                              width: 2,
                              color: Theme.of(context).colorScheme.onSecondary),
                          color: ColorsApp.tertiaryColor,
                        ),
                        child: Text(
                          'Desistir',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: Responsive.h(context, 10),
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
          builder: (context) => const Home(),
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
          color: ColorsApp.errorColor,
          width: Responsive.h(context, 150),
          icon: Icons.cancel),
    );
  }
}
