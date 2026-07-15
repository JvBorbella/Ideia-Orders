import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projeto/back/check_internet.dart';
import 'package:projeto/back/customer/new_customer.dart';
import 'package:projeto/back/offline/functions/get_token.dart';
import 'package:projeto/back/save_list.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataServiceSendCustomer {
  String substituirVirgulaPorPonto(String texto) {
    return texto.replaceAll(',', '.');
  }

  String getUnmaskedText(String maskedText) {
    // Remove todos os caracteres não numéricos
    return maskedText.replaceAll(RegExp(r'\D'), '');
  }

  Future<void> sendDataCustomer(
      BuildContext context,
      String prevendaId,
      String localId,
      String empresaId,
      String tabelaprecoId,
      String urlBasic) async {
    String vendedorPessoaId = '';
    final checkInternet = await hasInternetConnection();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool permEditarPrevenda =
        sharedPreferences.getBool('editarPrevenda') ?? false;
    bool permCadastrarCliente =
        sharedPreferences.getBool('cadastrarCliente') ?? false;
    bool permEditarCliente =
        sharedPreferences.getBool('editarCliente') ?? false;
    //bool flagprivilegiado = sharedPreferences.getBool('flagprivilegiado') ?? false;

    if (checkInternet && prevendaId.isNotEmpty) {
      final customerOrder = await recuperarClientePorLocalId(localId);
      try {
        final token = await GetToken.getToken();

        //Retornar `pessoa_id` do vendedor
        try {
          var urlSeller = Uri.parse(
              "$urlBasic/ideia/core/getdata/pessoa%20p%20WHERE%20(p.codigo%20=%20'${customerOrder[0]['vendedor_codigo']}'%20OR%20p.nome%20=%20'${customerOrder[0]['vendedor_codigo']}')%20AND%20p.flagvendedor%20=%201/");
          var response =
              await http.get(urlSeller, headers: {"Accept": "text/html"});
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            var dynamicKey = data['data'].keys.first;
            var dataList = data['data'][dynamicKey];

            vendedorPessoaId = dataList[0]['pessoa_id'] ?? '';
          } else {
            log('${response.statusCode} - ${response.body}');
          }
        } catch (e) {
          log('$e');
        }
        //Cadastrar cliente
        await NewCustomer.getCostumer(
            null, // Background sync, no UI
            urlBasic,
            token,
            prevendaId,
            '',
            vendedorPessoaId, //Vendedor
            customerOrder[0]['nome'],
            customerOrder[0]['cpfcnpj'],
            customerOrder[0]['telefone'],
            customerOrder[0]['cep'],
            customerOrder[0]['bairro'],
            customerOrder[0]['endereco'],
            customerOrder[0]['cidade'],
            customerOrder[0]['complemento'],
            customerOrder[0]['numero'],
            '',
            customerOrder[0]['email'],
            customerOrder[0]['uf'],
            customerOrder[0]['ie'],
            customerOrder[0]['im'],
            empresaId,
            tabelaprecoId,
            customerOrder[0]['valordesconto'],
            permCadastrarCliente,
            permEditarCliente,
            permEditarPrevenda);

        // Retornar dados do cliente cadastrado
        try {
          var urlCustomer = Uri.parse(
              "$urlBasic/ideia/core/getdata/pessoa%20p%20WHERE%20(p.cpf%20=%20'${getUnmaskedText(customerOrder[0]['cpfcnpj'])}'%20OR%20p.cnpj%20=%20'${getUnmaskedText(customerOrder[0]['cpfcnpj'])}')/");
          var responseCustomer =
              await http.get(urlCustomer, headers: {"Accept": "text/html"});
          if (responseCustomer.statusCode == 200) {
            var dataCustomer = jsonDecode(responseCustomer.body);
            var dynamicKeyCustomer = dataCustomer['data'].keys.first;
            var dataListCustomer = dataCustomer['data'][dynamicKeyCustomer];

            //final pessoa = dataList[0]['pessoa_id'] ?? '';
            //pessoaId = pessoa;

            //Salvar pedido com todos os dados
            await NewCustomer.adjustOrder(
                null, // Background sync, no UI
                urlBasic,
                token,
                dataListCustomer[0]['nome'] ?? '',
                customerOrder[0]['cpfcnpj'] ?? '',
                customerOrder[0]['telefone'] ?? '',
                prevendaId,
                dataListCustomer[0]['pessoa_id'] ?? '',
                vendedorPessoaId, //Vendedor
                customerOrder[0]['valordesconto'] ?? 0.0,
                empresaId,
                tabelaprecoId);

            await atualizarStatusCliente(localId);
          } else {
            log('Erro busca pessoa: ${responseCustomer.statusCode} - ${responseCustomer.body}');
          }
        } catch (e) {
          log('$e');
        }
        await atualizarStatusCliente(localId);
        // customerOrder.removeWhere((item) => item['local_id'] == localId);
      } catch (e) {
        log('$e');
      }
    } else {
      log('Aq tbm n foi(CLIENTE)');
    }
  }
}
