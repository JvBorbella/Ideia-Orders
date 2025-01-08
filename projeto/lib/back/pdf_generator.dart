import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:projeto/front/components/new_order/elements/register_icon_button.dart';
import 'package:projeto/front/components/product_page/elements/product_add.dart';
import 'package:projeto/front/components/style.dart';
import 'package:projeto/front/pages/order_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode/barcode.dart';
import 'package:http/http.dart' as http;

class PdfGeneratorViewer extends StatefulWidget {
  final prevenda_id;
  final numero;
  final urlBasic;
  final token;

  const PdfGeneratorViewer({
    super.key,
    this.prevenda_id,
    this.numero,
    this.urlBasic,
    this.token,
  });

  @override
  State<PdfGeneratorViewer> createState() => _PdfGeneratorViewerState();
}

class _PdfGeneratorViewerState extends State<PdfGeneratorViewer> {
  bool isLoading = true;
  final pdf = pw.Document();

  final barcode = Barcode.code128(); // Tipo de código de barras

  String? pdfFilePath;
  String message = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await fetchDataGeneratePdf(
      context,
      widget.urlBasic,
      widget.token,
      widget.prevenda_id,
      widget.numero,
    );

    if (mounted) {
      setState(() {
        message = result['message'] ?? 'Mensagem não encontrada';
      });
    }
    // generateAndOpenPdf();
    setState(() {
      isLoading = false;
    });
  }

  static Future<Map<String?, String?>> fetchDataGeneratePdf(
    BuildContext context,
    String urlBasic,
    String token,
    String prevendaid,
    String numpedido,
  ) async {
    String? message;

    try {
      var urlPrint =
          Uri.parse('$urlBasic/ideia/prevenda/impressao/$prevendaid');
      var responsePrint =
          await http.get(urlPrint, headers: {'auth-token': token});

      if (responsePrint.statusCode == 200) {
        var jsonData = json.decode(responsePrint.body);

        if (jsonData.containsKey('success') && jsonData['success'] == true) {
          message = jsonData['message'];
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(Style.SaveUrlMessagePadding(context)),
              content: Text(
                'Não foi possível recuperar este cupom',
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
        print('Erro ao carregar dados: ${responsePrint.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição OrderDetails: $e');
    }

    return {'message': message};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Style.height_250(context),
        child: pdfFilePath == null
            ? RegisterIconButton(
                text: 'Gerar PDF',
                color: Style.warningColor,
                width: Style.width_150(context),
                icon: Icons.description_rounded,
                onPressed: () {
                  // await fetchDataGeneratePdf(
                  //     context, urlBasic, token, widget.prevenda_id, widget.numero);
                  generateAndOpenPdf();
                })
            : RegisterIconButton(
                text: 'Visualizar PDF',
                color: Style.warningColor,
                width: Style.width_150(context),
                icon: Icons.description_rounded,
                onPressed: () {
                  openPdfViewer();
                }));
  }

  // Função para gerar o PDF
  Future<void> generateAndOpenPdf() async {
    final RobotoMono = pw.Font.ttf(await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'));
    final NotoSansMono = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSansMono-Regular.ttf'));
    final SpaceMono = pw.Font.ttf(await rootBundle.load('assets/fonts/SpaceMono-Regular.ttf'));
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text(
              message,
              // textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 24,
                font: RobotoMono, 
                ),
            ),
            pw.SizedBox(
                height: 20), // Espaçamento entre o texto e o código de barras
            pw.BarcodeWidget(
              data: 'PV${widget.numero}',
              barcode: barcode,
              width: 300, // Largura do código de barras
              height: 110, // Altura do código de barras
            ),
          ],
        ),
      ),
    );

    // Obter o diretório para salvar o PDF
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File('${outputDir.path}/Prevenda.pdf');
    await file.writeAsBytes(await pdf.save());

    setState(() {
      pdfFilePath = file.path;
    });

    // Abrir o PDF automaticamente após criar
    openPdfViewer();
  }

  // Função para abrir o visualizador de PDF
  void openPdfViewer() {
    if (pdfFilePath != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(filePath: pdfFilePath!),
        ),
      );
    }
  }
}

// Tela para visualizar o PDF
class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({required this.filePath});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Style.primaryColor,
        foregroundColor: Style.tertiaryColor,
        title: Text('Visualizador de PDF'),
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Style.tertiaryColor, fontSize: Style.height_15(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              sharePdf();
            },
          ),
        ],
      ),
      // backgroundColor: Style.quarantineColor,

      body: PDFView(
        filePath: filePath,
      ),
    ));
  }

  void sharePdf() {
    Share.shareXFiles(
      [XFile(filePath)],
      text: 'Confira este PDF!',
    );
  }
}
