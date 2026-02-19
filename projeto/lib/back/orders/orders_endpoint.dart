import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/saveList.dart';
import 'package:projeto/front/components/style.dart';
import 'package:uuid/uuid.dart';

class OrdersEndpoint {
  late String usuarioId;
  late String vendedorId;
  late String empresaId;
  late String prevendaId;
  final dynamic numero;
  late double valortotal;
  late double valordesconto;
  late DateTime datahora;
  late String nomepessoa;
  late String operador;
  late int flagprocessado;
  late int flagpermitefaturar;
  // Offline
  final String? tabelaprecoId;
  String? localId;
  int? flagSync; // 0 = local | 1 = sincronizado
  final String? cpfcnpj;
  final String? telefone;

  OrdersEndpoint({
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
    required this.flagpermitefaturar,
    // Offline
    this.tabelaprecoId,
    this.localId,
    this.flagSync,
    this.cpfcnpj,
    this.telefone,
  });

  factory OrdersEndpoint.fromJson(Map<String, dynamic> json) {
    final uuid = const Uuid().v4();
    return OrdersEndpoint(
      usuarioId: json['usuario_id'] ?? '',
      vendedorId: json['vendedor_pessoa_id'] ?? '',
      empresaId: json['empresa_id'] ?? '',
      prevendaId: json['prevenda_id'] ?? '',
      numero: json['numero'] ?? 0,
      valortotal: (json['valortotal'] as num?)?.toDouble() ?? 0.0,
      valordesconto: (json['valordesconto'] as num?)?.toDouble() ?? 0.0,
      datahora: DateTime.parse(json['datahora'] ?? '1899-12-30T00:00:00'),
      nomepessoa: json['nomepessoa'] ?? '',
      operador: json['nome'] ?? '',
      flagprocessado: json['flagprocessado'] ?? 0,
      flagpermitefaturar: json['flagPermiteFaturar'] ?? 0,
      // Offline
      tabelaprecoId: json['tabelapreco_id'] ?? '',
      localId: json['local_id'],
      flagSync: json['flag_sync'] ?? 1,
      cpfcnpj: json['cpfcnpj'] ?? '',
      telefone: json['telefone'] ?? '',
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
      'flagpermitefaturar': flagpermitefaturar,
      // Offline
      'tabelapreco_id': tabelaprecoId,
      'local_id': localId,
      'flag_sync': flagSync,
      'cpfcnpj': cpfcnpj,
      'telefone': telefone,
    };
  }

  /// 🔹 Faz com que o print mostre os dados legíveis
  @override
  String toString() => toJson().toString();
}

class DataServiceOrders {
//   static Future<List<OrdersEndpoint>?> fetchDataOrders(
//     BuildContext context,
//     String urlBasic,
//     String usuario_id,
//     String token,
//     {bool? ascending}) async {

//   try {
//     final pedidosLocais = await recuperarListaPedido();

//     var rawQuery =
//         '''prevenda%20p%20LEFT%20JOIN%20usuario%20u%20ON%20u.usuario_id%20=%20p.usuario_id%20WHERE%20p.usuario_id%20=%20'$usuario_id'AND%20COALESCE(p.flagcancelado,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagexcluido,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagprocessado,%200)%20%3C%3E%201/''';

//     var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

//     var response = await http.get(urlPost, headers: {
//       'Accept': 'text/html'
//     });

//     if (response.statusCode != 200) {
//       return pedidosLocais; // 🔥 Se falhar, mantém local
//     }

//     var jsonData = json.decode(response.body);
//     var dynamicKey = jsonData['data'].keys.first;

//     List<OrdersEndpoint> pedidosOnline =
//         (jsonData['data'][dynamicKey] as List)
//             .map((e) => OrdersEndpoint.fromJson(e))
//             .toList();

//     /// 🔥 MAPA FINAL (baseado no local)
//     final Map<String, OrdersEndpoint> mapaFinal = {};

//     /// 1️⃣ Primeiro adiciona TODOS os pedidos locais
//     for (var local in pedidosLocais) {
//       if (local.localId != null) {
//         mapaFinal[local.localId!] = local;
//       }
//     }

//     /// 2️⃣ Agora processa os online
//     for (var online in pedidosOnline) {

//       // tenta encontrar correspondente local pelo prevendaId
//       final matchLocal = pedidosLocais.where(
//         (local) =>
//             local.prevendaId.isNotEmpty &&
//             local.prevendaId == online.prevendaId,
//       ).toList();

//       if (matchLocal.isNotEmpty) {
//         final local = matchLocal.first;

//         // 🔥 PRESERVA DADOS LOCAIS IMPORTANTES
//         online.localId = local.localId;
//         online.flagSync = 1;
//       } else {
//         // pedido 100% online
//         online.localId ??= const Uuid().v4();
//         online.flagSync = 1;
//       }

//       mapaFinal[online.localId!] = online;
//     }

//     /// 🔥 Converte para lista
//     final listaFinal = mapaFinal.values.toList();

//     /// 🔥 Salva local atualizado
//     await salvarListaPedido(
//       listaFinal.map((e) => e.toJson()).toList(),
//     );

//     /// 🔥 Filtro de data
//     DateTime daysAgo = DateTime.now().subtract(const Duration(days: 7));
//     listaFinal.removeWhere((o) => o.datahora.isBefore(daysAgo));

//     listaFinal.sort((a, b) => b.datahora.compareTo(a.datahora));

//     return listaFinal;

//   } catch (e) {
//     print('Erro durante fetchDataOrders: $e');
//     return await recuperarListaPedido(); // 🔥 fallback seguro
//   }
// }

