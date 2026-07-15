import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomer {
  static Future<void> getCostumer(
      BuildContext? context,
      String urlBasic,
      String token,
      String prevendaid,
      String pessoaid,
      String vendedorId,
      String nomeController,
      String cpfController,
      String telefonecontatoController,
      String cepController,
      String bairroController,
      String logradouroController,
      String localidadeController,
      String complementoController,
      String numeroController,
      String ibge,
      String emailController,
      String uf,
      String ie,
      String im,
      String empresaId,
      String tabelaprecoId,
      double valordesconto,
      bool permCadastrarCliente,
      bool permEditarCliente,
      bool permEditarPrevenda) async {
    String getUnmaskedText(String maskedText) {
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpfDefault');
    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int flagprivilegiado = prefs.getInt('flagprivilegiado') ?? 0;

    try {
      var response = await http.get(
        urlPost,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData.containsKey('success') &&
            jsonData['success'] == 1 &&
            (permEditarCliente || flagprivilegiado == 1)) {
          if (context?.mounted == true) {
            showModalBottomSheet(
                context: context!,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: Responsive.h(context, 200),
                    child: PopScope(
                      canPop: false,
                      // onPopInvokedWithResult: (didPop, result) =>
                      //     Navigator.of(context).pop(),
                      child: Container(
                        //height: Responsive.h(context, 300),
                        margin: EdgeInsets.only(
                            left: Responsive.h(context, 12),
                            right: Responsive.h(context, 12)),
                        padding: EdgeInsets.all(Responsive.h(context, 12)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Responsive.r(context, 10))),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: Responsive.w(context, 300),
                                  child: Text(
                                    'Este cliente já possui cadastro. Caso clique em "Continuar", o cadastro será atualizado.',
                                    style: TextStyle(
                                      fontSize: Responsive.h(context, 12),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: Responsive.h(context, 10)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    await NewCustomer.adjustOrder(
                                        null, // No UI context
                                        urlBasic,
                                        token,
                                        nomeController,
                                        cpfController,
                                        telefonecontatoController,
                                        prevendaid,
                                        pessoaid,
                                        vendedorId,
                                        valordesconto,
                                        empresaId,
                                        tabelaprecoId);
                                    await NewCustomer.newCostumer(
                                        null, // No UI context
                                        urlBasic,
                                        token,
                                        nomeController,
                                        cpfController,
                                        telefonecontatoController,
                                        cepController,
                                        bairroController,
                                        logradouroController,
                                        localidadeController,
                                        complementoController,
                                        numeroController,
                                        ibge,
                                        emailController,
                                        uf,
                                        ie,
                                        im,
                                        prevendaid,
                                        pessoaid,
                                        vendedorId,
                                        valordesconto,
                                        empresaId,
                                        tabelaprecoId);
                                    Navigator.of(context).pop();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Responsive.h(context, 8)),
                                          content: Text(
                                            'Cadastro atualizado com sucesso!',
                                            style: TextStyle(
                                              fontSize:
                                                  Responsive.h(context, 10),
                                              color: ColorsApp.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor:
                                              ColorsApp.sucefullColor,
                                        ),
                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: Responsive.h(context, 30),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Responsive.r(context, 10)),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    child: Text(
                                      'Continuar',
                                      style: TextStyle(
                                        color: ColorsApp.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.h(context, 10),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(height: Responsive.h(context, 10)),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    height: Responsive.h(context, 30),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Responsive.r(context, 10)),
                                      border: Border.all(
                                          width: 2,
                                          color: ColorsApp.errorColor),
                                      color: ColorsApp.tertiaryColor,
                                    ),
                                    child: Text(
                                      'Cancelar alterações',
                                      style: TextStyle(
                                        color: ColorsApp.errorColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: Responsive.h(context, 10),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            log('UI modal skipped (context not mounted): Existing customer detected');
            // Proceed with update silently
            await NewCustomer.adjustOrder(
                null,
                urlBasic,
                token,
                nomeController,
                cpfController,
                telefonecontatoController,
                prevendaid,
                pessoaid,
                vendedorId,
                valordesconto,
                empresaId,
                tabelaprecoId);
          }
        } else if (permCadastrarCliente || flagprivilegiado == 1) {
          await NewCustomer.newCostumer(
              context,
              urlBasic,
              token,
              nomeController,
              cpfDefault,
              telefonecontatoController,
              cepController,
              bairroController,
              logradouroController,
              localidadeController,
              complementoController,
              numeroController,
              ibge,
              emailController,
              uf,
              ie,
              im,
              prevendaid,
              pessoaid,
              vendedorId,
              valordesconto,
              empresaId,
              tabelaprecoId);
        } else {
          if (context?.mounted == true) {
            showDialog(
                context: context!, builder: (_) => const AlertDialogDefault());
          } else {
            log('UI dialog skipped: No permission to register/edit customer');
          }
        }
        if (permEditarPrevenda || flagprivilegiado == 1) {
          await NewCustomer.adjustOrder(
              context,
              urlBasic,
              token,
              nomeController,
              cpfController,
              telefonecontatoController,
              prevendaid,
              pessoaid,
              vendedorId,
              valordesconto,
              empresaId,
              tabelaprecoId);
        }
      } else {
        final message =
            'Não foi possível consultar este CPF - ${response.statusCode} - ${response.body}';
        if (context?.mounted == true) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                message,
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.errorColor,
            ),
          );
        } else {
          log(message);
        }
      }
    } catch (e) {
      final message = '$e';
      if (context?.mounted == true) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Responsive.h(context, 8)),
            content: Text(
              message,
              style: TextStyle(
                fontSize: Responsive.h(context, 10),
                color: ColorsApp.tertiaryColor,
              ),
            ),
            backgroundColor: ColorsApp.errorColor,
          ),
        );
      } else {
        log('Error in getCostumer (UI skipped): $e');
      }
      log('Erro durante a requisição: $e');
    }
  }

  static Future<void> newCostumer(
      BuildContext? context,
      String urlBasic,
      String token,
      String nomeController,
      String cpfController,
      String telefonecontatoController,
      String cepController,
      String bairroController,
      String logradouroController,
      String localidadeController,
      String complementoController,
      String numeroController,
      String ibge,
      String emailController,
      String uf,
      String ie,
      String im,
      String prevendaId,
      String pessoaId,
      String vendedorId,
      double valordesconto,
      String empresaId,
      String tabelaprecoId) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novocliente');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    String getUnmaskedText(String maskedText) {
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var telDefault = getUnmaskedText(telefonecontatoController);
    var cepDefault = getUnmaskedText(cepController);
    var body = jsonEncode({
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'cep': cepDefault,
      'endereco': logradouroController,
      'enderecocidade': localidadeController,
      'endereconumero': numeroController,
      'complemento': complementoController,
      'bairro': bairroController,
      'codigocidade': ibge,
      'email': emailController,
      'uf': uf,
      'inscricaoestadual': ie,
      'inscricaomunicipal': im,
    });

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        if (context?.mounted == true) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                'Cliente cadastrado com sucesso!',
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.sucefullColor,
            ),
          );
        } else {
          log('Cliente cadastrado com sucesso (UI skipped)');
        }
        var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpfDefault');

        var headers = {
          'auth-token': token,
          'Content-Type': 'application/json',
        };

        try {
          var response = await http.get(
            urlPost,
            headers: headers,
          );
          if (response.statusCode == 200) {
            var jsonData = json.decode(response.body);
            if (jsonData.containsKey('success') && jsonData['success'] == 1) {
              var pessoaId =
                  jsonData['data']['pessoa'][0]['pessoa_id'].toString();
              NewCustomer.adjustOrder(
                  context,
                  urlBasic,
                  token,
                  nomeController,
                  cpfController,
                  telefonecontatoController,
                  prevendaId,
                  pessoaId,
                  vendedorId,
                  valordesconto,
                  empresaId,
                  tabelaprecoId);
            }
          }
        } catch (e) {
          log('$e');
        }
      } else {
        final message = '${response.statusCode} - ${response.body}';
        if (context?.mounted == true) {
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                message,
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.errorColor,
            ),
          );
        } else {
          log('Error newCostumer (UI skipped): $message');
        }
      }
    } catch (e) {
      final message = '$e';
      if (context?.mounted == true) {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Responsive.h(context, 8)),
            content: Text(
              message,
              style: TextStyle(
                fontSize: Responsive.h(context, 10),
                color: ColorsApp.tertiaryColor,
              ),
            ),
            backgroundColor: ColorsApp.errorColor,
          ),
        );
      } else {
        log('Error newCostumer (UI skipped): $e');
      }
      log('Erro durante a requisição: $e');
    }
  }

  static Future<void> adjustOrder(
      BuildContext? context,
      String urlBasic,
      String token,
      String nomeController,
      String cpfController,
      String telefonecontatoController,
      String prevendaid,
      String pessoaid,
      String vendedorId,
      double valordesconto,
      String empresaId,
      String tabelaprecoId) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/ajustapedido');

    final prefs = await SharedPreferences.getInstance();
    bool flagGerarPedido = prefs.getBool('flagGerarPedido') ?? false;

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    String getUnmaskedText(String maskedText) {
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var telDefault = getUnmaskedText(telefonecontatoController);
    var body = jsonEncode({
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'prevenda_id': prevendaid,
      'pessoa_id': pessoaid,
      'vendedor_id': vendedorId == "null" ? null : vendedorId,
      'valordesconto': valordesconto,
      'empresa_id': empresaId,
      'tabelapreco_id': tabelaprecoId
    });
    var bodyJson = {
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'prevenda_id': prevendaid,
      'pessoa_id': pessoaid,
      'vendedor_id': vendedorId,
      'valordesconto': valordesconto,
      'empresa_id': empresaId,
      'tabelapreco_id': tabelaprecoId
    };

    List<Map<String, dynamic>> dataOrder = [
      bodyJson,
    ];

    await salvarListaPedido(dataOrder);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (context?.mounted == true) {
          Message.showReturnOverlay(context!, ColorsApp.sucefullColor,
              Icons.check_circle, 'Pedido Gravado');
          if (flagGerarPedido == true) {
            var urlGerarPedido =
                Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');
            var responsePedido = await http.post(
              urlGerarPedido,
              headers: {'auth-token': token},
            );
            log(responsePedido.body.toString());
            if (responsePedido.statusCode != 200) {
              Message.showReturnOverlay(
                  context,
                  ColorsApp.errorColor,
                  Icons.error,
                  'Erro ao gerar pedido - ${responsePedido.body}.');
            }
          }
        } else {
          log('Pedido Gravado (UI skipped)');
        }
      } else {
        final message = '${response.statusCode} - ${response.body}';
        if (context?.mounted == true) {
          Message.showReturnOverlay(
              context!, ColorsApp.errorColor, Icons.error, message);
        } else {
          log('Error adjustOrder (UI skipped): $message');
        }
      }
    } catch (e) {
      final message = '$e';
      if (context?.mounted == true) {
        Message.showReturnOverlay(
            context!, ColorsApp.errorColor, Icons.error, message);
      } else {
        log('Error adjustOrder (UI skipped): $e');
      }
      Message.showReturnOverlay(
          context!, ColorsApp.errorColor, Icons.error, message);
    }
  }
}
