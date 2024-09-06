import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class FinishOrder {
  late String message;

  FinishOrder({
    required this.message,
  });

  factory FinishOrder.fromJson(Map<String, dynamic> json) {
    return FinishOrder(message: json['message'] ?? '');
  }
}

class DataServiceFinishOrder {
  static Future<Map<String?, String?>> fetchDataFinishOrder(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          print(response.body);
          print(urlPost);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Pedido finalizado com sucesso!',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Este pedido já foi finalizado ⚠️',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.warningColor,
            ),
          );
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }
}

class DataServiceFinishOrderPrintLocal {
  static Future<Map<String?, String?>> fetchDataFinishOrderPrintLocal(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          print(response.body);
          print(urlPost);

          var urlPrint =
              Uri.parse('$urlBasic/ideia/prevenda/impressao/$prevendaid');
          var responsePrint =
              await http.get(urlPrint, headers: {'auth-token': token});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Imprimindo pedido 🖨️',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.warningColor,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Pedido finalizado com sucesso!',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));

          // Chama a função para imprimir com intervalo
          await _imprimirComIntervalo(
            numpedido: numpedido,
            jsonData: jsonData,
            intervalo: const Duration(seconds: 5),
            repeticoes: 2,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Este pedido já foi finalizado ⚠️',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.warningColor,
            ),
          );
        }
      } else {
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }

  // Função para imprimir com intervalo
  static Future<void> _imprimirComIntervalo({
    required String numpedido,
    required Map<String, dynamic> jsonData,
    required Duration intervalo,
    required int repeticoes,
  }) async {
    for (int i = 0; i < repeticoes; i++) {
      await SunmiPrinter.bindingPrinter();
      await SunmiPrinter.startTransactionPrint(true);
      await SunmiPrinter.printText(jsonData['message']);
      await SunmiPrinter.printBarCode('PV$numpedido');
      await SunmiPrinter.submitTransactionPrint();
      await SunmiPrinter.exitTransactionPrint(true);

      // Aguardar o intervalo antes de iniciar o próximo ciclo
      if (i < repeticoes - 1) {
        await Future.delayed(intervalo);
      }
    }
  }
}

class DataServiceFinishOrderPrintNetwork {
  static Future<Map<String?, String?>> fetchDataFinishOrderPrintNetwork(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});

      print(urlPost);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          var urlPrint = Uri.parse(
              '$urlBasic/ideia/prevenda/impressaocompleta/$prevendaid');
          var responsePrint =
              await http.get(urlPrint, headers: {'auth-token': token});

          print(urlPrint);
          print(responsePrint.statusCode);
          print(responsePrint.body);

          // var urlPrint = Uri.parse('$urlBasic/ideia/prevenda/impressaocompleta/$prevendaid');
          // var responsePrint = await http.post(urlPost, headers: {'auth-token': token});

          // print(urlPrint);
          // print(responsePrint.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Imprimindo pedido 🖨️',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.warningColor,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Pedido finalizado!',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Este pedido já foi finalizado ⚠️',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.warningColor,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
            content: Text(
              'Erro ao finalizar pedido - ${response.statusCode} - ${response.body}',
              style: TextStyle(
                fontSize: Style.SaveUrlMessageSize(context),
                color: Style.tertiaryColor,
              ),
            ),
            backgroundColor: Style.errorColor,
          ),
        );
        print('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }
}