  static Future<List<OrdersEndpoint>?> fetchDataOrders(
      BuildContext context, String urlBasic, String usuario_id, String token,
      {bool? ascending}) async {
    List<OrdersEndpoint>? orders;

    print('token: $token');

    try {
      var rawQuery =
          '''prevenda%20p%20LEFT%20JOIN%20usuario%20u%20ON%20u.usuario_id%20=%20p.usuario_id%20WHERE%20p.usuario_id%20=%20'$usuario_id'AND%20COALESCE(p.flagcancelado,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagexcluido,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagprocessado,%200)%20%3C%3E%201%20AND%20p.`data`%20>=%20DATE_SUB(CURDATE(),%20INTERVAL%207%20DAY)/''';
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

        orders = (jsonData['data'][dynamicKey] as List)
            .map((e) => OrdersEndpoint.fromJson(e))
            .toList();

        print(orders.last);

        final pedidosLocais = await recuperarListaPedido();

        print(pedidosLocais);

        for (var online in orders) {
          final localMatchList = pedidosLocais
              .where(
                (local) =>
                    local.prevendaId.isNotEmpty &&
                    local.prevendaId == online.prevendaId,
              )
              .toList();

          if (localMatchList.isNotEmpty) {
            final localMatch = localMatchList.first;
            online.localId = localMatch.localId;
            online.flagSync = localMatch.flagSync;
          }
        }

        // DateTime daysAgo = DateTime.now().subtract(const Duration(days: 7));
        // orders =
        //     orders.where((order) => order.datahora.isAfter(daysAgo)).toList();

        orders.sort((a, b) => b.datahora.compareTo(a.datahora));
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
  late String nomeexpedicao;
  //late String imagemurl;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late double valortotalitem;
  // Offline
  final String? local_id;
  final int? flagSync; // 0 = local | 1 = sincronizado
  final String? ean;
  final String? expedicao_id;

  OrdersDetailsEndpoint(
      {required this.prevendaprodutoid,
      required this.produtoid,
      required this.nomeproduto,
      required this.nomeexpedicao,
      //required this.imagemurl,
      required this.codigoproduto,
      required this.valorunitario,
      required this.quantidade,
      required this.valortotalitem,
      // Offline
      this.local_id,
      this.flagSync,
      this.ean,
      this.expedicao_id});

  factory OrdersDetailsEndpoint.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OrdersDetailsEndpoint(
      produtoid: json['produto_id'] ?? '',
      prevendaprodutoid: json['prevendaproduto_id'] ?? '',
      codigoproduto: json['codigoproduto'] ?? '',
      nomeproduto: json['nomeproduto'] ?? '',
      nomeexpedicao: json['nome'] ?? '',
      valorunitario: _toDouble(json['valorunitario']),
      quantidade: _toDouble(json['quantidade']),
      valortotalitem: _toDouble(json['valortotal']),
      // Offilne
      local_id: json['local_id'] ?? '',
      flagSync: json['flag_sync'] ?? 1,
      ean: json['ean'] ?? '',
      expedicao_id: json['expedicao_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto_id': produtoid,
      'prevendaproduto_id': prevendaprodutoid,
      'codigoproduto': codigoproduto,
      'nomeproduto': nomeproduto,
      'nome': nomeexpedicao,
      'valorunitario': valorunitario,
      'quantidade': quantidade,
      'valortotal': valortotalitem,
      // Offline
      'local_id': local_id,
      'flag_sync': flagSync,
      'ean': ean,
      'expedicao_id': expedicao_id,
    };
  }
}

class DataServiceOrdersDetails {
  static Future<List<OrdersDetailsEndpoint>?> fetchDataOrdersDetails(
      String urlBasic, String prevendaid, String token) async {
    List<OrdersDetailsEndpoint>? ordersDetails;

    try {
      var urlGetExped = Uri.parse(
          '''$urlBasic/ideia/core/getdata/prevendaproduto%20pp%20LEFT%20JOIN%20expedicao%20e%20ON%20pp.expedicao_id%20=%20e.expedicao_id%20LEFT%20JOIN%20prevenda%20p%20ON%20p.prevenda_id%20=%20pp.prevenda_id%20WHERE%20p.prevenda_id%20=%20'${prevendaid}'/''');
      var responseExped =
          await http.get(urlGetExped, headers: {"Accept": "text/html"});
      if (responseExped.statusCode == 200) {
        var jsonDataExped = json.decode(responseExped.body);
        var dataMap = jsonDataExped['data'] as Map<String, dynamic>;
        var dynamicKey = jsonDataExped['data'].keys.first;
        // var rawQuery = jsonDataExped['data'][dynamicKey];
        print(dynamicKey);
        var dataList = dataMap[dynamicKey] as List;
        //print(jsonDataExped['data'][rawQuery]);
        ordersDetails =
            dataList.map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();
      } else {
        print('Erro: ${responseExped.statusCode} - ${responseExped.body}');
      }
    } catch (e) {
      print('Erro na requisição OrdersEndpoint: $e');
    }
    return ordersDetails;
  }
}
