import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class CompanyList {
  String? empresaCodigo;
  String? empresaNome;
  String? empresaId;
  String? tabelaprecoId;
  String? estoqueId;
  int? flagpermitealterartabela;
  int? flagobrigarvendedor;
  int? flagobrigarcliente;
  int? flagobrigarexpedicao;

  CompanyList({
    required this.empresaCodigo,
    required this.empresaNome,
    required this.empresaId,
    required this.tabelaprecoId,
    required this.estoqueId,
    required this.flagpermitealterartabela,
    required this.flagobrigarvendedor,
    required this.flagobrigarcliente,
    required this.flagobrigarexpedicao,
  });

  factory CompanyList.fromJson(Map<String, dynamic> json) {
    return CompanyList(
      empresaCodigo: (json['empresa_codigo'] ?? '').toString(),
      empresaNome: (json['empresa_nome'] ?? '').toString(),
      empresaId: (json['empresa_id'] ?? '').toString(),
      tabelaprecoId: (json['tabelapreco_id'] ?? '').toString(),
      estoqueId: (json['estoque_id'] ?? '').toString(),
      flagpermitealterartabela: (json['flagpermitealterartabela'] ?? 0) as int?,
      flagobrigarvendedor: (json['flagobrigarvendedor'] ?? 0) as int?,
      flagobrigarcliente: (json['flagobrigarcliente'] ?? 0) as int?,
      flagobrigarexpedicao: (json['flagobrigarexpedicao'] ?? 0) as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empresa_id': empresaId,
      'empresa_nome': empresaNome,
      'empresa_codigo': empresaCodigo,
      'tabelapreco_id': tabelaprecoId,
      'estoque_id': estoqueId,
      'flagpermitealterartabela': flagpermitealterartabela,
      'flagobrigarvendedor': flagobrigarvendedor,
      'flagobrigarcliente': flagobrigarcliente,
      'flagobrigarexpedicao': flagobrigarexpedicao,
    };
  }
}

class DataServiceCompany {
  static Future<List<CompanyList>?> fetchDataCompany(
    BuildContext context,
    String urlBasic,
    String empresaId,
  ) async {
    List<CompanyList>? companys;

    try {
      var urlPost =
          Uri.parse('$urlBasic/ideia/core/getdata/empresa/$empresaId');

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') && jsonData['data'] is Map) {
          // Busca a primeira chave dentro de 'data', pois ela é dinâmica
          var dynamicKey = jsonData['data'].keys.first;

          // Verifica se o valor associado à chave é uma lista
          var dataList = jsonData['data'][dynamicKey];
          if (dataList != null && dataList is List) {
            companys = dataList.map((e) => CompanyList.fromJson(e)).toList();

          } else {
            log('A chave dinâmica não contém uma lista válida.');
          }
        } else {
          log('Dados ausentes no JSON. Ocorrências');
        }
      }
    } catch (e) {
      log('Erro durante a requisição Ocorrencia: $e');
    }
    return companys;
  }
}
