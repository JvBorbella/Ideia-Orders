import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/system/pdf_print_service.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:styles/colors.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_barcode_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
import 'dart:developer';

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
    bool flagGerarPedido,
    int flagTypeFinish, {
    bool isBackground = false,
  }) async {
    String? message;

    switch (flagTypeFinish) {
      case 0:
        return await Functions.justFinish(
            context, urlBasic, token, prevendaid, numpedido, flagGerarPedido,
            isBackground: isBackground);
      case 1:
        return await Functions.finishPrintLocal(
            context, urlBasic, token, prevendaid, numpedido, flagGerarPedido);
      case 2:
        return await Functions.finishPrintNetwork(
            context, urlBasic, token, prevendaid, numpedido, flagGerarPedido);
    }

    // if (flagGerarPedido == true) {
    //   var urlGerarPedido =
    //       Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');
    //   var responsePedido = await http.post(
    //     urlGerarPedido,
    //     headers: {'auth-token': token},
    //   );

    //   if (responsePedido.statusCode == 200) {
    //     Message.showReturnOverlay(
    //         context,
    //         ColorsApp.sucefullColor,
    //         Icons.print_rounded,
    //         'Pedido de venda gerado - ${responsePedido.body}');
    //   } else {
    //     Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
    //         'Erro ao gerar pedido - ${responsePedido.body}.');
    //   }
    // }
    return {'message': message.toString()};
  }
}

class Functions {
  static Future<Map<String?, String?>> justFinish(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
    bool flagGerarPedido, {
    bool isBackground = false,
  }) async {
    String? message;

    try {
      if (flagGerarPedido == true) {
        var urlGerarPedido =
            Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');
        var responsePedido = await http.post(
          urlGerarPedido,
          headers: {'auth-token': token},
        );
        if (responsePedido.statusCode == 200) {
          log('Pedido de venda gerado - ${responsePedido.body}');
          if (!isBackground && context.mounted) {
            // Message.showReturnOverlay(context, ColorsApp.sucefullColor,
            //     Icons.print_rounded, 'Pedido de venda gerado - PV$numpedido');
          }
        } else {
          if (!isBackground && context.mounted) {
            // Message.showReturnOverlay(context, ColorsApp.errorColor,
            //     Icons.error, 'Erro ao gerar pedido - ${responsePedido.body}.');
          }
        }
      }
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        log('${jsonData['message']}');

        // if (jsonData.containsKey('success') && jsonData['success'] == true) {
        //   message = jsonData['message'];

        //   if (!isBackground && context.mounted) {
        //     Message.showReturnOverlay(context, ColorsApp.sucefullColor,
        //         Icons.check_circle, 'Pedido finalizado com sucesso!');
        //   }
        // } else {
        //   if (!isBackground && context.mounted) {
        //     Message.showReturnOverlay(context, ColorsApp.warningColor,
        //         Icons.error, 'Este pedido já foi finalizado.');
        //   }
        // }
      } else {
        log('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }

  static Future<Map<String?, String?>> finishPrintLocal(
      BuildContext context,
      String urlBasic,
      String token,
      String prevendaid,
      String numpedido,
      bool flagGerarPedido) async {
    String? message;

    try {
      if (flagGerarPedido == true) {
        var urlGerarPedido =
            Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');
        var responsePedido = await http.post(
          urlGerarPedido,
          headers: {'auth-token': token},
        );
        if (responsePedido.statusCode == 200) {
          log('Pedido de venda gerado - ${responsePedido.body}');
          Message.showReturnOverlay(context, ColorsApp.sucefullColor,
              Icons.print_rounded, 'Pedido de venda gerado - PV$numpedido');
        } else {
          Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
              'Erro ao gerar pedido - ${responsePedido.body}.');
        }
      }
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          if (await isSunmiDevice()) {
            await _imprimirComIntervalo(
              numpedido: numpedido,
              jsonData: jsonData,
              intervalo: const Duration(seconds: 5),
              repeticoes: 2,
            );
          } else {
            await PdfPrintService.generateAndPrintPdf(
              message: message.toString(),
              numero: numpedido,
            );
          }

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()));
        } else {
          Message.showReturnOverlay(context, ColorsApp.warningColor,
              Icons.error, 'Este pedido já foi finalizado.');
        }
      } else {
        log('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      log('Erro durante a requisição OrderDetails: $e');
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
      if (i < repeticoes - 1) {
        await Future.delayed(intervalo);
      }
    }
  }

  static Future<Map<String?, String?>> finishPrintNetwork(
      BuildContext context,
      String urlBasic,
      String token,
      String prevendaid,
      String numpedido,
      bool flagGerarPedido) async {
    String? message;

    try {
      if (flagGerarPedido == true) {
        var urlGerarPedido =
            Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');
        var responsePedido = await http.post(
          urlGerarPedido,
          headers: {'auth-token': token},
        );
        if (responsePedido.statusCode == 200) {
          log('Pedido de venda gerado - ${responsePedido.body}');
          Message.showReturnOverlay(context, ColorsApp.sucefullColor,
              Icons.print_rounded, 'Pedido de venda gerado - PV$numpedido');
        } else {
          Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
              'Erro ao gerar pedido - ${responsePedido.body}.');
        }
      }
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var response = await http.post(urlPost, headers: {'auth-token': token});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];

          Message.showReturnOverlay(context, ColorsApp.warningColor,
              Icons.print, 'Imprimindo pedido, aguarde...');

          Message.showReturnOverlay(context, ColorsApp.sucefullColor,
              Icons.check_circle, 'Pedido finalizado com sucesso!');

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Home()));
        } else {
          Message.showReturnOverlay(context, ColorsApp.warningColor,
              Icons.error, 'Este pedido já foi finalizado.');
        }
      } else {
        Message.showReturnOverlay(context, ColorsApp.errorColor, Icons.error,
            'Erro ao finalizar pedido - ${response.body}');
      }
    } catch (e) {
      log('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }
}

Future<bool> isSunmiDevice() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  // Normalmente em dispositivos Sunmi, a marca é "SUNMI" e o modelo contém "V2", "V2 PRO", etc.
  final brand = androidInfo.brand.toLowerCase();
  final model = androidInfo.model.toLowerCase();

  return brand.contains('sunmi') || model.contains('sunmi');
}
