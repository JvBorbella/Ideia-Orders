import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';

class OrdersEndpoint {
  late String usuarioId;
  late String pessoaId;
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
  late int flagobrigarvendedor;
  late int flagobrigarcliente;
  late int flagobrigarexpedicao;
  // Offline
  final String? tabelaprecoId;
  final String? tabelaprecoNome;
  final String? empresaCodigo;
  final String? empresaNome;
  String? localId;
  int? flagSync; // 0 = local | 1 = sincronizado
  final String? cpfcnpj;
  final String? telefone;

  OrdersEndpoint({
    required this.usuarioId,
    required this.pessoaId,
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
    required this.flagobrigarvendedor,
    required this.flagobrigarcliente,
    required this.flagobrigarexpedicao,
    // Offline
    this.tabelaprecoId,
    this.tabelaprecoNome,
    this.empresaCodigo,
    this.empresaNome,
    this.localId,
    this.flagSync,
    this.cpfcnpj,
    this.telefone,
  });

  factory OrdersEndpoint.fromJson(Map<String, dynamic> json) {
    return OrdersEndpoint(
      usuarioId: json['usuario_id'] ?? '',
      vendedorId: json['vendedor_pessoa_id'] ?? '',
      pessoaId: json['pessoa_id'] ?? '',
      empresaId: json['empresa_id'] ?? '',
      prevendaId: json['prevenda_id'] ?? '',
      numero: json['numero'] ?? 0,
      valortotal: (json['valortotal'] as num?)?.toDouble() ?? 0.0,
      valordesconto: (json['valordesconto'] as num?)?.toDouble() ?? 0.0,
      datahora: DateTime.parse(json['datahora'] ?? '1899-12-30T00:00:00'),
      nomepessoa: json['nomepessoa'] ?? '',
      operador: json['nome'] ?? '',
      flagprocessado: json['flagprocessado'] ?? 0,
      flagpermitefaturar: json['flagpermitefaturar'] ?? 0,
      flagobrigarvendedor: json['flagobrigarvendedor'] ?? 0,
      flagobrigarcliente: json['flagobrigarcliente'] ?? 0,
      flagobrigarexpedicao: json['flagobrigarexpedicao'] ?? 0,
      // Offline
      tabelaprecoId: json['tabelapreco_id'] ?? '',
      tabelaprecoNome: json['nome_2'] ?? '',
      empresaCodigo: json['empresa_codigo'] ?? '',
      empresaNome: json['empresa_nome'] ?? '',
      localId: json['local_id'] ?? '',
      flagSync: json['flag_sync'] ?? 1,
      cpfcnpj: json['cpf'] ?? '',
      telefone: json['telefone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'pessoa_id': pessoaId,
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
      'flagobrigarvendedor': flagobrigarvendedor,
      'flagobrigarcliente': flagobrigarcliente,
      'flagobrigarexpedicao': flagobrigarexpedicao,
      // Offline
      'tabelapreco_id': tabelaprecoId,
      'nome_2': tabelaprecoNome,
      'empresa_codigo': empresaCodigo,
      'empresa_nome': empresaNome,
      'local_id': localId,
      'flag_sync': flagSync,
      'cpf': cpfcnpj,
      'telefone': telefone,
    };
  }

  /// 🔹 Faz com que o print mostre os dados legíveis
  @override
  String toString() => toJson().toString();
}

class DataServiceOrders {
  static Future<List<OrdersEndpoint>?> fetchDataOrders(
      BuildContext context, String urlBasic, String usuarioId, String token,
      {bool? ascending}) async {
    List<OrdersEndpoint>? orders;

    try {
      var rawQuery =
          '''prevenda%20p%20LEFT%20JOIN%20usuario%20u%20ON%20u.usuario_id%20=%20p.usuario_id%20LEFT%20JOIN%20empresa%20e%20ON%20e.empresa_id%20=%20p.empresa_id%20LEFT%20JOIN%20tabelapreco%20t%20ON%20t.tabelapreco_id%20=%20p.tabelapreco_id%20%20WHERE%20p.usuario_id%20=%20'$usuarioId'AND%20COALESCE(p.flagcancelado,%200)%20%3C%3E%201%20AND%20COALESCE(p.flagexcluido,%200)%20%3C%3E%201%20AND%20p.`data`%20>=%20DATE_SUB(CURDATE(),%20INTERVAL%207%20DAY)/''';
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      var response = await http.get(urlPost, headers: {
        // 'auth-token': token,
        'Accept': 'text/html'
      });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        var dynamicKey = jsonData['data'].keys.first;

        orders = (jsonData['data'][dynamicKey] as List)
            .map((e) => OrdersEndpoint.fromJson(e))
            .toList();

        final pedidosLocais = await recuperarListaPedido();

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
            // online.localId = localMatch.localId;
            online.flagSync = localMatch.flagSync;
          }
        }

        orders.sort((a, b) => b.datahora.compareTo(a.datahora));
      } else {
        Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
            'Erro ao carregar dados: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Message.showReturnOverlay(
      //     context, ColorsApp.errorColor, Icons.error, '$e');
    }
    return orders;
  }
}

class OrdersDetailsEndpoint {
  late String prevendaprodutoid;
  late String produtoid;
  late String imagem;
  late String nomeproduto;
  late String nomeexpedicao;
  //late String imagemurl;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late double valortotalitem;
  late double valortotalprevenda;
  late double estoqueinicial;
  late int flagunidadefracionada;
  late int flagservico;
  // Offline
  final String? localId;
  final int? flagSync; // 0 = local | 1 = sincronizado
  final String? ean;
  final String? expedicaoId;

