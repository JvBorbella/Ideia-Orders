import 'package:flutter/material.dart';
import 'package:projeto/Back/Profiles-Requisitions.dart';
import 'package:projeto/Front/components/Global/Elements/Navbar-Button.dart';
import 'package:projeto/Front/components/Global/Elements/liberation-button.dart';
import 'package:projeto/Front/components/Solicitations/Elements/Text-Solicitacion.dart';
import 'package:projeto/Front/components/Solicitations/Elements/deleteButton.dart';
import 'package:projeto/Front/components/Solicitations/Elements/informations.dart';
import 'package:projeto/Front/components/Global/Estructure/navbar.dart';
import 'package:projeto/Front/components/Global/Estructure/requisition-card.dart';
import 'package:projeto/Front/components/Style.dart';
import 'package:projeto/Front/pages/home.dart';

class Solicitacion extends StatefulWidget {
  final token;
  final String url;
  final String urlBasic;

  const Solicitacion({
    Key? key,
    this.token,
    this.url = '',
    this.urlBasic = '',
  }) : super(key: key);

  @override
  State<Solicitacion> createState() => _SolicitacionState();
}

class _SolicitacionState extends State<Solicitacion> {
  List<Usuarios> usuarios = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
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
          onRefresh: _refreshData,
          child: usuarios.isEmpty
              ? Column(
                  children: [
                    Navbar(children: [
                      ButtonNavbar(
                        destination: Home(
                          url: widget.url,
                          token: widget.token,
                        ),
                        Icons: Icons.arrow_back_ios_new,
                      ),
                    ], text: 'Solicitações'),
                    Expanded(
                        child: Center(
                      child: Text(
                        'Não há mais solicitações!',
                        style: TextStyle(
                          color: Style.quarantineColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                  ],
                )
              : ListView(
                  children: [
                    Navbar(children: [
                      ButtonNavbar(
                        destination: Home(
                          url: widget.url,
                          token: widget.token,
                        ),
                        Icons: Icons.arrow_back_ios_new,
                      ),
                    ], text: 'Solicitações'),
                    SizedBox(
                      height: Style.ContentInternalSpace,
                    ),
                    Spacer(),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: usuarios.length,
                      itemBuilder: (context, index) {
                        TextEditingController _textController =
                            TextEditingController();
                        _textController.text = '';
                        return RequisitionCard(
                          children: [
                            Container(
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Informations(
                                              empresaNome:
                                                  usuarios[index].empresaNome,
                                              usuarioLogin:
                                                  usuarios[index].usuarioLogin,
                                              imagem: usuarios[index].imagem,
                                              urlBasic: widget.urlBasic,
                                            ),
                                            Delete(onPressed: () async {
                                              await RejectRequisition
                                                  .rejectrequisition(
                                                context,
                                                widget.url,
                                                widget.token,
                                                usuarios[index]
                                                    .liberacaoremotaId,
                                                _textController.text,
                                              );
                                            } // Usando o valor
                                                )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Style.ContentInternalSpace,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextSolicitacion(
                                            text: usuarios[index].mensagem,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              label: Text('Resposta'),
                                              floatingLabelAlignment:
                                                  FloatingLabelAlignment.center,
                                            ),
                                            controller: _textController,
                                          ),
                                          // child: Input(
                                          //   text: 'Resposta',
                                          //   type: TextInputType.text,
                                          //   controller:
                                          //       _textController, // Usando um controlador diferente para cada campo de entrada
                                          // ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Style.ContentInternalButtonSpace,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        LiberationButtom(
                                            text: 'Autorizar',
                                            onPressed: () async {
                                              if (_textController
                                                  .text.isEmpty) {
                                                await AcceptRequisition
                                                    .acceptrequisition(
                                                  context,
                                                  widget.url,
                                                  widget.token,
                                                  usuarios[index]
                                                      .liberacaoremotaId,
                                                  _textController.text,
                                                );
                                              }
                                              await AcceptRequisition
                                                  .acceptrequisition(
                                                context,
                                                widget.url,
                                                widget.token,
                                                usuarios[index]
                                                    .liberacaoremotaId,
                                                _textController.text,
                                              );
                                            } // Usando o valor do controlador específico
                                            ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    await fetchDatausuarios();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
      usuarios.clear(); // Limpa a lista de usuários antes de recarregar
    });
    await loadData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchDatausuarios() async {
    List<Usuarios>? fetchedDataUsuarios =
        await DataServiceUsuarios.fetchDataUsuarios(widget.token, widget.url);

    if (fetchedDataUsuarios != null) {
      setState(() {
        usuarios = fetchedDataUsuarios;
      });
    }
  }
}
