import 'dart:convert';
import 'package:http/http.dart' as http;

//Código da função para retornar os dados de vendas do dia anterior.

class MonitorVendasEmpresaOntem {
  //Definindo o tipo das variáveis.
  late double valorOntem;
  late double ticketOntem;
  late String empresaNome;

  MonitorVendasEmpresaOntem({
    required this.valorOntem,
    required this.ticketOntem,
    required this.empresaNome,
  });

  factory MonitorVendasEmpresaOntem.fromJson(Map<String, dynamic> json) {
    return MonitorVendasEmpresaOntem(
      //Atribuindo os dados do json a essas variáveis.
      valorOntem: (json['valortotal'] ?? 0).toDouble(),
      ticketOntem: (json['ticket'] ?? 0).toDouble(),
      empresaNome: json['empresa_nome'],
    );
  }
}

//Classe onde será acessado o json e resgatados os dados.
class DataServiceOntem {
  static Future<List<MonitorVendasEmpresaOntem>?> fetchDataOntem(
      String token, String url) async {
    List<MonitorVendasEmpresaOntem>?
        empresasOntem; //Os dados serão passados como lista para essa instância.

    try {
      //Url que fará a requisição.
      var urlOntem = Uri.parse('$url/monitorvendasempresas/ontem');

      //Variável que receberá a resposta da requisição post.
      var responseOntem = await http.post(
        urlOntem,
        headers: {
          'auth-token': token, //Passando o token na header da requisição.
        },
      );

//Caso retorne status 200, a variável jsonData acessará o json e atribuirá os dados à empresasOntem caso sejam encontrados pelo caminho fornecido.
      if (responseOntem.statusCode == 200) {
        var jsonData = json.decode(responseOntem.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('monitorvendasempresas') &&
            jsonData['data']['monitorvendasempresas'].isNotEmpty) {
          empresasOntem = (jsonData['data']['monitorvendasempresas'] as List)
              .map((e) => MonitorVendasEmpresaOntem.fromJson(e))
              .toList();
        } else {
          print('Dados ausentes no JSON.');
        }
      }
    } catch (e) {
      print('Erro durante a requisição ValorOntem: $e');
    }
    return empresasOntem;
  }
}
