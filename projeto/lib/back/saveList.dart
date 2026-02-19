import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto/back/company/company_list.dart';
import 'package:projeto/back/company/list_table_prices.dart';
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/system/print_complete.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Empresa

Future<void> salvarListaEmpresa(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('companys', listaJson);
}

Future<List<CompanyList>> recuperarListaEmpresa() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('companys');

  if (jsonString == null) return [];

  final List decoded = jsonDecode(jsonString);

  return decoded.map((e) => CompanyList.fromJson(e)).toList();
}

//______________________________________________________________________________

// Tabela de Preços

Future<void> salvarListaTabPreco(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('table_prices', listaJson);

  print(listaJson);
}

Future<List<ListTablePrices>> recuperarListaTabPreco() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('table_prices');

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => ListTablePrices.fromJson(e)).toList();
  } catch (e) {
    print('Erro ao recuperar tabela offline: $e');
    return [];
  }
}

//______________________________________________________________________________

// Lista de expedições

Future<void> salvarListaExpedicao(List<dynamic> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('expedition', listaJson);
}

Future<List<Map<String, dynamic>>> recuperarListaExpedicao() async {
  final prefs = await SharedPreferences.getInstance();
  String? listaJson = prefs.getString('expedition');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

//______________________________________________________________________________

// Salvar Lista de Pedidos

Future<void> salvarListaPedido(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('orders', listaJson);
}

Future<List<OrdersEndpoint>> recuperarListaPedido() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('orders');

  if (jsonString == null) return [];

  final List decoded = jsonDecode(jsonString);

  return decoded.map((e) => OrdersEndpoint.fromJson(e)).toList();
}

Future<void> adicionarPedido(Map<String, dynamic> novoItem) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Pega a lista atual (se não existir, cria uma vazia)
  String? listaJson = prefs.getString('orders');

  List<dynamic> listaDecodificada = [];
  if (listaJson != null) {
    listaDecodificada = jsonDecode(listaJson);
  }

  // 2. Adiciona o novo item
  listaDecodificada.add(novoItem);

  // 3. Salva tudo novamente
  await prefs.setString('orders', jsonEncode(listaDecodificada));
  print(listaDecodificada);
}

Future<List<OrdersEndpoint>> removerPedido(String localId) async {
  final prefs = await SharedPreferences.getInstance();
  final lista = await recuperarListaPedido();

  lista.removeWhere(
    (item) => item.localId == localId,
  );

  await prefs.setString('orders', jsonEncode(lista));

  return lista;
}

//______________________________________________________________________________

// Salvar lista de Produtos

Future<void> salvarListaProdutos(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('products', listaJson);
}
//______________________________________________________________________________

// Salvar lista de Produtos adicionados ao pedido

Future<void> salvarListaProdutosPedido(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('products_order', listaJson);
  print(lista);
}

Future<void> adicionarItemProduto(Map<String, dynamic> novoItem) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Pega a lista atual (se não existir, cria uma vazia)
  String? listaJson = prefs.getString('products_order');

  List<dynamic> listaDecodificada = [];
  if (listaJson != null) {
    listaDecodificada = jsonDecode(listaJson);
  }

  // 2. Adiciona o novo item
  listaDecodificada.add(novoItem);
  print(novoItem);

  // 3. Salva tudo novamente
  await prefs.setString('products_order', jsonEncode(listaDecodificada));
  print(listaDecodificada);
}

Future<List<OrdersDetailsEndpoint>> recuperarListaProdutosPedido() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('products_order');

  if (jsonString == null) return [];

  final List decoded = jsonDecode(jsonString);
  print(decoded);

  return decoded.map((e) => OrdersDetailsEndpoint.fromJson(e)).toList();
}

Future<void> limparLista(String lista) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(lista);
}

Future<List<OrdersDetailsEndpoint>> removerItemProduto(
    String prevendaProdutoId, String localId) async {
  final prefs = await SharedPreferences.getInstance();
  final lista = await recuperarListaProdutosPedido();

  lista.removeWhere(
    (item) => item.prevendaprodutoid == prevendaProdutoId,
  );

  await prefs.setString('products_order', jsonEncode(lista));

  return lista;
}

//______________________________________________________________________________

//Salvar dados do Cliente

Future<void> salvarDadosCliente(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('dados_cliente', listaJson);
}

Future<void> adicionarDadosCliente(Map<String, dynamic> novoItem) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Pega a lista atual (se não existir, cria uma vazia)
  final listaJson = prefs.getString('dados_cliente');

  List<Map<String, dynamic>> lista = [];

  if (listaJson != null) {
    final listaDecodificada = jsonDecode(listaJson) as List;
    lista = listaDecodificada.map((e) => Map<String, dynamic>.from(e)).toList();
  }

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
  await prefs.setString('dados_cliente', jsonEncode(lista));

  print(lista);
}

Future<List<Map<String, dynamic>>> recuperarDadosCliente() async {
  final prefs = await SharedPreferences.getInstance();

  String? listaJson = prefs.getString('dados_cliente');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Future<List<Map<String, dynamic>>> recuperarPorLocalId(String localId) async {
  final lista = await recuperarDadosCliente();

  return lista.where((item) => item['local_id'] == localId).toList();
}

//______________________________________________________________________________

Future<List<Map<String, dynamic>>> recuperarListaCliente() async {
  final prefs = await SharedPreferences.getInstance();

  String? listaJson = prefs.getString('minha_lista');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

//______________________________________________________________________________

List<Map<String, dynamic>> mergeListsByKey(
  List<Map<String, dynamic>> primary,
  List<Map<String, dynamic>> secondary,
  String key,
) {
  final Map<String, Map<String, dynamic>> map = {};

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
