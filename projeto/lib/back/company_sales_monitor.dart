import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesMonitor {
  late int numero;
  late double valortotal;
  late DateTime data;
  late String nomepessoa;

  SalesMonitor({
    required this.numero,
    required this.valortotal,
    required this.data,
    required this.nomepessoa,
  });

  factory SalesMonitor.fromJson(Map<String, dynamic> json) {
    return SalesMonitor(
      numero: json['numero'] ?? 0,
      valortotal: (json['valortotal'] ?? 0.0).toDouble(),
      data: DateTime.parse(json['data'] ?? DateTime.now().toString()),
      nomepessoa: json['nomepessoa'] ?? '',
    );
  }
}

class DataServiceSalesMonitor {
  static Future<Map<String?, String?>> fetchDataSalesMonitor(String urlBasic) async {
    String? numero;
    String? valortotal;
    String? data;
    String? nomepessoa;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda');

      var response = await http.get(urlPost, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
          for (var item in jsonData['data']['prevenda']) {
            numero = item['numero']?.toString();
            valortotal = item['valortotal']?.toString();
            data = item['data']?.toString();
            nomepessoa = item['nomepessoa']?.toString();

            print('Número: $numero');
            print('Valor Total: $valortotal');
            print('Data: $data');
            print('Nome Pessoa: $nomepessoa');
          }
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
      'numero': numero,
      'valortotal': valortotal,
      'data': data,
      'nomepessoa': nomepessoa,
    };
  }
}
