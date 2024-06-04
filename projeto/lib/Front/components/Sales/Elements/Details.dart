import 'package:flutter/material.dart';
import 'package:projeto/Front/components/Style.dart';

class Details extends StatefulWidget {
  final int ticketHoje;
  final int ticketOntem;

  const Details(
      {Key? key, 
      required this.ticketHoje,
       required this.ticketOntem});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Material(
        //Código dos valores adicionais do card de vendas
        child: Container(
            child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                //Estilização
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Style.primaryColor,
                ),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        'Hoje',
                        style: TextStyle(
                            color: Style.tertiaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Ticket md.',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '000,00',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Margem.',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '0,0%',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Participação.',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '0,0%',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Clientes.',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'Cupom.',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.ticketHoje.toString(),
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        //Estilização
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Style.primaryColor,
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                'Ontem',
                                style: TextStyle(
                                    color: Style.tertiaryColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Ticket md.',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '000,00',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Margem.',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '0,0%',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Participação.',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '0,0%',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Clientes.',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Cupom.',
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        widget.ticketOntem.toString(),
                                        style: TextStyle(
                                            color: Style.tertiaryColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                        //Campos e seus valores
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Column(
                        //           children: [
                        //             Text(
                        //               'Ticket md.',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             Text(
                        //               '000,00',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Column(
                        //           children: [
                        //             Text(
                        //               'Margem.',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             Text(
                        //               '0,0%',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Column(
                        //           children: [
                        //             Text(
                        //               'Participação.',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             Text(
                        //               '0,0%',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Column(
                        //           children: [
                        //             Text(
                        //               'Clientes.',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             Text(
                        //               '0',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ],
                        //         ),
                        //         SizedBox(
                        //           width: 10,
                        //         ),
                        //         Column(
                        //           children: [
                        //             Text(
                        //               'Cupom.',
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //             Text(
                        //               widget.ticket.toString(),
                        //               style: TextStyle(
                        //                   color: Style.tertiaryColor,
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.bold),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    )));
  }
}
