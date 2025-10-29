import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';

class OrdersEndpoint {
  late String usuarioId;
  late String vendedorId;
  late String empresaId;
  late String prevendaId;
  late int numero;
  late double valortotal;
  late double valordesconto;
  late DateTime datahora;
  late String nomepessoa;
  late String operador;
  late int flagprocessado;
  late int flagpermitefaturar;

  OrdersEndpoint(
      {
      required this.usuarioId,
      required this.vendedorId,
      required this.empresaId,
      required this.prevendaId,
      required this.numero,
      required this.valortotal,
      required this.valordesconto,
      required this.datahora,
      required this.nomepessoa,
      required this.operador,
      required this.flagprocessado,
      required this.flagpermitefaturar});

  factory OrdersEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersEndpoint(
      usuarioId: json['usuario_id'] ?? '',
      vendedorId: json['vendedor_pessoa_id'] ?? '',
      empresaId: json['empresa_id'] ?? '',
      prevendaId: json['prevenda_id'] ?? '',
      numero: json['numero'] ?? 0,
      valortotal: (json['valortotal'] as num).toDouble(),
      valordesconto: (json['valordesconto'] as num).toDouble(),
      datahora: DateTime.parse(json['datahora']),
      nomepessoa: json['nomepessoa'] ?? '',
      operador: json['nome'] ?? '',
      flagprocessado: json['flagprocessado'] ?? 0,
      flagpermitefaturar: json['flagPermiteFaturar'] ?? 0,
    );
  }

Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'vendedor_pessoa_id': vendedorId,
      'empresa_id': empresaId,
      'prevenda_id': prevendaId,
      'numero': numero,
      'valortotal': valortotal,
      'valordesconto': valordesconto,
      'datahora': datahora.toIso8601String(),
      'nomepessoa': nomepessoa,
      'operador': operador,
      'flagprocessado': flagprocessado,
      'flagpermitefaturar': flagpermitefaturar.toString(),
    };
  }

  /// 🔹 Faz com que o print mostre os dados legíveis
  @override
  String toString() => toJson().toString();
}

class DataServiceOrders {
  static Future<List<OrdersEndpoint>?> fetchDataOrders(
      BuildContext context, String urlBasic, String usuario_id, String token,
      {bool? ascending}) async {
    List<OrdersEndpoint>? orders;

    print('token: $token');

    try {
      var rawQuery =
          '''prevenda%20p%20LEFT%20JOIN%20usuario%20u%20ON%20u.usuario_id%20=%20p.usuario_id%20WHERE%20p.usuario_id%20=%20'$usuario_id'AND%20COALESCE(p.flagcancelado,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagexcluido,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagprocessado,%200)%20%3C%3E%201/''';
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');
      print(urlPost);
      var response = await http.get(urlPost, headers: {
        // 'auth-token': token,
        'Accept': 'text/html'
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        // if (jsonData.containsKey('data') &&
        //     jsonData['data'].containsKey('prevenda')) {
        //   orders = (jsonData['data']['prevenda'] as List)
        //       .map((e) => OrdersEndpoint.fromJson(e))
        //       .toList();

        //   orders =
        //       orders.where((order) => order.usuarioId == usuario_id).toList();

        //   orders = orders
        //       .where((order) =>
        //           order.flagprocessado == '0' || order.flagprocessado.isEmpty)
        //       .toList();

        //   DateTime threeDaysAgo =
        //       DateTime.now().subtract(const Duration(days: 7));
        //   orders = orders
        //       .where((order) => order.datahora.isAfter(threeDaysAgo))
        //       .toList();

        //   orders.sort((a, b) => b.datahora.compareTo(a.datahora));
        // } else {
        //   print('Dados não encontrados - orders');
        // }
        var dynamicKey = jsonData['data'].keys.first;
        print('Chave dinâmica encontrada: $dynamicKey');

        // Verifica se o valor associado à chave é uma lista
        var dataList = jsonData['data'][dynamicKey];
        // var data = dataList;

        orders =
            (jsonData['data'][dynamicKey] as List).map((e) => OrdersEndpoint.fromJson(e)).toList();

        DateTime daysAgo = DateTime.now().subtract(const Duration(days: 7));
        orders =
            orders.where((order) => order.datahora.isAfter(daysAgo)).toList();

        orders.sort((a, b) => b.datahora.compareTo(a.datahora));

        print('OrdersEndpoint: $orders');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Erro ao carregar dados: ${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
        print('Erro ao carregar dados: ${response.statusCode}');
        print('Resposta do servidor: ${response.body}');
      }
    } catch (e) {
      print('Erro durante a requisição Orders: $e');
    }
    return orders;
  }
}

class OrdersDetailsEndpoint {
  late String prevendaprodutoid;
  late String produtoid;
  late String nomeproduto;
  late String imagemurl;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late double valortotalitem;

  OrdersDetailsEndpoint({
    required this.prevendaprodutoid,
    required this.produtoid,
    required this.nomeproduto,
    required this.imagemurl,
    required this.codigoproduto,
    required this.valorunitario,
    required this.quantidade,
    required this.valortotalitem,
  });

  factory OrdersDetailsEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersDetailsEndpoint(
      produtoid: json['produto_id'] ?? '',
      prevendaprodutoid: json['prevendaproduto_id'] ?? '',
      codigoproduto: json['codigo'] ?? '',
      nomeproduto: json['nome'] ?? '',
      valorunitario: (json['valorunitario'] as num).toDouble(),
      quantidade: (json['quantidade'] as num).toDouble(),
      valortotalitem: (json['valortotalitem'] as num).toDouble(),
      imagemurl: json['imagem_url'] ?? '',
    );
  }
}

class DataServiceOrdersDetails {
  static Future<List<OrdersDetailsEndpoint>?> fetchDataOrdersDetails(
      String urlBasic, String prevendaid, String token) async {
    List<OrdersDetailsEndpoint>? ordersDetails;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pedido/$prevendaid');
      print('Url da prevenda com id OrderDetails: $urlPost');

      var response = await http.get(urlPost, headers: {'auth-token': token});

      print('Token: $token');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevendaproduto') &&
            jsonData['data']['prevendaproduto'].isNotEmpty) {
          ordersDetails = (jsonData['data']['prevendaproduto'] as List)
              .map((e) => OrdersDetailsEndpoint.fromJson(e))
              .toList();

          // print('Pedidos: '+response.body);
        } else {
          print(
              'Dados não encontrados - ordersDetails - ${response.statusCode} ${response.body}');
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
