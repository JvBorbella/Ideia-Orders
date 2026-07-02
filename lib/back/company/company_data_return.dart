import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class CompanyDataReturn {
  Future<String> searchCompany(String urlBasic, String empresaId,
      String empresaCodigo, String empresaNome) async {
    try {
      var urlGetCompany = Uri.parse(
          '''$urlBasic/ideia/core/getdata/empresa%20e%20WHERE%20(e.empresa_id%20=%20'$empresaId'%20OR%20e.empresa_codigo%20=%20'$empresaCodigo'%20OR%20e.empresa_nome%20LIKE%20'$empresaNome')/''');
      var response =
          await http.get(urlGetCompany, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var dataList = jsonData['data'].keys.first;
        var dataMap = jsonData['data'] as Map<String, dynamic>;

        if (dataMap.isNotEmpty) {
          var companyList = dataMap[dataList] as List;
          var company = companyList.first;
          return company['empresa_id'];
        } else {
          log('Lista vazia: ${response.body}');
        }
      } else {
        log('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Erro na requisição searchCompany: $e');
    }
    return '';
  }

  Future<String> searchTablePrice(String urlBasic, String tabPrecoId,
      String tabelaprecoCodigo, String tabelaprecoNome) async {
    try {
      var urlGetCompany = Uri.parse(
          '''$urlBasic/ideia/core/getdata/tabelapreco%20t%20WHERE%20(t.tabelapreco_id%20=%20'$tabPrecoId'%20OR%20t.codigo%20=%20'$tabelaprecoCodigo'%20OR%20t.nome%20LIKE%20'$tabelaprecoNome')/''');
      var response =
          await http.get(urlGetCompany, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var dataList = jsonData['data'].keys.first;
        var dataMap = jsonData['data'] as Map<String, dynamic>;

        if (dataMap.isNotEmpty) {
          var tabPriceList = dataMap[dataList] as List;
          var tabPrice = tabPriceList.first;
          return tabPrice['tabelapreco_id'];
        } else {
          log('Lista vazia: ${response.body}');
        }
      } else {
        log('${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Erro na requisição searchCompany: $e');
    }
    return '';
  }
}
