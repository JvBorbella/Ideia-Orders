import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';

class PdfPrintService {
  static final _barcode = Barcode.code128();

  /// Gera e imprime o PDF diretamente (usando Mopria/Print Service)
  static Future<void> generateAndPrintPdf(
      {required String message, required String numero}) async {
    final RobotoMono = pw.Font.ttf(
        await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'));

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text(
            message,
            style: pw.TextStyle(fontSize: 24, font: RobotoMono),
          ),
          pw.Text(
            '',
            style: pw.TextStyle(fontSize: 24, font: RobotoMono),
          ),
          pw.SizedBox(height: 20),
        ],
        footer: (context) => pw.Center(
          child: pw.BarcodeWidget(
            data: 'PV$numero',
            barcode: _barcode,
            width: 300,
            height: 110,
          ),
        ),
      ),
    );

    // Salvar o PDF localmente (opcional)
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/prevenda.pdf');
    await file.writeAsBytes(await pdf.save());

    // Abrir caixa de impressão nativa
    await Printing.layoutPdf(
      onLayout: (format) async => await pdf.save(),
    );
  }
}
