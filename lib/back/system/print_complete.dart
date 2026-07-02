import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_barcode_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                'Imprimindo pedido 🖨️',
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.warningColor,
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Responsive.h(context, 8)),
              content: Text(
                '$message',
                style: TextStyle(
                  fontSize: Responsive.h(context, 10),
                  color: ColorsApp.tertiaryColor,
                ),
              ),
              backgroundColor: ColorsApp.sucefullColor,
            ),
          );

          // await SunmiPrinter.bindingPrinter();
          // await SunmiPrinter.startTransactionPrint(true);
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
          await SunmiPrinter.cutPaper();
          // await SunmiPrinter.exitTransactionPrint(true);
        } else {
          Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
              'Não foi possível reimprimir o pedido - ${response.statusCode} - ${response.body}');
        }
      } else {
        Message.showReturnOverlay(
            context, ColorsApp.errorColor, Icons.error, response.body);
      }
    } catch (e) {
      Message.showReturnOverlay(
          context, ColorsApp.errorColor, Icons.error, '$e');
    }

    return {'message': message.toString()};
  }
}
