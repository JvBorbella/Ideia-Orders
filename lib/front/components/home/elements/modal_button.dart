import 'package:flutter/material.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:projeto/front/pages/login.dart';

class ModalExit {
  static void modalExit(BuildContext context) {
    //Código para abrir modal
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          //Configurações de tamanho e espaçamento do modal
          //height: Responsive.h(context, 300),
          child: PopScope(
            canPop: false,
            // onPopInvokedWithResult: (didPop, result) =>
            //     Navigator.of(context).pop(),
            child: Container(
              //Tamanho e espaçamento interno do modal
              height: Responsive.h(context, 200),
              margin: EdgeInsets.only(
                  left: Responsive.h(context, 12),
                  right: Responsive.h(context, 12)),
              padding: EdgeInsets.all(Responsive.h(context, 12)),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Responsive.r(context, 10))),
              child: Column(
                //Conteúdo interno do modal
                children: [
                  Row(
                    children: [
                      Text(
                        'Deseja sair da aplicação?',
                        style: TextStyle(
                          fontSize: Responsive.h(context, 15),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.clip,
                        softWrap: true,
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
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Responsive.w(context, 80),
                          height: Responsive.h(context, 40),
                          padding: EdgeInsets.all(Responsive.h(context, 8)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Responsive.r(context, 10)),
                              color: ColorsApp.errorColor),
                          child: Text(
                            'Sair',
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
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: Responsive.w(context, 80),
                          height: Responsive.h(context, 40),
                          padding: EdgeInsets.all(Responsive.h(context, 8)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Responsive.r(context, 10)),
                            border: Border.all(
                                width: 2,
                                color:
                                    Theme.of(context).colorScheme.onSecondary),
                            // color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Text(
                            'Cancelar',
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
          ),
        );
      },
    );
  }
}

// class ModalButton extends StatefulWidget {
//   const ModalButton({super.key});

//   @override
//   State<ModalButton> createState() => _ModalButtonState();
// }

// class _ModalButtonState extends State<ModalButton> {
//   late BuildContext modalContext;

//   void openModal(BuildContext context) {
//     _openModal(context);
//   }

//   void _openModal(BuildContext context) {
//     //Código para abrir modal
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         modalContext = context;
//         return SizedBox(
//           //Configurações de tamanho e espaçamento do modal
//           //height: Responsive.h(context, 300),
//           child: PopScope(
//             canPop: false,
//             onPopInvokedWithResult: (didPop, result) => _closeModal(),
//             child: Container(
//               //Tamanho e espaçamento interno do modal
//               height: Responsive.h(context, 200),
//               margin: EdgeInsets.only(
//                   left: Responsive.h(context, 12),
//                   right: Responsive.h(context, 12)),
//               padding: EdgeInsets.all(Responsive.h(context, 12)),
//               decoration: BoxDecoration(
//                   borderRadius:
//                       BorderRadius.circular(Responsive.r(context, 10))),
//               child: Column(
//                 //Conteúdo interno do modal
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         'Deseja sair da aplicação?',
//                         style: TextStyle(
//                           fontSize: Responsive.h(context, 15),
//                           color: Theme.of(context).colorScheme.primary,
//                         ),
//                         overflow: TextOverflow.clip,
//                         softWrap: true,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: Responsive.h(context, 30),
//                   ),
//                   Row(
//                     //Espaçamento entre os Buttons
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       //Buttom de sair
//                       TextButton(
//                         onPressed: () async {
//                           _sair();
//                         },
//                         child: Container(
//                           width: Responsive.w(context, 80),
//                           // height: Style.ButtonExitHeight(context),
//                           padding: EdgeInsets.all(Responsive.h(context, 8)),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(
//                                   Responsive.r(context, 10)),
//                               color: ColorsApp.errorColor),
//                           child: Text(
//                             'Sair',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.surface,
//                               fontWeight: FontWeight.bold,
//                               fontSize: Responsive.h(context, 10),
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       //Buttom para fechar o modal
//                       TextButton(
//                         onPressed: () {
//                           _closeModal();
//                         },
//                         child: Container(
//                           width: Responsive.w(context, 80),
//                           padding: EdgeInsets.all(Responsive.h(context, 8)),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(
//                                 Responsive.r(context, 10)),
//                             border: Border.all(
//                                 width: 2,
//                                 color:
//                                     Theme.of(context).colorScheme.onSecondary),
//                             // color: Theme.of(context).colorScheme.surface,
//                           ),
//                           child: Text(
//                             'Cancelar',
//                             style: TextStyle(
//                               color: Theme.of(context).colorScheme.onSecondary,
//                               fontWeight: FontWeight.bold,
//                               fontSize: Responsive.h(context, 10),
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _closeModal() {
//     //Função para fechar o modal
//     Navigator.of(modalContext).pop();
//   }

//   void _sair() {
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => const LoginPage(),
//         ),
//         (route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: Container(
//         //Área externa do button que abre o modal
//         color: Theme.of(context).colorScheme.primary,
//         // padding: EdgeInsets.only(left: 10, top: 5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               //Função para abrir o modal
//               onTap: () {
//                 _openModal(context);
//               },
//               child: ButtonTheme(
//                   //Estilização do Buttom
//                   child: Row(
//                 children: [
//                   Text(
//                     'Sair',
//                     style: TextStyle(
//                         color: ColorsApp.tertiaryColor,
//                         fontSize: Responsive.h(context, 10)),
//                   ),
//                   Icon(
//                     Icons.exit_to_app,
//                     color: ColorsApp.tertiaryColor,
//                     size: Responsive.h(context, 20),
//                   ),
//                 ],
//               )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
