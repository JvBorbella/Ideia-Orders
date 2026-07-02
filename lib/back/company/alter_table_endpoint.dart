import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Código onde serão acessados os dados de vendas do dia.

class AlterTableEndpoint {
  int? flagpermitiralterartabela;

  AlterTableEndpoint({
    required this.flagpermitiralterartabela,
  });

  factory AlterTableEndpoint.fromJson(Map<String, dynamic> json) {
    return AlterTableEndpoint(
      flagpermitiralterartabela:
          (json['flagpermitiralterartabela'] ?? 0) as int,
    );
  }
}

class DataServiceAlterTableEndpoint {
  static Future<Map<String, dynamic>?> fetchDataAlterTableEndpoint(
      BuildContext context, String urlBasic, String empresaid) async {
    int? flagpermitiralterartabela;

    try {
      var rawQuery = '''empresa%20e%20WHERE%20e.empresa_id=%20'$empresaid'/''';
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      var response = await http.get(
        urlPost,
        headers: {
          'Accept': 'text/html',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data')) {
          // Obter a primeira chave dentro de 'data'
          var dataMap = jsonData['data'] as Map<String, dynamic>;
          if (dataMap.isNotEmpty) {
            var dynamicKey = dataMap.keys.first; // Obter a chave dinâmica

            var alterTableEndpointList = dataMap[dynamicKey] as List;
            if (alterTableEndpointList.isNotEmpty) {
              final prefs = await SharedPreferences.getInstance();
              var alterTableEndpoint = alterTableEndpointList.first;
              flagpermitiralterartabela = alterTableEndpoint['flagpermitiralterartabela'];

              prefs.setInt('flagpermitiralterartabela', flagpermitiralterartabela ?? 0);
            } else {
              log('Nenhum item encontrado na lista.');
            }
          } else {
            log('Mapa de dados está vazio.');
          }
        } else {
          log('Chave "data" não encontrada no JSON - AlterTableEndpoint');
        }
      } else {
        log('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição Alter Table: $e');
    }
    return {'flagpermitiralterartabela': flagpermitiralterartabela ?? 0};
  }
}
