import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class AlterTableEndpoint {
  String? flagpermitiralterartabela;

  AlterTableEndpoint({
    required this.flagpermitiralterartabela,
  });

  factory AlterTableEndpoint.fromJson(Map<String, dynamic> json) {
    return AlterTableEndpoint(
      flagpermitiralterartabela: (json['flagpermitiralterartabela'] ?? '').toString(),
    );
  }
}

class DataServiceAlterTableEndpoint {
  static Future<Map<String, String>?> fetchDataAlterTableEndpoint(
      BuildContext context, String urlBasic, String empresaid) async {
    String? flagpermitiralterartabela;

    try {
      var rawQuery = '''empresa%20e%20WHERE%20e.empresa_id=%20'$empresaid'/''';
      var endpointQuery = "empresa e WHERE e.empresa_id = '$empresaid'/";
      var urlPost = Uri.parse('$urlBasic/ideia/core/getdata/$rawQuery');

      print(urlPost);

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
            print('Chave dinâmica encontrada: $dynamicKey');

            var AlterTableEndpointList = dataMap[dynamicKey] as List;
            if (AlterTableEndpointList.isNotEmpty) {
              var AlterTableEndpoint = AlterTableEndpointList.first;
              flagpermitiralterartabela = AlterTableEndpoint['flagpermitiralterartabela']?.toString();
              print('flagpermitiralterartabela: $flagpermitiralterartabela');
            } else {
              print('Nenhum item encontrado na lista.');
            }
          } else {
            print('Mapa de dados está vazio.');
          }
        } else {
          print('Chave "data" não encontrada no JSON - AlterTableEndpoint');
        }
      } else {
        print('Falha na requisição. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição Alter Table: $e');
    }
    return {'flagpermitiralterartabela': flagpermitiralterartabela ?? ''};
  }
}
