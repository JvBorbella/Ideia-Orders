import 'dart:convert';
import 'package:http/http.dart' as http;

//Código onde serão acessados os dados de vendas do dia.

class MonitorVendasEmpresaHoje {
  //Definindo o tipo das variáveis que estão recebendo os dados
  late String empresaNome;
  late double valorHoje;
  late double ticketHoje;

  MonitorVendasEmpresaHoje({
    required this.empresaNome,
    required this.valorHoje,
    required this.ticketHoje,
  });

  //Método para acessar os campos presentes no json e atrivuí-los a cada variável dentro da class MonitorVendasEmpresaHoje.
  factory MonitorVendasEmpresaHoje.fromJson(Map<String, dynamic> json) {
    return MonitorVendasEmpresaHoje(
      empresaNome: json['empresa_nome'],
      valorHoje: (json['valortotal'] ?? 0).toDouble(), // Conversão para double
      ticketHoje: (json['ticket'] ?? 0).toDouble(), // Conversão para double
    );
  }
}

//Classe onde será feita a requisição e acessado o json para serem resgatados os dados a serem utilizados.
class DataService {
  static Future<List<MonitorVendasEmpresaHoje>?> fetchData(
      String token, String url) async {
    List<MonitorVendasEmpresaHoje>?
        empresasHoje; //Dados serão retornados em lista, para retornarem todos os dados de cada campo.

    try {
      //Definindo a url que fará a requisição post.
      var urlHoje = Uri.parse('$url/monitorvendasempresas/hoje');

      var responseHoje = await http.post(
        //Variável que irá receber a resposta da requisição.
        urlHoje,
        headers: {
          //Passando o token na header para que seja aceita a requisição.
          'auth-token': token,
        },
      );

      if (responseHoje.statusCode == 200) {
        //Se a conexão for aceita, o json será acessado e resgatados os dados.
        var jsonData = json.decode(responseHoje.body);

        //Terá que ser informado o caminho do campo dentro do json para que seja encontrado.
        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('monitorvendasempresas') &&
            jsonData['data']['monitorvendasempresas'].isNotEmpty) {
          empresasHoje = (jsonData['data']['monitorvendasempresas']
                  as List) //Os dados serão passados em lista para empresasHoje.
              .map((e) => MonitorVendasEmpresaHoje.fromJson(e))
              .toList();
        } else {
          //Caso não sejam encontrados os campos no caminho fornecido, será exibida a mensagem no console:
          print('Dados ausentes no JSON.');
        }
      }
    } catch (e) {
      //Caso a tentativa de requisição não seja bem-sucedida, será exibido o erro no console.
      print('Erro durante a requisição ValorHoje: $e');
    }
    return empresasHoje;
  }
}
