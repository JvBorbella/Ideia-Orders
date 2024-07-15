import 'dart:convert';
import 'package:http/http.dart' as http;

class OrdersEndpoint {
  late String usuarioId;
  late String prevendaId;
  late int numero;
  late double valorsubtotal;
  late double valortotal;
  late DateTime data;
  late DateTime datahora;
  late String nomepessoa;
  late String entrega_enderecocidade;
  late int flagprocessado;
  late int flagcancelado;

  OrdersEndpoint({
    required this.usuarioId,
    required this.prevendaId,
    required this.numero,
    required this.valorsubtotal,
    required this.valortotal,
    required this.data,
    required this.datahora,
    required this.nomepessoa,
    required this.entrega_enderecocidade,
    required this.flagprocessado,
    required this.flagcancelado,
  });

  factory OrdersEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersEndpoint(
      usuarioId: json['usuario_id'] ?? '',
      prevendaId: json['prevenda_id'] ?? '',
      numero: json['numero'] ?? 0,
      valorsubtotal: (json['valorsubtotal'] as num).toDouble(),
      valortotal: (json['valortotal'] as num).toDouble(),
      data: DateTime.parse(json['data']),
      datahora: DateTime.parse(json['datahora']),
      nomepessoa: json['nomepessoa'] ?? '',
      entrega_enderecocidade: json['entrega_enderecocidade'] ?? '',
      flagprocessado: json['flagprocessado'] ?? 0,
      flagcancelado: json['flagcancelado'] ?? 0,
    );
  }
}

class DataServiceOrders {
  static Future<List<OrdersEndpoint>?> fetchDataOrders(String urlBasic, String id) async {
    List<OrdersEndpoint>? orders;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda');
      var response = await http.get(urlPost, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda')) {
          orders = (jsonData['data']['prevenda'] as List)
              .map((e) => OrdersEndpoint.fromJson(e))
              .toList();

              orders = orders.where((order) =>
              order.usuarioId == id).toList();

          // Filtra os pedidos com flagprocessado e flagcancelado igual a 0
          orders = orders.where((order) =>
              order.flagprocessado == 0 && order.flagcancelado == 0).toList();

          // Filtra os pedidos dos últimos 3 dias
          DateTime threeDaysAgo = DateTime.now().subtract(Duration(days: 7));
          orders = orders.where((order) =>
              order.data.isAfter(threeDaysAgo)).toList();
        } else {
          print('Dados não encontrados - orders');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição Orders: $e');
    }
    return orders;
  }
}


class OrdersDetailsEndpoint {
  late String produtoId;
  late String nome;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late String cpfcnpj;
  late String telefonecontato;
  late String endereco;
  late String uf;
  late String enderecobairro;
  late String enderecocep;

  OrdersDetailsEndpoint({
    required this.produtoId,
    required this.nome,
    required this.codigoproduto,
    required this.valorunitario,
    required this.quantidade,
    required this.cpfcnpj,
    required this.telefonecontato,
    required this.endereco,
    required this.uf,
    required this.enderecobairro,
    required this.enderecocep,
  });

  factory OrdersDetailsEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersDetailsEndpoint(
      produtoId: json['produto_id'] ?? '',
      nome: json['nome'] ?? '',
      codigoproduto: json['codigoproduto'] ?? '',
      valorunitario: (json['valorunitario'] as num).toDouble(),
      quantidade: (json['quantidade'] as num).toDouble(),
      cpfcnpj: json['cpfcnpj'] ?? '',
      telefonecontato: json['telefonecontato'] ?? '',
      endereco: json['endereco'] ?? '',
      uf: json['uf'] ?? '',
      enderecobairro: json['enderecobairro'] ?? '',
      enderecocep: json['enderecocep'] ?? '',
    );
  }
}

class DataServiceOrdersDetails {
  static Future<List<OrdersDetailsEndpoint>?> fetchDataOrdersDetails(String urlBasic, String prevendaId) async {

    List<OrdersDetailsEndpoint>? ordersDetails;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda/$prevendaId');
      print('Url da prevenda com id: $urlPost');

      var response = await http.get(urlPost, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
            ordersDetails = (jsonData['data']['prevenda'] as List).map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();

            // print('Pedidos: '+response.body);
        } else {
          print('Dados não encontrados - ordersDetails');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição OrdersDetails: $e');
    }

    return ordersDetails;
  }
}