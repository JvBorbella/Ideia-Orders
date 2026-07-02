// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SearchProduct {
//   late String text;
 

//   SearchProduct({
//     required this.text,
//   });

//   factory SearchProduct.fromJson(Map<String, dynamic> json) {
//     return SearchProduct(
//       produtoid: json['produtoid'] ?? '',
//       nome: json['nome'] ?? '',
//       codigo: json['codigo'] ?? '',
//       codigoean: json['codigoean'] ?? '',
//       unidade: json['unidade'] ?? '',
//       precopromocional: (json['precopromocional'] as num).toDouble(),
//       precotabela: (json['precotabela'] as num).toDouble(),
//     );
//   }
// }

// class DataServiceProducts {
//   static Future<List<SearchProduct>?> fetchDataProducts(String urlBasic, String token) async {

//     List<SearchProduct>? products;

//     try {
//       var urlPost = Uri.parse('$urlBasic/ideia/prevenda/listaprodutos');

//       var response = await http.get(
//       urlPost,
//       //  headers: {
//       //   // 'auth-token': token,
//       //   });
//       );

//       if (response.statusCode == 200) {
//         var jsonData = json.decode(response.body);

//         if (jsonData.containsKey('data') &&
//             jsonData['data'].containsKey('produtos') &&
//             jsonData['data']['produtos'].isNotEmpty) {
//             products = (jsonData['data']['produtos'] as List).map((e) => SearchProduct.fromJson(e)).toList();
//         } else {
//           print('Dados não encontrados');
//         }
//       } else {
//         print('Erro ao carregar dados: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Erro durante a requisição: $e');
//     }

//     return products;
//   }
// }