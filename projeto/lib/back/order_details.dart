import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class OrdersDetailsEndpoint2 {
  late String produtoId;
  late String pessoanome;
  late String nomeproduto;
  late String imagemurl;
  late String codigoproduto;
  late double valorunitario;
  late double quantidade;
  late double valortotalitem;
  late String cpfcnpj;
  late String telefone;
  // late String endereco;
  // late String uf;
  // late String enderecobairro;
  // late String enderecocomplemento;
  // late String enderecocep;
  late String pessoaid;

  OrdersDetailsEndpoint2({
    required this.produtoId,
    required this.pessoanome,
    required this.nomeproduto,
    required this.imagemurl,
    required this.codigoproduto,
    required this.valorunitario,
    required this.quantidade,
    required this.valortotalitem,
    required this.cpfcnpj,
    required this.telefone,
    // required this.endereco,
    // required this.uf,
    // required this.enderecobairro,
    // required this.enderecocomplemento,
    // required this.enderecocep,
    required this.pessoaid,
  });

  factory OrdersDetailsEndpoint2.fromJson(Map<String, dynamic> json) {
    return OrdersDetailsEndpoint2(
      produtoId: json['produto_id'] ?? '',
      pessoanome: json['pessoa_nome'] ?? '',
      codigoproduto: json['codigo'] ?? '',
      nomeproduto: json['nome'] ?? 0,
      valorunitario: (json['valorunitario'] as num).toDouble(),
      quantidade: json['quanridade'] ?? 0,
      valortotalitem: json['valortotalitem'] ?? 0.0,
      imagemurl: json['imagem_url'] ?? '',
      cpfcnpj: json['cpfcnpj'] ?? 0,
      telefone: json['telefone'] ?? 0,
      pessoaid: json['pessoa_id'] ?? '',
    );
  }
}

class DataServiceOrdersDetails2 {
  static Future<Map<String?, String?>> fetchDataOrdersDetails2(String urlBasic, String prevendaId) async {
    String? produtoId;
    String? pessoaid;
    String? pessoanome;
    String? nomeproduto;
    String? codigoproduto;
    String? imagemurl;
    // double? valorunitario;
    // double? quantidade;
    String? cpfcnpj;
    String? telefone;
    // String? endereco;
    // String? uf;
    // String? enderecocomplemento;
    // String? enderecobairro;
    // String? enderecocep;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pedido/$prevendaId');

      var response = await http.get(
        urlPost, 
        headers: {
          // 'Accept': 'text/html',
          });

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('prevenda') &&
            jsonData['data']['prevenda'].isNotEmpty) {
          
          var prevendaData = jsonData['data']['prevenda'][0];
          var produtoPrevenda = jsonData['data']['prevendaproduto'][0];

          produtoId = produtoPrevenda['produto_id'];
          pessoaid = prevendaData['pessoa_id'];
          pessoanome = prevendaData['pessoa_nome'];
          nomeproduto = produtoPrevenda['nome'];
          imagemurl = produtoPrevenda['imagem_url'];
          codigoproduto = prevendaData['codigo'];
          // valorunitario = double.parse(prevendaData['valorunitario'].toString());
          // quantidade = double.parse(prevendaData['quantidade'].toString());
          cpfcnpj = prevendaData['cpfcnpj'];
          telefone = prevendaData['telefone'];

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
      'pessoa_id' : pessoaid,
      'pessoa_nome' : pessoanome,
      'nome' : nomeproduto,
      'codigo' : codigoproduto,
      'imagem_url' : imagemurl,
      // 'valorunitario' : valorunitario.toString(),
      // 'quantidade' : quantidade.toString(),
      'cpfcnpj' : cpfcnpj,
      'telefone' : telefone,
    };
  }
}

