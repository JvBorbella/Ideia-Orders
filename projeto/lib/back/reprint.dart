import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/pdf_print_service.dart';
import 'package:projeto/front/components/style.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_barcode_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';

class DataServiceRePrintOrder {
  static Future<Map<String?, String?>> fetchDataRePrintOrder(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/impressao/$prevendaid');
      var response = await http.get(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          print(urlPost);

          if (await isSunmiDevice()) {
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
          } else {
            await PdfPrintService.generateAndPrintPdf(
              message: message.toString(),
              numero: numpedido,
            );
          }

          // await SunmiPrinter.bindingPrinter();
          // await SunmiPrinter.startTransactionPrint(true);
          // await SunmiPrinter.printText(jsonData['message']);
          // await SunmiPrinter.printBarCode('PV$numpedido');
          // await SunmiPrinter.submitTransactionPrint();
          // await SunmiPrinter.exitTransactionPrint(true);
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

Future<bool> isSunmiDevice() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  // Normalmente em dispositivos Sunmi, a marca é "SUNMI" e o modelo contém "V2", "V2 PRO", etc.
  final brand = androidInfo.brand?.toLowerCase() ?? '';
  final model = androidInfo.model?.toLowerCase() ?? '';

  return brand.contains('sunmi') || model.contains('sunmi');
}

class RePrintOrderNetwork {
  // RePrintOrder({
  // });

  // factory RePrintOrder.fromJson(Map<String, dynamic> json) {
  //   // return RePrintOrder(message: json['message'] ?? '');
  // }
}

class DataServiceRePrintOrderNetwork {
  static Future<Map<String?, String?>> fetchDataRePrintOrderNetwork(
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
