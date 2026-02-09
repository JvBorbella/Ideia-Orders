// import 'package:flutter/cupertino.dart';
// import 'package:projeto/back/offline/order_model.dart';
// import 'package:projeto/back/orders/new_order.dart';

// class OrderRepository {

//   Future<bool> enviarPedidoParaServidor(
//     BuildContext context,
//     OrderModel order,
//     String urlBasic,
//     String token,
//   ) async {
//     try {
//       final response = await DataServiceNewOrder.sendDataOrder(
//         context,
//         urlBasic,
//         token,
//         order.nomepessoa,
//         '',
//         order.nomepessoa,
//         '',
//         '',
//         order.empresaId ?? '',
//       );

//       return response != null;
//     } catch (e) {
//       return false;
//     }
//   }
// }
