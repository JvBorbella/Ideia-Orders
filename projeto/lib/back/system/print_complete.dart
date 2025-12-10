import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/style.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_barcode_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class PrintComplete {
  // PrintComplete({
  // });

  // factory PrintComplete.fromJson(Map<String, dynamic> json) {
  //   // return PrintComplete(message: json['message'] ?? '');
  // }
}

class DataServicePrintComplete {
  static Future<Map<String?, String?>> fetchDataPrintComplete(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPost =
          Uri.parse('$urlBasic/ideia/prevenda/impressaocompleta/$prevendaid');
      var response = await http.get(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          print(urlPost);

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
                '$message',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.sucefullColor,
            ),
          );

          await SunmiPrinter.bindingPrinter();
          await SunmiPrinter.startTransactionPrint(true);
          await SunmiPrinter.printText(jsonData['message']);
          await SunmiPrinter.printBarCode('PV$numpedido',
              style: SunmiBarcodeStyle(
                  type: SunmiBarcodeType.CODE128,
                  textPos: SunmiBarcodeTextPos.TEXT_ABOVE,
                  height: 70,
                  align: SunmiPrintAlign.CENTER,
                  size: 2));
          // Adiciona linhas em branco para garantir que o cupom saia
          await SunmiPrinter.printText('\n\n\n');
          // Se o modelo suportar corte automático
          await SunmiPrinter.cut();
          await SunmiPrinter.exitTransactionPrint(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Não foi possível reimprimir o pedido - ${response.statusCode} - ${response.body}',
                style: TextStyle(
                  fontSize: Style.SaveUrlMessageSize(context),
                  color: Style.tertiaryColor,
                ),
              ),
              backgroundColor: Style.errorColor,
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
