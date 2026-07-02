import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';
import 'package:share_plus/share_plus.dart';
import 'package:barcode/barcode.dart';
import 'package:http/http.dart' as http;

final GlobalKey<PdfGeneratorViewerState> pdfKey =
    GlobalKey<PdfGeneratorViewerState>();

class PdfGeneratorViewer extends StatefulWidget {
  final String? prevendaId, numero, urlBasic, token, vendedor, empresa;
  final double? valordesconto, valortotal;
  final List? products;

  const PdfGeneratorViewer({
    super.key,
    this.prevendaId,
    this.numero,
    this.urlBasic,
    this.token,
    this.vendedor,
    this.valordesconto,
    this.empresa,
    this.products,
    this.valortotal,
  });

  @override
  State<PdfGeneratorViewer> createState() => PdfGeneratorViewerState();
}

class PdfGeneratorViewerState extends State<PdfGeneratorViewer> {
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
        widget.urlBasic ?? '',
        widget.token ?? '',
        widget.prevendaId ?? '',
        widget.numero ?? '',
        widget.vendedor ?? '',
        widget.valordesconto ?? 0.0,
        widget.empresa ?? '',
        widget.products ?? [],
        widget.valortotal ?? 0.0);

    if (mounted) {
      setState(() {
        message = result['message'] ?? 'Mensagem não encontrada';
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateAndOpenPdf(widget.vendedor ?? '', widget.valordesconto ?? 0.0);
    });
    //generateAndOpenPdf();
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
      String vendedor,
      double valordesconto,
      String empresa,
      List<dynamic> products,
      double valortotal) async {
    String? message;

    final hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      final buffer = StringBuffer();
      buffer.writeln(empresa);
      buffer.writeln("");
      buffer.writeln("PEDIDO $numpedido");
      buffer.writeln("================================");
      buffer.writeln(
          "DATA: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())}");
      buffer.writeln("");
      buffer.writeln("PRODUTO UNIT QTDE TOTAL");
      buffer.writeln("--------------------------------");
      if (products.isEmpty) {
        buffer.writeln("Nenhum produto");
      } else {
        for (var product in products) {
          buffer.writeln(
              "${product.codigoproduto} ${product.nomeproduto} ${product.quantidade} ${product.valortotalitem}");
        }
      }
      buffer.writeln("--------------------------------");
      final totalLine =
          "TOTAL: ${toCurrencyString(valortotal.toString())} ".padLeft(32);
      buffer.writeln(totalLine);
      buffer.writeln("");
      message = buffer.toString();
    } else {
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
            Message.showReturnOverlay(context, ColorsApp.errorColor,
                Icons.error, 'Não foi possível recuperar este cupom');
          }
        } else {
          Message.showReturnOverlay(
              context, ColorsApp.errorColor, Icons.error, responsePrint.body);
        }
      } catch (e) {
        Message.showReturnOverlay(
            context, ColorsApp.errorColor, Icons.error, '$e');
      }
    }

    return {'message': message};
  }

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '');
  bool isLoadingButtonPDF = false;
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }

  // Função para gerar o PDF
  Future<void> generateAndOpenPdf(String vendedor, double valordesconto) async {
    final robotoMono = pw.Font.ttf(
        await rootBundle.load('assets/fonts/RobotoMono-Regular.ttf'));
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
                font: robotoMono,
              ),
            ),
            pw.Container(
              width: 450,
              child: pw.Text(
                'Desconto: ${currencyFormat.format(valordesconto)}',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  fontSize: 24,
                  font: robotoMono,
                ),
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Text(
              vendedor.isNotEmpty ? 'Vendedor - $vendedor' : '',
              style: pw.TextStyle(
                fontSize: 24,
                font: robotoMono,
              ),
            ),
            pw.SizedBox(height: 10),
            if (widget.numero != '')
              pw.BarcodeWidget(
                data: 'PV${widget.numero}',
                barcode: barcode,
                width: 300, // Largura do código de barras
                height: 110, // Altura do código de barras
              )
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

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;

          int count = 0;

          Navigator.popUntil(context, (route) {
            return count++ == 2;
          });
        },
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                // 🔹 TOPO (Navbar)
                Navbar(
                  text: 'Visualizador de PDF',
                  children: [
                    const NavbarButton(
                      back: true,
                      returnPageQnt: 2,
                      icons: Icons.arrow_back_ios_new,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: Responsive.h(context, 5),
                      ),
                      child: IconButton(
                        onPressed: () => sharePdf(),
                        icon: const Icon(
                          Icons.share,
                          color: ColorsApp.tertiaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                // 🔹 CORPO (PDF)
                Expanded(
                  child: PDFView(
                    filePath: filePath,
                  ),
                ),
              ],
            ),
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
