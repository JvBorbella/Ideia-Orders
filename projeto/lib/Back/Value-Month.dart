import 'dart:convert';
import 'package:http/http.dart' as http;

//Código com a função para retornar os dados de vendas do mês.

class MonitorVendasEmpresaMes {
  //Definindo o tipo da variável.
  double valorMes;
  String empresaNome;

  MonitorVendasEmpresaMes({
    required this.valorMes,
    required this.empresaNome
  });

  factory MonitorVendasEmpresaMes.fromJson(Map<String, dynamic> json) {
    return MonitorVendasEmpresaMes(
      //Atribuindo o dado do json a ela.
      valorMes: (json['valortotal'] ?? 0).toDouble(),
      empresaNome: json['empresa_nome'],
    );
  }
}

//Classe com a função para resgatar os dados no json.
class DataServiceMes {
  static Future<List<MonitorVendasEmpresaMes>?> fetchDataMes(
      String token, String url) async {
    //Estes dados serão retornados em listas, pois podem haver mais de um dado para um campo.
    List<MonitorVendasEmpresaMes>? empresasMes;

    try {
      //Url para a requisição.
      var urlMes = Uri.parse('$url/monitorvendasempresas/mes');

      var responseMes = await http.post(
        urlMes,
        headers: {
          'auth-token':
              token, //Passando o token na header para a requisição ser aceita.
        },
      );

      //Caso seja aceita, a variável jsonData acessará o json fornecido pela requisição e encontrará os campos através do caminho informado.
      if (responseMes.statusCode == 200) {
        var jsonData = json.decode(responseMes.body);

        if (jsonData.containsKey('data') &&
            jsonData['data'].containsKey('monitorvendasempresas') &&
            jsonData['data']['monitorvendasempresas'].isNotEmpty) {
          empresasMes = (jsonData['data']['monitorvendasempresas'] as List)
              .map((e) => MonitorVendasEmpresaMes.fromJson(e))
              .toList();
          //Caso não sejam encontrados dados neste caminho, a seguinte mensagem será exibida no console.
        } else {
          print('Dados ausentes no JSON.');
        }
      }
      //Caso ocorra algum erro na requisição post, o mesmo será exibido no console.
    } catch (e) {
      print('Erro durante a requisição ValorMes: $e');
    }
    return empresasMes;
  }
}
