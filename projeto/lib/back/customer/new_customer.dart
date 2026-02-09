import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:projeto/back/customer/get_cliente.dart';
import 'package:projeto/back/saveList.dart';
import 'package:projeto/front/components/global/elements/alert_dialog.dart';
import 'package:projeto/front/components/new_order/sessions/customers/customer_session.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewCustomer {
  static Future<void> getCostumer(
      BuildContext context,
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
      double valordesconto,
      bool permCadastrarCliente,
      bool permEditarCliente,
      bool permEditarPrevenda) async {
    String getUnmaskedText(String maskedText) {
      // Remove todos os caracteres não numéricos
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var telDefault = getUnmaskedText(telefonecontatoController);

    print(ibge);

    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/pessoa/$cpfDefault');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };

    print(cpfDefault);
    print('email' + emailController);

    try {
      var response = await http.get(
        urlPost,
        headers: headers,
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData.containsKey('success') &&
            jsonData['success'] == 1 &&
            permEditarCliente) {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                    //Configurações de tamanho e espaçamento do modal
                    height: Style.height_200(context),
                    child: WillPopScope(
                        child: Container(
                          //Tamanho e espaçamento interno do modal
                          height: Style.InternalModalSize(context),
                          margin: EdgeInsets.only(
                              left: Style.ModalMargin(context),
                              right: Style.ModalMargin(context)),
                          padding: EdgeInsets.all(
                              Style.InternalModalPadding(context)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Style.ModalBorderRadius(context))),
                          child: Column(
                            //Conteúdo interno do modal
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: Style.width_250(context),
                                    child: Text(
                                      'Este cliente já possui cadastro. Caso clique em "Continuar", o cadastro será atualizado.',
                                      style: TextStyle(
                                        fontSize: Style.height_15(context),
                                        color: Style.primaryColor,
                                      ),
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: Style.height_30(context),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await NewCustomer.AdjustOrder(
                                          context,
                                          urlBasic,
                                          token,
                                          nomeController,
                                          cpfController,
                                          telefonecontatoController,
                                          prevendaid,
                                          pessoaid,
                                          vendedorId,
                                          valordesconto ?? 0.0);
                                      await NewCustomer.newCostumer(
                                          context,
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
                                          uf);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          padding: EdgeInsets.all(
                                              Style.SaveUrlMessagePadding(
                                                  context)),
                                          content: Text(
                                            'Cadastro atualizado com sucesso!',
                                            style: TextStyle(
                                              fontSize:
                                                  Style.SaveUrlMessageSize(
                                                      context),
                                              color: Style.tertiaryColor,
                                            ),
                                          ),
                                          backgroundColor: Style.sucefullColor,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      // width: Style.width_200(context),
                                      // height: Style.ButtonExitHeight(context),
                                      padding: EdgeInsets.all(
                                          Style.ButtonExitPadding(context)),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Style.ButtonExitBorderRadius(
                                                  context)),
                                          color: Style.primaryColor),
                                      child: Text(
                                        'Continuar',
                                        style: TextStyle(
                                          color: Style.tertiaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Style.height_10(context),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      // width: Style.ButtonCancelWidth(context),
                                      // height: Style.ButtonCancelHeight(context),
                                      padding: EdgeInsets.all(
                                          Style.ButtonCancelPadding(context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Style.ButtonExitBorderRadius(
                                                context)),
                                        border: Border.all(
                                            width:
                                                Style.WidthBorderImageContainer(
                                                    context),
                                            color: Style.errorColor),
                                        color: Style.tertiaryColor,
                                      ),
                                      child: Text(
                                        'Cancelar alterações',
                                        style: TextStyle(
                                          color: Style.errorColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: Style.height_10(context),
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
                        onWillPop: () async {
                          Navigator.of(context).pop();
                          return true;
                        }));
              });
        } else if (permCadastrarCliente) {
          await NewCustomer.newCostumer(
              context,
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
              uf);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Cliente cadastrado com sucesso!',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );
        } else {
          showDialog(context: context, builder: (_) => AlertDialogDefault());
        }
        if (permEditarPrevenda) {
          await NewCustomer.AdjustOrder(
              context,
              urlBasic,
              token,
              nomeController,
              cpfController,
              telefonecontatoController,
              prevendaid,
              pessoaid,
              vendedorId,
              valordesconto ?? 0.0);
        } else {}
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Não foi possível consultar este CPF - ${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            '$e',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
              color: Style.tertiaryColor,
            ),
          ),
          backgroundColor: Style.errorColor,
        ),
      );
      print('Erro durante a requisição: $e');
    }
  }

  static Future<void> newCostumer(
      BuildContext context,
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
      String uf) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/novocliente');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    String getUnmaskedText(String maskedText) {
      // Remove todos os caracteres não numéricos
      return maskedText.replaceAll(RegExp(r'\D'), '');
    }

    var cpfDefault = getUnmaskedText(cpfController);
    var telDefault = getUnmaskedText(telefonecontatoController);
    var body = jsonEncode({
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'cep': cepController,
      'endereco': logradouroController,
      'enderecocidade': localidadeController,
      'endereconumero': numeroController,
      'complemento': complementoController,
      'bairro': bairroController,
      'codigocidade': ibge,
      'email': emailController,
      'uf': uf,
    });
    var bodyJson = {
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'cep': cepController,
      'endereco': logradouroController,
      'enderecocidade': localidadeController,
      'endereconumero': numeroController,
      'complemento': complementoController,
      'bairro': bairroController,
      'codigocidade': ibge,
      'email': emailController,
      'uf': uf,
    };

    // List<Map<String, dynamic>> dataOrder = [
    //   bodyJson,
    // ];

    // await salvarListaCliente(dataOrder);

    // Future<List<Map<String, dynamic>>> recuperarLista() async {
    //   final prefs = await SharedPreferences.getInstance();

    //   String? listaJson = prefs.getString('minha_lista');

    //   if (listaJson == null) return [];

    //   List<dynamic> listaDecodificada = jsonDecode(listaJson);

    //   return listaDecodificada
    //       .map((item) => Map<String, dynamic>.from(item))
    //       .toList();
    // }
    // List<Map<String, dynamic>> listaSalva = await recuperarLista();
    // print(listaSalva);

    // print(cpfDefault);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     behavior: SnackBarBehavior.floating,
        //     padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
        //     content: Text(
        //       'Cliente cadastrado com sucesso!',
        //       style: TextStyle(
        //         fontSize: Style.SaveUrlMessageSize(context),
        //         color: Style.tertiaryColor,
        //       ),
        //     ),
        //     backgroundColor: Style.sucefullColor,
        //   ),
        // );
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              '${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            '$e',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
              color: Style.tertiaryColor,
            ),
          ),
          backgroundColor: Style.errorColor,
        ),
      );
      print('Erro durante a requisição: $e');
    }
  }

  static Future<void> AdjustOrder(
      BuildContext context,
      String urlBasic,
      String token,
      String nomeController,
      String cpfController,
      String telefonecontatoController,
      String prevendaid,
      String pessoaid,
      String vendedorId,
      double valordesconto) async {
    var urlPost = Uri.parse('$urlBasic/ideia/prevenda/ajustapedido');

    var headers = {
      'auth-token': token,
      'Content-Type': 'application/json',
    };
    String getUnmaskedText(String maskedText) {
      // Remove todos os caracteres não numéricos
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
      'vendedor_id': vendedorId,
      'valordesconto': valordesconto
    });
    var bodyJson = {
      'cpf': cpfDefault,
      'nome': nomeController,
      'telefone': telDefault,
      'prevenda_id': prevendaid,
      'pessoa_id': pessoaid,
      'vendedor_id': vendedorId,
      'valordesconto': valordesconto
    };

    List<Map<String, dynamic>> dataOrder = [
      bodyJson,
    ];

    await salvarListaPedido(dataOrder);

    Future<List<Map<String, dynamic>>> recuperarLista() async {
      final prefs = await SharedPreferences.getInstance();

      String? listaJson = prefs.getString('minha_lista');

      if (listaJson == null) return [];

      List<dynamic> listaDecodificada = jsonDecode(listaJson);

      return listaDecodificada
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    List<Map<String, dynamic>> listaSalva = await recuperarLista();
    print(listaSalva);

    try {
      var response = await http.post(
        urlPost,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Dados enviados com sucesso');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Pedido Gravado',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.sucefullColor,
          ),
        );
      } else {
        print('Erro ao enviar dados: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              '${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
          content: Text(
            '$e',
            style: TextStyle(
              fontSize: Style.SaveUrlMessageSize(context),
              color: Style.tertiaryColor,
            ),
          ),
          backgroundColor: Style.errorColor,
        ),
      );
      print('Erro durante a requisição: $e');
    }
  }
}
