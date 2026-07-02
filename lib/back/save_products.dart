import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedListService {
  final String key;

  SharedListService(this.key);

  /// Recupera a lista atual
  Future<List<Map<String, dynamic>>> getList() async {
    final prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    return (jsonDecode(jsonString) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// Salva a lista completa (sobrescreve)
  Future<void> saveList(List<Map<String, dynamic>> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(list));
  }

  /// Adiciona um novo item à lista
  Future<void> addItem(Map<String, dynamic> newItem) async {
    List<Map<String, dynamic>> list = await getList();
    list.add(newItem);
    await saveList(list);
  }

  /// Atualiza um item pelo campo "id"
  Future<bool> updateItem(dynamic id, Map<String, dynamic> updatedItem) async {
    List<Map<String, dynamic>> list = await getList();

    int index = list.indexWhere((item) => item["id"] == id);
    if (index == -1) return false;

    list[index] = updatedItem;
    await saveList(list);
    return true;
  }

  /// Remove um item pelo "id"
  Future<bool> removeItem(dynamic id) async {
    List<Map<String, dynamic>> list = await getList();

    int index = list.indexWhere((item) => item["id"] == id);
    if (index == -1) return false;

    list.removeAt(index);
    await saveList(list);
    return true;
  }

  /// Remove todos os itens
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
