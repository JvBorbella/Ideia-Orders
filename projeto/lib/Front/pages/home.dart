import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto/Back/Today-Data.dart';
import 'package:projeto/Back/Value-Day.dart';
import 'package:projeto/Back/Value-Month.dart';
import 'package:projeto/Back/Value-Week.dart';
import 'package:projeto/Back/Yesterday-Data.dart';
import 'package:projeto/Front/components/Home/Elements/Conteudo-FilialCard.dart';
import 'package:projeto/Front/components/Home/Elements/ModalButtom.dart';
import 'package:projeto/Front/components/Home/Elements/TextButton.dart';
import 'package:projeto/Front/components/Home/Requisitions/Buttons/requisition-button.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Home/Requisitions/Elements/number-requisition.dart';
import 'package:projeto/Front/components/Global/Estructure/requisition-card.dart';
import 'package:projeto/Front/components/Home/Requisitions/Elements/text-requisition.dart';
import 'package:projeto/Front/components/Home/Estructure/total-card.dart';
import 'package:projeto/Front/components/Home/Estructure/filial-card.dart';
import 'package:projeto/Front/components/Style.dart';

class Home extends StatefulWidget {
  final token;
  final String url;
  final String urlBasic;

  const Home({
    Key? key,
    this.token,
    this.url = '',
    this.urlBasic = '',
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String urlController = '';
  List<MonitorVendasEmpresaHoje> empresasHoje = [];
  List<MonitorVendasEmpresaOntem> empresasOntem = [];
  List<MonitorVendasEmpresaSemana> empresasSemana = [];
  List<MonitorVendasEmpresaMes> empresasMes = [];
  late double vendadia = 0.0;
  late double vendadiaanterior = 0.0;
  late double vendasemana = 0.0;
  late double vendames = 0.0;
  // late int ticketHoje = -1;
  // late int ticketOntem = -1;
  late int solicitacoesremotas = -1;
  // Valor padrão de carregamento
  bool isLoading = true;
  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    loadData();
    fetchDataSemana();
    fetchDataMes();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () => _refreshData(),
          child: ListView(
            children: [
              Navbar(
                children: [
                  NavbarButton(),
                ],
                text: 'Página inicial',
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total de hoje',
                              style: TextStyle(
                                color: Style.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TotalCard(
                              text: '',
                              children: vendadia,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Total de ontem',
                              style: TextStyle(
                                color: Style.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TotalCard(
                              text: '',
                              children: vendadiaanterior,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Total da semana',
                              style: TextStyle(
                                color: Style.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TotalCard(
                              text: '',
                              children: vendasemana,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Total do mês',
                              style: TextStyle(
                                color: Style.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TotalCard(
                              text: '',
                              children: vendames,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              RequisitionCard(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: solicitacoesremotas <= 0
                                    ? EdgeInsets.only(left: 30)
                                    : EdgeInsets.all(0),
                              ),
                              Text(
                                'Requisições',
                                style: TextStyle(
                                    color: Style.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              NumberOfRequisitions(
                                  solicitacoesremotas: solicitacoesremotas),
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              TextRequisition(
                                solicitacoesremotas: solicitacoesremotas,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RequisitionButtom(
                                text: 'Liberação remota',
                                solicitacoesremotas: solicitacoesremotas,
                                url: widget.url,
                                token: widget.token,
                                urlBasic: widget.urlBasic,
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: empresasHoje.length,
                itemBuilder: (context, index) {
                  // Verifica se empresasOntem possui elementos antes de acessá-los
                  if (index < empresasOntem.length) {
                    return Column(
                      children: [
                        FilialCard(
                          children: [
                            Column(
                              children: [
                                if (empresasSemana.isNotEmpty &&
                                    empresasMes.isNotEmpty)
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasHoje[index].empresaNome,
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                    ticketHoje:
                                        empresasHoje[index].ticketHoje.toInt(),
                                    ticketOntem: empresasOntem[index]
                                        .ticketOntem
                                        .toInt(),
                                  )
                                else
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasHoje[index].empresaNome,
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana: 0,
                                    valorMes: 0,
                                    ticketHoje:
                                        empresasHoje[index].ticketHoje.toInt(),
                                    ticketOntem: empresasOntem[index]
                                        .ticketOntem
                                        .toInt(),
                                  ),
                                if (empresasSemana.isNotEmpty &&
                                    empresasMes.isNotEmpty)
                                  ConteudoFilialCard(
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                  )
                                else
                                  ConteudoFilialCard(
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana: 0,
                                    valorMes: 0,
                                  )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        FilialCard(
                          children: [
                            Column(
                              children: [
                                if (empresasSemana.isNotEmpty &&
                                    empresasMes.isNotEmpty)
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasHoje[index].empresaNome,
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: 0,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                    ticketHoje:
                                        empresasHoje[index].ticketHoje.toInt(),
                                    ticketOntem: 0,
                                  )
                                else
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasHoje[index].empresaNome,
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: 0,
                                    valorSemana: 0,
                                    valorMes: 0,
                                    ticketHoje:
                                        empresasHoje[index].ticketHoje.toInt(),
                                    ticketOntem: 0,
                                  ),
                                if (empresasSemana.isNotEmpty &&
                                    empresasMes.isNotEmpty)
                                  ConteudoFilialCard(
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: 0,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                  )
                                else
                                  ConteudoFilialCard(
                                    valorHoje: empresasHoje[index].valorHoje,
                                    valorOntem: 0,
                                    valorSemana: 0,
                                    valorMes: 0,
                                  )
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              if (empresasHoje.isEmpty)
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: empresasOntem.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FilialCard(
                            children: [
                              Column(
                                children: [
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasOntem[index].empresaNome,
                                    valorHoje: 0,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                    ticketHoje: 0,
                                    ticketOntem: empresasOntem[index]
                                        .ticketOntem
                                        .toInt(),
                                  ),
                                  ConteudoFilialCard(
                                    valorHoje: 0,
                                    valorOntem: empresasOntem[index].valorOntem,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              if (empresasHoje.isEmpty && empresasOntem.isEmpty)
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: empresasSemana.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FilialCard(
                            children: [
                              Column(
                                children: [
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome:
                                        empresasSemana[index].empresaNome,
                                    valorHoje: 0,
                                    valorOntem: 0,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                    ticketHoje: 0,
                                    ticketOntem: 0,
                                  ),
                                  ConteudoFilialCard(
                                    valorHoje: 0,
                                    valorOntem: 0,
                                    valorSemana:
                                        empresasSemana[index].valorSemana,
                                    valorMes: empresasMes[index].valorMes,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              if (empresasHoje.isEmpty &&
                  empresasOntem.isEmpty &&
                  empresasSemana.isEmpty)
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: empresasMes.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          FilialCard(
                            children: [
                              Column(
                                children: [
                                  TextBUtton(
                                    url: widget.url,
                                    token: widget.token,
                                    empresaNome: empresasMes[index].empresaNome,
                                    valorHoje: 0,
                                    valorOntem: 0,
                                    valorSemana: 0,
                                    valorMes: empresasMes[index].valorMes,
                                    ticketHoje: 0,
                                    ticketOntem: 0,
                                  ),
                                  ConteudoFilialCard(
                                    valorHoje: 0,
                                    valorOntem: 0,
                                    valorSemana: 0,
                                    valorMes: empresasMes[index].valorMes,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              if (empresasHoje.isEmpty &&
                  empresasOntem.isEmpty &&
                  empresasMes.isEmpty &&
                  empresasSemana.isEmpty)
                Center(
                  child: Text('Não há dados de vendas'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    // Utiliza Future.wait para buscar os dados de forma paralela
    await Future.wait([
      fetchData(),
      fetchDataOntem(),
      fetchDataValorHoje(),
      fetchDataRequisicoes(),
      // fetchDataSemana(),
      // fetchDataMes(),
    ]);
    // Todos os dados foram carregados, agora atualiza o estado para parar o carregamento
    setState(() {
      isLoading = false;
      // Verifica se os dados de solicitacoesremotas foram carregados corretamente
      if (solicitacoesremotas != -1) {
        solicitacoesremotas =
            NumberOfRequisitions(solicitacoesremotas: solicitacoesremotas)
                .solicitacoesremotas;
      }
      // else if (ticketHoje != -1) {
      //   ticketHoje = ticketHoje;
      // }
      // else if (ticketOntem != -1) {
      //   ticketOntem = ticketOntem;
      // }
    });
  }

  Future<void> _refreshData() async {
    // Aqui você pode chamar os métodos para recarregar os dados
    // Exemplo: await loadData();
    setState(() {
      isLoading =
          true; // Define isLoading como true para mostrar o indicador de carregamento
    });
    await loadData();
    setState(() {
      isLoading =
          false; // Define isLoading como false para parar o indicador de carregamento
    });
  }

  Future<void> fetchData() async {
    List<MonitorVendasEmpresaHoje>? fetchedData =
        await DataService.fetchData(widget.token, widget.url);

    if (fetchedData != null) {
      setState(() {
        empresasHoje = fetchedData;
      });
    }
  }

  Future<void> fetchDataOntem() async {
    List<MonitorVendasEmpresaOntem>? fetchedDataOntem =
        await DataServiceOntem.fetchDataOntem(widget.token, widget.url);

    if (fetchedDataOntem != null) {
      setState(() {
        empresasOntem = fetchedDataOntem;
      });
    }
  }

  Future<void> fetchDataSemana() async {
    List<MonitorVendasEmpresaSemana>? fetchedDataSemana =
        await DataServiceSemana.fetchDataSemana(widget.token, widget.url);

    if (fetchedDataSemana != null) {
      setState(() {
        empresasSemana = fetchedDataSemana;
      });
    }
  }

  Future<void> fetchDataMes() async {
    List<MonitorVendasEmpresaMes>? fetchedDataMes =
        await DataServiceMes.fetchDataMes(widget.token, widget.url);

    if (fetchedDataMes != null) {
      setState(() {
        empresasMes = fetchedDataMes;
      });
    }
  }

  Future<void> fetchDataValorHoje() async {
    Map<String, double?>? fetchedDataValorHoje =
        await DataServiceValorHoje.fetchDataValorHoje(widget.token, widget.url);

    // ignore: unnecessary_null_comparison
    if (fetchedDataValorHoje != null) {
      setState(() {
        vendadia = fetchedDataValorHoje['vendadia'] ?? 0.0;
        vendadiaanterior = fetchedDataValorHoje['vendadiaanterior'] ?? 0.0;
        vendasemana = fetchedDataValorHoje['vendasemana'] ?? 0.0;
        vendames = fetchedDataValorHoje['vendames'] ?? 0.0;
      });
    }
  }

  Future<void> fetchDataRequisicoes() async {
    int? fetchedDataRequisicoes =
        await DataServiceValorHoje.fetchDataRequisicoes(
            widget.token, widget.url);

    if (fetchedDataRequisicoes != null) {
      setState(() {
        solicitacoesremotas = fetchedDataRequisicoes;
      });
    }
  }
}
