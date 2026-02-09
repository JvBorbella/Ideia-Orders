import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/back/orders/orders_endpoint.dart';
import 'package:projeto/back/system/pdf_print_service.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_printer_plus/core/enums/enums.dart';
import 'package:sunmi_printer_plus/core/styles/sunmi_barcode_style.dart';
import 'package:sunmi_printer_plus/core/sunmi/sunmi_printer.dart';
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
      bool flagGerarPedido) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var urlGerarPedido = Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');

      if (flagGerarPedido == true) {
        var responsePedido =
            await http.post(
              urlGerarPedido, 
              headers: {'auth-token': token},
            );
        var response = await http.post(urlPost, headers: {'auth-token': token});

        if (response.statusCode == 200 && responsePedido.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

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

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
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
          print('Pedido: ${responsePedido.statusCode} - ${responsePedido.body}');
          print('Erro ao carregar dados: ${response.statusCode}');
        }
      } else {
        var response = await http.post(urlPost, headers: {'auth-token': token});

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

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

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
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
      bool flagGerarPedido) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var urlGerarPedido =
          Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');

      if (flagGerarPedido == true) {
        var responsePedido =
            await http.post(urlGerarPedido, headers: {'auth-token': token});
        var response = await http.post(urlPost, headers: {'auth-token': token});
        if (response.statusCode == 200 && responsePedido.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

            var urlPrint =
                Uri.parse('$urlBasic/ideia/prevenda/impressao/$prevendaid');
            var responsePrint =
                await http.get(urlPrint, headers: {'auth-token': token});

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

            // Chama a função para imprimir com intervalo
            // await _imprimirComIntervalo(
            //   numpedido: numpedido,
            //   jsonData: jsonData,
            //   intervalo: const Duration(seconds: 5),
            //   repeticoes: 2,
            // );
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
      } else {
        var response = await http.post(urlPost, headers: {'auth-token': token});
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

            var urlPrint =
                Uri.parse('$urlBasic/ideia/prevenda/impressao/$prevendaid');
            var responsePrint =
                await http.get(urlPrint, headers: {'auth-token': token});

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

            // Chama a função para imprimir com intervalo
            // await _imprimirComIntervalo(
            //   numpedido: numpedido,
            //   jsonData: jsonData,
            //   intervalo: const Duration(seconds: 5),
            //   repeticoes: 2,
            // );
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
      if (i < repeticoes - 1) {
        await Future.delayed(intervalo);
      }
    }
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

class DataServiceFinishOrderPrintNetwork {
  static Future<Map<String?, String?>> fetchDataFinishOrderPrintNetwork(
      BuildContext context,
      String urlBasic,
      String token,
      String prevendaid,
      String numpedido,
      bool flagGerarPedido) async {
    String? message;

    try {
      var urlPost = Uri.parse('$urlBasic/ideia/prevenda/finalizar/$prevendaid');
      var urlGerarPedido =
          Uri.parse('$urlBasic/ideia/prevenda/gerarpedido/$prevendaid');

      if (flagGerarPedido) {
        var responsePedido =
            await http.post(urlGerarPedido, headers: {'auth-token': token});
        var response = await http.post(urlPost, headers: {'auth-token': token});

        if (response.statusCode == 200 && responsePedido.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

            var urlPrint = Uri.parse(
                '$urlBasic/ideia/prevenda/impressaocompleta/$prevendaid');
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
                  'Pedido finalizado!',
                  style: TextStyle(
                    fontSize: Style.SaveUrlMessageSize(context),
                    color: Style.tertiaryColor,
                  ),
                ),
                backgroundColor: Style.sucefullColor,
              ),
            );

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
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
      } else {
        var response = await http.post(urlPost, headers: {'auth-token': token});

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          if (jsonData.containsKey('success') && jsonData['success'] == true) {
            message = jsonData['message'];

            var urlPrint = Uri.parse(
                '$urlBasic/ideia/prevenda/impressaocompleta/$prevendaid');
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
                  'Pedido finalizado!',
                  style: TextStyle(
                    fontSize: Style.SaveUrlMessageSize(context),
                    color: Style.tertiaryColor,
                  ),
                ),
                backgroundColor: Style.sucefullColor,
              ),
            );

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
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
      }
    } catch (e) {
      print('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message.toString()};
  }
}
