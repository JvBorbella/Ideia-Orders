import 'dart:convert';
import 'package:http/http.dart' as http;

//Código com a função para retornar os dados de vendas da semana.

class MonitorVendasEmpresaSemana {
  //Definindo o tipo da variável que irá receber o dado.
  late double valorSemana;
  late String empresaNome;

  MonitorVendasEmpresaSemana({
    required this.valorSemana,
    required this.empresaNome,
  });

  factory MonitorVendasEmpresaSemana.fromJson(Map<String, dynamic> json) {
    return MonitorVendasEmpresaSemana(
      //Atribuindo a ela o dado vindo do json.
      valorSemana: (json['valortotal'] ?? 0).toDouble(),
      empresaNome: json['empresa_nome'],
    );
  }
}

//Classe onde será acessado o json e resgatados os dados.
class DataServiceSemana {
  static Future<List<MonitorVendasEmpresaSemana>?> fetchDataSemana(
      String token, String url) async {
    //Os dados serão retornados em lista, pois podem haver mais de um dado para os campo.
    List<MonitorVendasEmpresaSemana>? empresasSemana;

    try {
      //Url que fará a requisição.
      var urlSemana = Uri.parse('$url/monitorvendasempresas/semana');

      //Variável que irá receber a receber a resposta da requisição.
      var responseSemana = await http.post(
        urlSemana,
        headers: {
          'auth-token':
              token, //Passando o token na header para a requisição ser aceita.
        },
      );

      //Caso a resposta seja 200, a variável jsonData acessará o json e buscará os dados através do caminho informado.
      if (responseSemana.statusCode == 200) {
        var jsonData = json.decode(responseSemana.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('monitorvendasempresas') &&
            jsonData['data']['monitorvendasempresas'].isNotEmpty) {
          empresasSemana = (jsonData['data']['monitorvendasempresas'] as List)
              .map((e) => MonitorVendasEmpresaSemana.fromJson(e))
              .toList(); // Caso sejam encontrados, serão passados como uma lista para a instância empresasSemana.
          //Caso não sejam encontrados, exibirá essa mensagem no console.
        } else {
          print('Dados ausentes no JSON.');
        }
      }
      //Se a tentativa de requisição não for aceita, o erro será exibido no console.
    } catch (e) {
      print('Erro durante a requisição ValorSemana: $e');
    }
    return empresasSemana;
  }
}
