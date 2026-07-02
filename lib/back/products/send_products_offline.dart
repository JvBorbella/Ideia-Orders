import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:projeto/back/check_internet.dart';
import 'package:projeto/back/offline/functions/get_token.dart';
import 'package:projeto/back/products/add_product.dart';
import 'package:projeto/back/products/rm_product.dart';
import 'package:projeto/back/save_list.dart';
import 'package:http/http.dart' as http;
import 'package:projeto/front/components/global/elements/message.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class DataServiceSendProductsOff {
  Future<void> sendDataProducts(
    String urlBasic,
    String prevendaId,
    String localId,
    String empresaId,
    String tabelaprecoId,
    BuildContext context, {
    bool isBackground = false,
  }) async {
    final checkInternet = await hasInternetConnection();
    final allProducts = await recuperarListaProdutosPedido(localId);
    var productsOffline = allProducts.where((e) => e.flagSync == 0).toList();

    final produtosParaRemocao = await recuperarProdutosParaRemocao(localId);

    if (checkInternet && prevendaId.isNotEmpty) {
      try {
        if (!isBackground && context.mounted) {
          // Message.showReturnOverlay(
          //     context,
          //     const Color.fromARGB(255, 100, 100, 100),
          //     Icons.error,
          //     'Sincronizando Produtos e dados de clientes offline');
          // showDialog(
          //   context: context,
          //   barrierDismissible: false,
          //   builder: (context) => const AlertDialog(
          //     title: Text('Sincronizando dados offline'),
          //     content:
          //         Text('Enviando dados locais para a pré-venda no servidor...'),
          //   ),
          // );
        }
        final token = await GetToken.getToken();
        for (var product in productsOffline) {
          log('Enviando produto ${product.codigoproduto} para o servidor');
          var urlGet = Uri.parse(
              '''$urlBasic/ideia/core/getdata/produto%20p%20INNER%20JOIN%20produtoestoque%20pe%20ON%20pe.produto_id%20=%20p.produto_id%20INNER%20JOIN%20empresa%20e%20ON%20e.empresa_id%20=%20'$empresaId'%20WHERE%20(p.eantributavel%20=%20'${product.ean}'%20OR%20p.codigo%20=%20'${product.codigoproduto}'%20OR%20p.nome%20LIKE%20'${product.nomeproduto}')%20AND%20pe.empresa_id%20=%20'$empresaId'%20AND%20pe.estoque_id%20=%20e.estoque_id/''');
          try {
            var response =
                await http.get(urlGet, headers: {'Accept': 'text/html'});

            if (response.statusCode == 200) {
              var data = jsonDecode(response.body);
              var dynamicKey = data['data'].keys.first;
              var dataList = data['data'][dynamicKey];
              final produtoId = dataList[0]['produto_id'];
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              bool savedPermPedidoEstoqueNegativo =
                  sharedPreferences.getBool('pedidoEstoqueNegativo') ?? false;
              int savedFlagPrivilegiado =
                  sharedPreferences.getInt('flagprivilegiado') ?? 0;
              if (context.mounted) {
                if (dataList[0]['quantidade'] <= 0 &&
                    savedPermPedidoEstoqueNegativo != true &&
                    savedFlagPrivilegiado != 1) {
                  Message.showReturnOverlay(
                      context,
                      ColorsApp.errorColor,
                      Icons.error,
                      'Produto ${dataList[0]['codigo']} - ${dataList[0]['nome']} com estoque zerado ou negativo');
                } else {
                  await DataServiceAddProduct.sendDataOrder(
                      context,
                      urlBasic,
                      token,
                      prevendaId,
                      empresaId,
                      produtoId,
                      '',
                      product.quantidade.toString(),
                      1,
                      0,
                      product.expedicaoId ?? '');
                  await atualizarStatusItem(product.prevendaprodutoid, localId);
                }
              }

              // await removerItemProduto(
              //     product.prevendaprodutoid, product.localId ?? '');
            } else {
              log('Produto não encontrado ${response.body}');
            }
          } catch (e) {
            log('$e');
          }
        }
        for (final item in produtosParaRemocao) {
          final prevendaProdutoId = item['prevendaproduto_id'] as String;
          if (context.mounted) {
            await DataServiceRmProduct.sendDataOrder(
              context,
              urlBasic,
              token,
              prevendaId,
              prevendaProdutoId,
            );
          }
          // garante que também é removido da lista local de produtos
          await removerItemProduto(prevendaProdutoId, localId);
          await limparProdutosParaRemocao(localId);
        }

        // if (productsOffline.isNotEmpty) {
        //   await limparListaProdutosPedido(localId);
        // }
        // await limparProdutosParaRemocao(localId);
        if (!isBackground && context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        log('$e');
      }
    } else if (prevendaId.isEmpty) {
      if (!isBackground && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Responsive.h(context, 8)),
            content: Text(
              'Faça o envio do pedido antes de enviar o produto',
              style: TextStyle(
                fontSize: Responsive.h(context, 10),
                color: ColorsApp.tertiaryColor,
              ),
            ),
            backgroundColor: ColorsApp.warningColor,
          ),
        );
      }
    } else {
      if (!isBackground && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: EdgeInsets.all(Responsive.h(context, 8)),
            content: Text(
              'Sem conexão com a internet. Verifique sua conexão e tente novamente.',
              style: TextStyle(
                fontSize: Responsive.h(context, 10),
                color: ColorsApp.tertiaryColor,
              ),
            ),
            backgroundColor: ColorsApp.warningColor,
          ),
        );
      }
    }
  }
}
