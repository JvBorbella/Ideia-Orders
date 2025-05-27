import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class CompanyList {
  String? empresa_codigo;
  String? empresa_nome;
  String? empresa_id;

  CompanyList({
    required this.empresa_codigo,
    required this.empresa_nome,
    required this.empresa_id,
  });

  factory CompanyList.fromJson(Map<String, dynamic> json) {
    return CompanyList(
      empresa_codigo: (json['empresa_codigo'] ?? '').toString(),
      empresa_nome: (json['empresa_nome'] ?? '').toString(),
      empresa_id: (json['empresa_id'] ?? '').toString(),
    );
  }
}

class DataServiceCompany {
  static Future<List<CompanyList>?> fetchDataCompany(
    BuildContext context,
    String urlBasic,
    String empresa_id,
  ) async {
    List<CompanyList>? companys;

    try {
      var urlPost =
          Uri.parse('$urlBasic/ideia/core/getdata/empresa/$empresa_id');

      print(urlPost);

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        print('Status consulta empresa ${response.statusCode}');

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;
          print('Chave dinâmica encontrada: $dynamicKey');

          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            companys = dataList.map((e) => CompanyList.fromJson(e)).toList();

            print('A chave dinâmica contém uma lista válida.');
          } else {
            print('A chave dinâmica não contém uma lista válida.');
          }
        } else {
          print('Dados ausentes no JSON. Ocorrências');
        }
      }
    } catch (e) {
      print('Erro durante a requisição Ocorrencia: $e');
    }
    return companys;
  }
}
