// import 'package:flutter/material.dart';
// import 'package:projeto/front/components/style.dart';

// class ModalNewOrder extends StatefulWidget {
//   const ModalNewOrder({super.key});

//   @override
//   State<ModalNewOrder> createState() => _ModalNewOrderState();
// }

// class _ModalNewOrderState extends State<ModalNewOrder> {
//   late BuildContext modalContext;

//   void _openModal(BuildContext context) {
//     //Código para abrir modal
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         modalContext = context;
//         return Container(
//          child: Column(
//           children: [
//             Text('teste')
//           ],
//          ),
//         );
//       },
//     );
//   }

//   void _closeModal() {
//     //Função para fechar o modal
//     Navigator.of(modalContext).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//     );
//   }
// }