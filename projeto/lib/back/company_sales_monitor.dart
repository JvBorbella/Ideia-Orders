import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersEndpoint {
  late int numero;
  late double valortotal;
  late DateTime data;
  late String nomepessoa;

  OrdersEndpoint({
    required this.numero,
    required this.valortotal,
    required this.data,
    required this.nomepessoa,
  });

  factory OrdersEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersEndpoint(
      numero: json['numero'] ?? 0,
      valortotal: (json['valortotal'] as num).toDouble(),
      data: DateTime.parse(json['data']),
      nomepessoa: json['nomepessoa'] ?? '',
    );
  }
}

class DataServiceOrders {
  static Future<List<OrdersEndpoint>?> fetchDataOrders(String urlBasic) async {

    List<OrdersEndpoint>? orders;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda');

      var response = await http.get(urlPost, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
            orders = (jsonData['data']['prevenda'] as List).map((e) => OrdersEndpoint.fromJson(e)).toList();

            print('Pedidos: $orders');
        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return orders;
  }
}
