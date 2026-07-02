import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';

// Data/Horário último save

Future<void> salvarDataSave(String data) async {
  var box = Hive.box('app_data');
  await box.put('data_save', data);
}

// Empresa

Future<void> salvarListaEmpresa(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  // O Hive aceita listas e mapas diretamente, sem necessidade de jsonEncode
  await box.put('companys', lista);
}

Future<List<CompanyList>> recuperarListaEmpresa() async {
  var box = Hive.box('app_data');
  final List? data = box.get('companys');

  if (data == null) return [];

  // Como o Hive recupera como List<dynamic>, convertemos cada item para Map<String, dynamic>
  return data
      .map((e) => CompanyList.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

//______________________________________________________________________________

// Tabela de Preços

Future<void> salvarListaTabPreco(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  await box.put('table_prices', lista);
}

Future<List<ListTablePrices>> recuperarListaTabPreco() async {
  try {
    var box = Hive.box('app_data');
    final List? data = box.get('table_prices');

    if (data == null) return [];
    return data
        .map((e) => ListTablePrices.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } catch (e) {
    log('Erro ao recuperar tabela offline: $e');
    return [];
  }
}

//______________________________________________________________________________

// Lista de expedições

Future<void> salvarListaExpedicao(List<dynamic> lista) async {
  var box = Hive.box('app_data');
  await box.put('expedition', lista);
}

Future<List<Map<String, dynamic>>> recuperarListaExpedicao() async {
  var box = Hive.box('app_data');
  final List? data = box.get('expedition');

  if (data == null) return [];

  return data.map((item) => Map<String, dynamic>.from(item)).toList();
}

//______________________________________________________________________________

// Salvar Lista de Pedidos

Future<void> salvarListaPedido(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  await box.put('orders', lista);
}

Future<List<OrdersEndpoint>> recuperarListaPedido() async {
  var box = Hive.box('app_data');
  final List? data = box.get('orders');

  if (data == null) return [];

  return data
      .map((e) => OrdersEndpoint.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

Future<void> adicionarPedido(Map<String, dynamic> novoItem) async {
  var box = Hive.box('app_data');
  final dynamic data = box.get('orders', defaultValue: []);

  // Garante tipos em runtime para evitar _TypeError:
  // Map<dynamic, dynamic> is not a subtype of Map<String, dynamic>
  final List<Map<String, dynamic>> lista = (data as List)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  // 2. Adiciona o novo item (também normaliza)
  lista.add(Map<String, dynamic>.from(novoItem));

  // 3. Salva tudo novamente
  await box.put('orders', lista);
}

Future<List<OrdersEndpoint>> removerPedido(String localId) async {
  var box = Hive.box('app_data');
  List data = box.get('orders', defaultValue: []);
  final List<Map<String, dynamic>> lista = (data)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  lista.removeWhere(
    (item) => item['local_id'] == localId || item['prevenda_id'] == localId,
  );

  await box.put('orders', lista);

  return lista.map((e) => OrdersEndpoint.fromJson(e)).toList();
}

Future<void> atualizarValorPedido(String localId, double valortotal) async {
  var box = Hive.box('app_data');
  final dynamic data = box.get('orders', defaultValue: []);

  if (data != null) {
    final List<Map<String, dynamic>> lista = (data as List)
        .map<Map<String, dynamic>>(
            (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
        .toList();

    for (var order in lista) {
      if (order['local_id'] == localId) {
        order['valortotal'] += valortotal;
        await box.put('orders', lista);
        break;
      }
    }
  }
}

// Future<void> adicionarPedidoFinalizado(String localId) async {
//   var box = Hive.box('app_data');

//   // 1. Busca o mapa bruto do pedido na lista de 'orders' (mais seguro que converter para objeto)
//   final dynamic ordersRaw = box.get('orders', defaultValue: []);
//   if (ordersRaw == null) return;
//   final orderMap = ordersRaw.lastWhere(
//     (o) => o['local_id'] == localId,
//   );

//   if (orderMap == null) return;

//   // 2. Recupera a lista de finalizados e normaliza os tipos para evitar _TypeError
//   final List finalizedRaw = box.get('orders_finalized', defaultValue: []);
//   final List<Map<String, dynamic>> finalizedList =
//       finalizedRaw.map((e) => Map<String, dynamic>.from(e as Map)).toList();

//   // 3. Adiciona se não existir (evita duplicidade)
//   if (!finalizedList.any((o) => o['local_id'] == localId)) {
//     finalizedList.add(Map<String, dynamic>.from(orderMap as Map));
//     await box.put('orders_finalized', finalizedList);
//     //await removerPedido(localId);
//   }
// }

// Future<void> removerPedidoFinalizado(String localId) async {
//   var box = Hive.box('app_data');
//   final List? data = box.get('orders_finalized');
//   if (data == null) return;

//   List<Map<String, dynamic>> lista =
//       data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
//   lista.removeWhere(
//       (item) => item['local_id'] == localId || item['prevenda_id'] == localId);
//   await box.put('orders_finalized', lista);
// }

// Future<List<Map<String, dynamic>>> recuperarPedidoFinalizado() async {
//   var box = Hive.box('app_data');
//   final List? data = box.get('orders_finalized');
//   if (data == null) return [];
//   return data.map((e) => Map<String, dynamic>.from(e)).toList();
// }

// Future<void> limparPedidoFinalizado() async {
//   var box = Hive.box('app_data');
//   await box.delete('orders_finalized');
// }

//______________________________________________________________________________

// Salvar lista de Produtos

Future<void> salvarListaProdutos(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  await box.put('products', lista);
}
//______________________________________________________________________________

// Salvar lista de Produtos adicionados ao pedido

Future<void> salvarListaProdutosPedido(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  await box.put('products_order', lista);
}

Future<void> atualizarProdutosPedido({
  required String prevendaId,
  required List<Map<String, dynamic>> novos,
}) async {
  final box = Hive.box('app_data');

  final data = box.get('products_order', defaultValue: []);
  final List<Map<String, dynamic>> atuais = (data as List)
      .map((e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  // mantém tudo que NÃO é dessa prevenda
  final outrosPrevendas = atuais
      .where((item) => (item['prevenda_id'] ?? '') != prevendaId)
      .toList();

  // (opcional) evita duplicar prevenda dentro de "novos"
  final novosMap = {
    for (final item in novos)
      // use a chave que identifica o item na sua tela/db:
      // aqui estou usando prevendaproduto_id (uuid), que você já usa como id do item
      (item['prevendaproduto_id'] ?? ''): item,
  };

  // junta: outros + substituição da prevenda
  final resultado = [
    ...outrosPrevendas,
    ...novosMap.values,
  ];


  await box.put('products_order', resultado);
}

Future<void> adicionarItemProduto(Map<String, dynamic> novoItem) async {
  var box = Hive.box('app_data');
  final dynamic data = box.get('products_order', defaultValue: []);

  // Garante tipos em runtime para evitar _TypeError:
  // Map<dynamic, dynamic> is not a subtype of Map<String, dynamic>
  final List<Map<String, dynamic>> lista = (data as List)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  // 2. Adiciona o novo item (também normaliza)
  lista.add(Map<String, dynamic>.from(novoItem));

  // 3. Salva tudo novamente
  await box.put('products_order', lista);
}

Future<List<OrdersDetailsEndpoint>> recuperarListaProdutosPedido(
    String localId) async {
  var box = Hive.box('app_data');
  final List? data = box.get('products_order');

  if (data == null) return [];

  final List filtered = data
      .where((e) => e['local_id'] == localId || e['prevenda_id'] == localId)
      .toList();

  return filtered
      .map((e) => OrdersDetailsEndpoint.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

Future<void> limparListaProdutosPedido(String localId) async {
  var box = Hive.box('app_data');
  List? data = box.get('products_order');

  if (data != null) {
    List<Map<String, dynamic>> lista = List<Map<String, dynamic>>.from(data);
    lista.removeWhere((item) =>
        item['local_id'] == localId || item['prevenda_id'] == localId);
    await box.put('products_order', lista);
  }
}

Future<void> atualizarItem(
  String prevendaProdutoId,
  String localId,
  String qnt,
  String expedicaoId,
  String expedicao,
) async {
  final box = Hive.box('app_data');

  final data = box.get('products_order');
  if (data == null) return;

  // Normaliza tipos do Hive (Hive pode retornar Map<dynamic, dynamic>)
  final List<Map<String, dynamic>> lista = (data as List)
      .map<Map<String, dynamic>>(
        (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>),
      )
      .toList();

  final int index = lista.indexWhere(
    (element) =>
        element['prevendaproduto_id'] == prevendaProdutoId &&
        (element['local_id'] == localId),
  );

  if (index == -1) return;

  lista[index]['flag_sync'] = 0;
  lista[index]['quantidade'] = qnt;
  lista[index]['expedicao_id'] = expedicaoId;
  lista[index]['nome'] = expedicao;
  lista[index]['valortotal'] =
      double.parse(qnt) * lista[index]['valorunitario'];
  ;

  await box.put('products_order', lista);
}

Future<void> atualizarStatusItem(
  String prevendaProdutoId,
  String localId,
) async {
  final box = Hive.box('app_data');

  final data = box.get('products_order');
  if (data == null) return;

  final List<Map<String, dynamic>> lista =
      List<Map<String, dynamic>>.from(data);

  final int index = lista.indexWhere(
    (element) =>
        element['prevendaproduto_id'] == prevendaProdutoId &&
        (element['local_id'] == localId),
  );

  if (index == -1) return; // item não encontrado

  lista[index]['flag_sync'] = 1; // ✅ atualiza no index

  await box.put('products_order', lista); // ✅ salva novamente
}

Future<List<OrdersDetailsEndpoint>> removerItemProduto(
    String prevendaProdutoId, String localId) async {
  var box = Hive.box('app_data');
  List? data = box.get('products_order');

  if (data == null) return [];
  final List<Map<String, dynamic>> listaCompleta = (data)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  listaCompleta.removeWhere((item) =>
      item['prevendaproduto_id'] == prevendaProdutoId &&
      (item['local_id'] == localId || item['prevenda_id'] == localId));

  await box.put('products_order', listaCompleta);

  return listaCompleta
      .where((e) => e['local_id'] == localId)
      .map((e) => OrdersDetailsEndpoint.fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

Future<void> adicionarProdutoParaRemocao(
    String localId, String prevendaprodutoId) async {
  var box = Hive.box('app_data');
  List data = box.get('products_order_delete', defaultValue: []);
  final List<Map<String, dynamic>> lista = (data)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  lista.add({
    'local_id': localId,
    'prevendaproduto_id': prevendaprodutoId,
    'flagexcluido': 1
  });
  await box.put('products_order_delete', lista);
}

Future<List<Map<String, dynamic>>> recuperarProdutosParaRemocao(
    String localId) async {
  var box = Hive.box('app_data');
  final List? data = box.get('products_order_delete');
  if (data == null) return [];
  return data
      .where((e) => e['local_id'] == localId)
      .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
      .toList();
}

Future<void> limparProdutosParaRemocao(String localId) async {
  var box = Hive.box('app_data');
  List? data = box.get('products_order_delete');
  if (data == null) return;
  List<Map<String, dynamic>> lista = List<Map<String, dynamic>>.from(data);
  lista.removeWhere((item) => item['local_id'] == localId);
  await box.put('products_order_delete', lista);
}

//______________________________________________________________________________

//Salvar dados do Cliente

Future<void> salvarDadosCliente(List<Map<String, dynamic>> lista) async {
  var box = Hive.box('app_data');
  await box.put('dados_cliente', lista);
}

Future<void> adicionarDadosCliente(
    Map<String, dynamic> novoItem, BuildContext context) async {
  var box = Hive.box('app_data');
  List data = box.get('dados_cliente', defaultValue: []);
  final List<Map<String, dynamic>> lista = (data)
      .map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map<dynamic, dynamic>))
      .toList();

  final index = lista.indexWhere(
    (item) => item['local_id'] == novoItem['local_id'],
  );

  if (index != -1) {
    // 🔁 Substitui o registro existente
    lista[index] = novoItem;
  } else {
    // ➕ Adiciona novo registro
    lista.add(novoItem);
  }

  // 3. Salva novamente
  await box.put('dados_cliente', lista);

  Message.showReturnOverlay(context, ColorsApp.warningColor, Icons.error,
      'Pedido salvo localmente devido à falta de conexão com a internet.');
}

Future<void> atualizarStatusCliente(
  String localId,
) async {
  final box = Hive.box('app_data');

  final data = box.get('dados_cliente');
  if (data == null) return;

  final List<Map<String, dynamic>> lista =
      List<Map<String, dynamic>>.from(data);

  final int index = lista.indexWhere(
    (element) => element['local_id'] == localId,
  );

  if (index == -1) return; // item não encontrado

  lista[index]['flag_sync'] = 1; // ✅ atualiza no index

  await box.put('dados_cliente', lista); // ✅ salva novamente
}

Future<List<Map<String, dynamic>>> recuperarDadosCliente() async {
  var box = Hive.box('app_data');
  final List? data = box.get('dados_cliente');
  if (data == null) return [];
  return data.map((item) => Map<String, dynamic>.from(item)).toList();
}

Future<List<Map<String, dynamic>>> recuperarClientePorLocalId(
    String localId) async {
  final List<Map<String, dynamic>> lista = await recuperarDadosCliente();
  return lista.where((item) => item['local_id'] == localId).toList();
}

//______________________________________________________________________________

Future<List<Map<String, dynamic>>> recuperarListaCliente() async {
  var box = Hive.box('app_data');
  final List? data = box.get('minha_lista');
  if (data == null) return [];
  return data.map((item) => Map<String, dynamic>.from(item)).toList();
}

//______________________________________________________________________________

List<Map<String, dynamic>> mergeListsByKey(
  List<Map<String, dynamic>> primary,
  List<Map<String, dynamic>> secondary,
  List<Map<String, dynamic>> tertiary,
  String key,
) {
  final Map<String, Map<String, dynamic>> map = {};

  // 🔹 Primeiro adiciona tertiary
  for (final item in tertiary) {
    final dynamicKey = item[key];

    if (dynamicKey != null) {
      map[dynamicKey.toString()] = item;
    }
  }

  // 🔹 Primeiro adiciona secondary
  for (final item in secondary) {
    final dynamicKey = item[key];

    if (dynamicKey != null) {
      map[dynamicKey.toString()] = item;
    }
  }

  // 🔹 Depois primary (tem prioridade)
  for (final item in primary) {
    final dynamicKey = item[key];

    if (dynamicKey != null) {
      map[dynamicKey.toString()] = item;
    }
  }

  return map.values.toList();
}

Future<void> limparLista(String lista) async {
  var box = Hive.box('app_data');
  await box.delete(lista);
}
