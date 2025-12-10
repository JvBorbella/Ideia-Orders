// import 'dart:convert';
// import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';

// class ProductsOrder {
//   late String nome;

//   ProductsOrder({
//     required this.nome,
//   });

//   factory ProductsOrder.fromJson(Map<String, dynamic> json) {
//     return ProductsOrder(
//       nome: json['nome'] ?? '',
//     );
//   }
// }

// class DataServiceProductsOrder {
//   static Future<Map<String?, String?>> fetchDataProductsOrder(String urlBasic, String produtoId) async {
//     String? nome;

//     try {
//       var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda/$produtoId');
//       print('Url da prevenda com id: $urlPost');

//       var response = await http.get(
//         urlPost, 
//         headers: {
//           'Accept': 'text/html',
//           });

//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);

//         if (jsonData.containsKey('data') &&
//             jsonData['data'].containsKey('prevenda') &&
//             jsonData['data']['prevenda'].isNotEmpty) {
          
//           var prevendaData = jsonData['data']['prevenda'][0];

//           nome = prevendaData['nome'];

//         } else {
//           print('Dados não encontrados');
//         }
//       } else {
//         print('Erro ao carregar dados: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Erro durante a requisição: $e');
//     }

//     return {
//       'nome' : nome,
//     };
//   }
// }

