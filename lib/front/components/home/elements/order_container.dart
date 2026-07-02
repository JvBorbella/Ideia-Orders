import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:styles/colors.dart';
import 'package:styles/widths.dart';

class OrderContainer extends StatefulWidget {
  final String nomepessoa, numero;
  final double? valortotal, valordesconto;
  final DateTime data;
  final int? flagpermitefaturar, flagSync, flagprocessado;

  const OrderContainer(
      {super.key,
      required this.valortotal,
      required this.data,
      required this.nomepessoa,
      required this.numero,
      this.flagpermitefaturar,
      this.valordesconto,
      this.flagSync,
      this.flagprocessado});

  @override
  State<OrderContainer> createState() => _OrderContainerState();
}

class _OrderContainerState extends State<OrderContainer> {
  double get valorfinal =>
      (widget.valortotal ?? 0.0) - (widget.valordesconto ?? 0.0);
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Responsive.h(context, 8)),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
          border: BorderDirectional(
              bottom: BorderSide(
                  width: Responsive.h(context, 0.5),
                  color: ColorsApp.quarantineColor),
              top: BorderSide(
                  width: Responsive.h(context, 0.5),
                  color: ColorsApp.quarantineColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Número',
                    style: TextStyle(
                      color: ColorsApp.quarantineColor,
                      fontSize: Responsive.h(context, 8),
                    ),
                  ),
                  Text(
                    widget.numero,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: Responsive.h(context, 10),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: Responsive.h(context, 12),
              ),
              Column(
                children: [
                  SizedBox(
                    width: Responsive.w(context, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cliente',
                          style: TextStyle(
                            color: ColorsApp.quarantineColor,
                            fontSize: Responsive.h(context, 8),
                          ),
                        ),
                        Text(
                          widget.nomepessoa,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: Responsive.h(context, 10),
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Column(
              //   children: [
              //     if (widget.flagSync == 0)
              //       Icon(
              //         Icons.cloud_off,
              //         color: Colors.orange,
              //         size: Responsive.h(context, 15),
              //       ),
              //     if (widget.flagpermitefaturar == 1 &&
              //         widget.flagprocessado != 1)
              //       Icon(
              //         Symbols.sync_saved_locally,
              //         color: ColorsApp.sucefullColor,
              //         size: Responsive.h(context, 15),
              //       ),
              //     if (widget.flagprocessado == 1)
              //       Icon(
              //         Icons.check_circle_outline,
              //         color: ColorsApp.sucefullColor,
              //         size: Responsive.h(context, 15),
              //       )
              //   ],
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Valor',
                            style: TextStyle(
                              color: ColorsApp.quarantineColor,
                              fontSize: Responsive.h(context, 8),
                            ),
                          ),
                          Text(
                            currencyFormat.format(valorfinal),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Responsive.h(context, 10),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'Data',
                            style: TextStyle(
                              color: ColorsApp.quarantineColor,
                              fontSize: Responsive.h(context, 8),
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(widget.data),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: Responsive.h(context, 8),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  if (widget.flagSync == 0)
                    Text(
                      'Off-line',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: Responsive.h(context, 9),
                      ),
                    ),
                  if (widget.flagpermitefaturar == 1 &&
                      widget.flagprocessado != 1 && widget.flagSync != 0)
                    Text(
                      'Aguardando faturamento',
                      style: TextStyle(
                        color: ColorsApp.secondaryColor,
                        fontSize: Responsive.h(context, 9),
                      ),
                    ),
                  if (widget.flagprocessado == 1)
                    Text(
                      'Faturado',
                      style: TextStyle(
                        color: ColorsApp.sucefullColor,
                        fontSize: Responsive.h(context, 9),
                      ),
                    ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
