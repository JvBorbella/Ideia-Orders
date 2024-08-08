import 'dart:convert';
import 'package:http/http.dart' as http;

class NewOrder {
  late String nome;
  late String cpf;
  late String telefone;

  NewOrder({
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'telefone': telefone,
      'nomepessoa': nome,
    };
  }

  factory NewOrder.fromJson(Map<String, dynamic> json) {
    return NewOrder(
      cpf: json['cpf'],
      telefone: json['telefone'],
      nome: json['nomepessoa'],
    );
  }
}

class DataServiceNewOrder {
  static Future<void> sendDataOrder(
      String urlBasic,
      String token,
      String cpfController,
      String telefonecontatoController,
      String nomeController,) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novopedido');

      var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    var body = jsonEncode({
      'cpf': cpfController,
      'nome': nomeController,
      'telefone': telefonecontatoController,
    });

    print(headers);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        print('Resposta do servidor: ${response.body}');
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
        print('Resposta do servidor: ${response.body}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }
}
