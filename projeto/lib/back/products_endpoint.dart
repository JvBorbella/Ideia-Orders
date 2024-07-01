import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductsEndpoint {
  late String nome;

  ProductsEndpoint({
    required this.nome,
  });

  factory ProductsEndpoint.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint(
      nome: json['nome'] ?? '',
    );
  }
}

class DataServiceProducts {
  static Future<List<ProductsEndpoint>?> fetchDataProducts(String urlBasic, produtoId) async {

    List<ProductsEndpoint>? products;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/produto/$produtoId');

      var response = await http.get(urlPost, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
            products = (jsonData['data']['prevenda'] as List).map((e) => ProductsEndpoint.fromJson(e)).toList();
        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return products;
  }
}

class ProductsEndpoint2 {
  late String nome;

  ProductsEndpoint2({
    required this.nome,
  });

  factory ProductsEndpoint2.fromJson(Map<String, dynamic> json) {
    return ProductsEndpoint2(
      nome: json['nome'] ?? '',
    );
  }
}

class ProductsService2 {
  static Future<Map<String?, String?>> fetchDataProductDetails2(String urlBasic, String produtoId) async {
    String? nome;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/produto/$produtoId');

      var response = await http.get(
        urlPost, 
        headers: {
          'Accept': 'text/html',
          });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('produto') &&
            jsonData['data']['produto'].isNotEmpty) {
          
          var prevendaData = jsonData['data']['produto'][0];

          nome = prevendaData['nome'];

        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return {
      'nome' : nome,
    };
  }
}
