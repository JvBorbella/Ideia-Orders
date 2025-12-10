import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarListaPedido(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('minha_lista', listaJson);
}

Future<void> salvarListaProdutos(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('listaProduto', listaJson);
}

Future<void> adicionarItemProduto(Map<String, dynamic> novoItem) async {
  final prefs = await SharedPreferences.getInstance();

  // 1. Pega a lista atual (se não existir, cria uma vazia)
  String? listaJson = prefs.getString('listaProduto');

  List<dynamic> listaDecodificada = [];
  if (listaJson != null) {
    listaDecodificada = jsonDecode(listaJson);
  }

  // 2. Adiciona o novo item
  listaDecodificada.add(novoItem);

  // 3. Salva tudo novamente
  await prefs.setString('listaProduto', jsonEncode(listaDecodificada));
  print(listaDecodificada);
}

Future<void> limparLista() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('minha_lista');
}

Future<void> salvarListaCliente(List<Map<String, dynamic>> lista) async {
  final prefs = await SharedPreferences.getInstance();

  String listaJson = jsonEncode(lista);

  await prefs.setString('minha_lista', listaJson);
}

Future<List<Map<String, dynamic>>> recuperarListaPedido() async {
  final prefs = await SharedPreferences.getInstance();

  String? listaJson = prefs.getString('minha_lista');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Future<List<Map<String, dynamic>>> recuperarListaProduto() async {
  final prefs = await SharedPreferences.getInstance();

  String? listaJson = prefs.getString('listaProduto');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Future<List<Map<String, dynamic>>> recuperarListaCliente() async {
  final prefs = await SharedPreferences.getInstance();

  String? listaJson = prefs.getString('minha_lista');

  if (listaJson == null) return [];

  List<dynamic> listaDecodificada = jsonDecode(listaJson);

  return listaDecodificada
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
