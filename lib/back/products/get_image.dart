import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:styles/widths.dart';

class TelaExibicaoImagem extends StatefulWidget {
  final Uint8List? imagemBlobVindaDoBanco;
  final String url;
  final String imagem;

  const TelaExibicaoImagem({
    super.key,
    this.imagemBlobVindaDoBanco,
    required this.url,
    required this.imagem,
  });

  @override
  State<TelaExibicaoImagem> createState() => _TelaExibicaoImagemState();
}

class _TelaExibicaoImagemState extends State<TelaExibicaoImagem> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = buscarImagemBytes();
  }

  Future<Uint8List?> buscarImagemBytes() async {
    // Se vier do banco em bytes válidos, use diretamente
    if (widget.imagemBlobVindaDoBanco != null && widget.imagemBlobVindaDoBanco!.isNotEmpty) {
      return widget.imagemBlobVindaDoBanco;
    }

    try {
      final uri = Uri.parse('${widget.url}/ideia/core/getimageserver/${widget.imagem}');
      final response = await http.get(uri, headers: {'Accept': 'text/html'});

      if (response.statusCode == 200) {
        // Transforma os bytes UTF-8 corrompidos do HTTP em texto legível do Dart
        final conteudoTexto = utf8.decode(response.bodyBytes);
        // Converte o texto contendo os caracteres especiais de volta para a estrutura binária limpa da imagem
        return converterStringParaBytesWin1252(conteudoTexto);
      }
      debugPrint('Erro HTTP ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Erro na requisição: $e');
      return null;
    }
  }

  // 1. Função utilitária para reverter o mapeamento Windows-1252
  Uint8List converterStringParaBytesWin1252(String texto) {
    final bytes = Uint8List(texto.length);

    for (int i = 0; i < texto.length; i++) {
      final codeUnit = texto.codeUnitAt(i);

      if (codeUnit <= 127 || (codeUnit >= 160 && codeUnit <= 255)) {
        bytes[i] = codeUnit;
      } else {
        switch (codeUnit) {
          case 0x20AC:
            bytes[i] = 128;
            break; // €
          case 0x201A:
            bytes[i] = 130;
            break; // ‚
          case 0x0192:
            bytes[i] = 131;
            break; // ƒ
          case 0x201E:
            bytes[i] = 132;
            break; // „
          case 0x2026:
            bytes[i] = 133;
            break; // …
          case 0x2020:
            bytes[i] = 134;
            break; // †
          case 0x2021:
            bytes[i] = 135;
            break; // ‡
          case 0x02C6:
            bytes[i] = 136;
            break; // ˆ
          case 0x2030:
            bytes[i] = 137;
            break; // ‰
          case 0x0160:
            bytes[i] = 138;
            break; // Š
          case 0x2039:
            bytes[i] = 139;
            break; // ‹
          case 0x0152:
            bytes[i] = 140;
            break; // Œ
          case 0x017D:
            bytes[i] = 142;
            break; // Ž
          case 0x2018:
            bytes[i] = 145;
            break; // ‘
          case 0x2019:
            bytes[i] = 146;
            break; // ’
          case 0x201C:
            bytes[i] = 147;
            break; // “
          case 0x201D:
            bytes[i] = 148;
            break; // ”
          case 0x2022:
            bytes[i] = 149;
            break; // •
          case 0x2013:
            bytes[i] = 150;
            break; // –
          case 0x2014:
            bytes[i] = 151;
            break; // —
          case 0x02DC:
            bytes[i] = 152;
            break; // ˜
          case 0x2122:
            bytes[i] = 153;
            break; // ™
          case 0x0161:
            bytes[i] = 154;
            break; // š
          case 0x203A:
            bytes[i] = 155;
            break; // ›
          case 0x0153:
            bytes[i] = 156;
            break; // œ
          case 0x017E:
            bytes[i] = 158;
            break; // ž
          case 0x0178:
            bytes[i] = 159;
            break; // Ÿ
          default:
            bytes[i] = codeUnit <= 255 ? codeUnit : 63;
        }
      }
    }
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.hide_image_rounded,
                size: Responsive.h(context, 50), /*color: Colors.grey*/
              ),
              // Text('Sem imagem', style: TextStyle(color: Colors.grey)),
            ],
          );
        }

        final bytesDaImagem = snapshot.data!;
        return Image.memory(
          bytesDaImagem,
          fit: BoxFit.cover,
          height: Responsive.h(context, 50),
          errorBuilder: (context, error, stackTrace) {
            log(error.toString());
            return Center(
              child: Icon(Symbols.hide_image_rounded, size: Responsive.h(context, 50)),
            );
          },
        );
      },
    );
  }
}
