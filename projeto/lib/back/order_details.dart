import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class OrdersDetailsEndpoint2 {
  late String produtoId;
  late String nome;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late String cpfcnpj;
  late String telefonecontato;
  late String endereco;
  late String uf;
  late String enderecobairro;
  late String enderecocomplemento;
  late String enderecocep;

  OrdersDetailsEndpoint2({
    required this.produtoId,
    required this.nome,
    required this.codigoproduto,
    required this.valorunitario,
    required this.quantidade,
    required this.cpfcnpj,
    required this.telefonecontato,
    required this.endereco,
    required this.uf,
    required this.enderecobairro,
    required this.enderecocomplemento,
    required this.enderecocep,
  });

  factory OrdersDetailsEndpoint2.fromJson(Map<String, dynamic> json) {
    return OrdersDetailsEndpoint2(
      produtoId: json['produto_id'] ?? '',
      nome: json['nome'] ?? '',
      codigoproduto: json['valorsubtotal'] ?? 0,
      valorunitario: (json['valorunitario'] as num).toDouble(),
      quantidade: json['quanridade'] ?? 0,
      cpfcnpj: json['cpfcnpj'] ?? 0,
      telefonecontato: json['telefonecontato'] ?? 0,
      endereco: json['endereco'] ?? '',
      uf: json['uf'] ?? '',
      enderecocomplemento: json['enderecocomplemento'] ?? '',
      enderecobairro: json['enderecobairro'] ?? '',
      enderecocep: json['enderecocep'] ?? '',
    );
  }
}

class DataServiceOrdersDetails2 {
  static Future<Map<String?, String?>> fetchDataOrdersDetails2(String urlBasic, String prevendaId) async {
    String? produtoId;
    String? nome;
    String? codigoproduto;
    // double? valorunitario;
    // double? quantidade;
    String? cpfcnpj;
    String? telefonecontato;
    String? endereco;
    String? uf;
    String? enderecocomplemento;
    String? enderecobairro;
    String? enderecocep;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/core/prevenda/$prevendaId');

      var response = await http.get(
        urlPost, 
        headers: {
          'Accept': 'text/html',
          });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
          
          var prevendaData = jsonData['data']['prevenda'][0];

          produtoId = prevendaData['produto_id'];
          nome = prevendaData['nome'];
          codigoproduto = prevendaData['codigoproduto'];
          // valorunitario = double.parse(prevendaData['valorunitario'].toString());
          // quantidade = double.parse(prevendaData['quantidade'].toString());
          cpfcnpj = prevendaData['cpfcnpj'];
          telefonecontato = prevendaData['telefonecontato'];
          endereco = prevendaData['endereco'];
          uf = prevendaData['uf'];
          enderecocomplemento = prevendaData['enderecocomplemento'];
          enderecobairro = prevendaData['enderecobairro'];
          enderecocep = prevendaData['enderecocep'];

        } else {
          print('Dados não encontrados');
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }

    return {
      'produto_id' : produtoId,
      'nome' : nome,
      'codigoproduto' : codigoproduto,
      // 'valorunitario' : valorunitario.toString(),
      // 'quantidade' : quantidade.toString(),
      'cpfcnpj' : cpfcnpj,
      'telefonecontato' : telefonecontato,
      'endereco' : endereco,
      'uf' : uf,
      'enderecocomplemento' : enderecocomplemento,
      'enderecobairro' : enderecobairro,
      'enderecocep' : enderecocep,
    };
  }
}