  OrdersDetailsEndpoint(
      {required this.prevendaprodutoid,
      required this.produtoid,
      required this.imagem,
      required this.nomeproduto,
      required this.nomeexpedicao,
      //required this.imagemurl,
      required this.codigoproduto,
      required this.valorunitario,
      required this.quantidade,
      required this.valortotalitem,
      required this.valortotalprevenda,
      required this.estoqueinicial,
      required this.flagunidadefracionada,
      required this.flagservico,
      // Offline
      this.localId,
      this.flagSync,
      this.ean,
      this.expedicaoId});

  factory OrdersDetailsEndpoint.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return OrdersDetailsEndpoint(
      produtoid: json['produto_id'] ?? '',
      imagem: json['imagem_id'] ?? '',
      prevendaprodutoid: json['prevendaproduto_id'] ?? '',
      codigoproduto: json['codigoproduto'] ?? '',
      nomeproduto: json['nomeproduto'] ?? '',
      nomeexpedicao: json['nome'] ?? '',
      valorunitario: toDouble(json['valorunitario']),
      quantidade: toDouble(json['quantidade']),
      valortotalitem: toDouble(json['valortotal']),
      valortotalprevenda: toDouble(json['valortotalprevenda']),
      estoqueinicial: toDouble(json['estoqueinicial']),
      flagunidadefracionada: json['flagunidadefracionada'] ?? 0,
      flagservico: json['flagservico'] ?? 0,
      // Offilne
      localId: json['local_id'] ?? '',
      flagSync: json['flag_sync'] ?? 1,
      ean: json['ean'] ?? '',
      expedicaoId: json['expedicao_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produto_id': produtoid,
      'imagem_id': imagem,
      'prevendaproduto_id': prevendaprodutoid,
      'codigoproduto': codigoproduto,
      'nomeproduto': nomeproduto,
      'nome': nomeexpedicao,
      'valorunitario': valorunitario,
      'quantidade': quantidade,
      'valortotal': valortotalitem,
      'valortotalprevenda': valortotalprevenda,
      'estoqueinicial': estoqueinicial,
      'flagunidadefracionada': flagunidadefracionada,
      'flagservico': flagservico,
      // Offline
      'local_id': localId,
      'flag_sync': flagSync,
      'ean': ean,
      'expedicao_id': expedicaoId,
    };
  }
}

class DataServiceOrdersDetails {
  static Future<List<OrdersDetailsEndpoint>?> fetchDataOrdersDetails(
      BuildContext context,
      String urlBasic,
      String prevendaid,
      String empresaId,
      String token) async {
    List<OrdersDetailsEndpoint>? ordersDetails;

    try {
      var urlGetExped = Uri.parse(
          '''$urlBasic/ideia/core/getdata/(SELECT%20pp.prevendaproduto_id,%20pp.produto_id,%20pr.imagem_id,%20pp.codigoproduto,%20pp.nomeproduto,%20e.nome,%20pp.valorunitario,%20pp.quantidade,%20pp.valortotal,%20pe.quantidade%20AS%20estoqueinicial,%20p.local_id,%20un.flagunidadefracionada,%20p.flagservico,%20p.valortotal%20AS%20valortotalprevenda,%20e.expedicao_id%20FROM%20prevendaproduto%20pp%20LEFT%20JOIN%20empresa%20ep%20ON%20ep.empresa_id%20=%20'$empresaId'%20LEFT%20JOIN%20produtoestoque%20pe%20ON%20pe.produto_id%20=%20pp.produto_id%20AND%20pe.empresa_id%20=%20'$empresaId'%20AND%20pe.estoque_id%20=%20ep.estoque_id%20%20LEFT%20JOIN%20expedicao%20e%20ON%20pp.expedicao_id%20=%20e.expedicao_id%20LEFT%20JOIN%20prevenda%20p%20ON%20p.prevenda_id%20=%20pp.prevenda_id%20LEFT%20JOIN%20produto%20pr%20ON%20pr.produto_id%20=%20pp.produto_id%20LEFT%20JOIN%20unidademedida%20un%20ON%20pr.unidademedida_id%20=%20un.unidademedida_id%20WHERE%20p.prevenda_id%20=%20'$prevendaid')%20AS%20p/''');
      var responseExped =
          await http.get(urlGetExped, headers: {'Accept': 'text/html'});
      if (responseExped.statusCode == 200) {
        var jsonDataExped = json.decode(responseExped.body);
        var dynamicKey = jsonDataExped['data'].keys.first;
        ordersDetails = (jsonDataExped['data'][dynamicKey] as List)
            .map((e) => OrdersDetailsEndpoint.fromJson(e))
            .toList();
        await atualizarProdutosPedido(
            prevendaId: prevendaid,
            novos: ordersDetails.map((e) => e.toJson()).toList());
      } else {
        Message.showReturnOverlay(
          context,
          ColorsApp.errorColor,
          Icons.error_outline,
          'Erro ao carregar detalhes do pedido: ${responseExped.statusCode} - ${responseExped.body}',
        );
        log('Erro: ${responseExped.statusCode} - ${responseExped.body}');
      }
    } catch (e) {
      log('Erro na requisição OrdersEndpoint: $e');
    }
    return ordersDetails;
  }
}
