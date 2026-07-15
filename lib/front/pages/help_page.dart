import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projeto/front/components/global/elements/navbar_button.dart';
import 'package:projeto/front/components/global/structure/navbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            log('WebView started loading: $url');
          },
          onPageFinished: (String url) {
            log('WebView finished loading: $url');
          },
          onHttpError: (HttpResponseError error) {
            log('HTTP Error: $error');
          },
          onWebResourceError: (WebResourceError error) {
            log('Resource Error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          'https://bdc.ideiatecnologia.com.br/2024/06/18/pre-vendas-mobile/',
        ),
      ); // URL relevante para docs WebView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Navbar(
              text: 'Manual de uso',
              children: [NavbarButton(icons: Icons.arrow_back, back: true)],
            ),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  if (isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
