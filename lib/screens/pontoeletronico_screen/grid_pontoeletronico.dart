import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/ferias.dart';
import 'package:projeto_aucs/models/periodos.dart';
import 'package:projeto_aucs/models/sp8010.dart';
import 'package:projeto_aucs/models/srh010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/add_screen/add_pontoeletronico_screen.dart';
import 'package:projeto_aucs/screens/pontoeletronico_screen/pontoEletronico_screen_list.dart';
import 'package:projeto_aucs/services/ferias_service.dart';
import 'package:projeto_aucs/services/periodo_service.dart';
import 'package:projeto_aucs/services/sp8010_service.dart';
import 'package:projeto_aucs/services/srh010_service.dart';
import 'package:projeto_aucs/services/sze010_falta_dias_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PontoEletronico extends StatefulWidget {
  final Sze010FaltaDias? sze010;
  final bool isloading;

  const PontoEletronico({
    Key? key,
    this.sze010,
    required this.isloading,
  }) : super(key: key);

  @override
  State<PontoEletronico> createState() => _PontoEletronicoState();
}

class _PontoEletronicoState extends State<PontoEletronico> {
  Sze010FaltaDias? sze010;
  String userId = '';
  String nomeColaborador = '';
  final Sze010Service _sze010service = Sze010Service();
  final PeriodoService _periodosService = PeriodoService();
  final Sp8010Service _sp8010Service = Sp8010Service();
  final FeriasService _feriasService = FeriasService();
  final Sze010Service _colaboradoresService = Sze010Service();
  final Srh010Service _feriasColaboradorService = Srh010Service();
  final Srh010FaltaDiasService _srh010FaltaDiasService =
      Srh010FaltaDiasService();
  Map<String, FeriasSze> databaseFerias = {};
  Map<String, Sze010> databaseColaboradores = {};
  Map<String, Sze010> databaseSze = {};
  Map<String, Sze010FaltaDias> databaseFaltaDias = {};
  Map<String, Periodos> databasePeriodos = {};
  Map<int, Sp8010> databasePonto = {};
  Map<String, Sp8010> databasePontoSintetico = {};
  Map<String, Srh010> databasePeriodosColaborador = {};
  List<TableRow> tableContainer = [];
  List<TableRow> tableContainerPeriodos = [];
  List<ListTile> listTile = [];
  bool _isloading = false;
    TextEditingController inicioController = TextEditingController();
  TextEditingController fimController = TextEditingController();
  DateTime? pickedDateFim;
  DateTime? pickedDateInicio;
  var departamento;
  List<String> name = [];
  bool _isSearchReady = false;
  bool _showSearch = false;
  String returnSearch = 'Realize sua pesquisa.';
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    getSze010();
    refreshFerias();
    getPeriodos();
    _isloading = widget.isloading;
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController _listScrollController = ScrollController();
    DateTime lastDate = DateTime.now().add(const Duration(days: 10));
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 90));
    var deviceData = MediaQuery.of(context);
    double width_screen = deviceData.size.width;
    return (!_isloading)
        ? DefaultTabController(
            length: 2, // This is the number of tabs.
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      titleTextStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      )),
                      backgroundColor: Colors.greenAccent,
                      title: const Text(
                        'Ponto Eletronico',
                        textAlign: TextAlign.center,
                      ),
                      pinned: true,
                      floating: true,
                      bottom: TabBar(
                        labelStyle: GoogleFonts.acme(
                            textStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 23,
                        )),
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        unselectedLabelStyle: GoogleFonts.acme(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                        tabs: const [
                          Tab(
                            text: 'Registrar',
                          ),
                          Tab(
                            text: 'Consulta',
                          ),
                        ],
                      ),
                    ),
                  ];
                },
                body: SizedBox(
                  height: 400,
                  width: width_screen,
                  child: TabBarView(
                    children: <Widget>[
                      const AddPontoEletronicoScreen(
                        isLoading: true,
                      ),
                      SingleChildScrollView(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: width_screen - 30,
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14.0),
                                        child: TextField(
                                            controller: inicioController,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            decoration: const InputDecoration(
                                              labelText: "Data Inicial: ",
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              pickedDateInicio =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: initialDate,
                                                lastDate: lastDate,
                                              );

                                              if (pickedDateInicio != null) {
                                                String formattedDate =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(
                                                            pickedDateInicio!);

                                                setState(() {
                                                  inicioController.text =
                                                      formattedDate;
                                                });
                                              } else {
                                                String formattedDate =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(initialDate);

                                                setState(() {
                                                  formattedDate; //set foratted date to TextField value.
                                                });
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 14.0),
                                        child: TextField(
                                            controller: fimController,
                                            style:
                                            const TextStyle(fontSize: 18),
                                            decoration: const InputDecoration(
                                              labelText: "Data Final: ",
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              pickedDateFim =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: initialDate,
                                                lastDate: lastDate,
                                              );

                                              if (pickedDateFim != null) {
                                                String formattedDate =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(
                                                    pickedDateFim!);

                                                setState(() {
                                                  fimController.text =
                                                      formattedDate;
                                                });
                                              } else {
                                                String formattedDate =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(initialDate);

                                                setState(() {
                                                  formattedDate; //set foratted date to TextField value.
                                                });
                                              }
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                'Colaborador',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(left: 8.0),
                                              child: DropdownButton<String>(
                                                value: departamento,
                                                icon: const Icon(
                                                    Icons.arrow_downward),
                                                elevation: 16,
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.deepPurple,
                                                    fontSize: 16),
                                                items: name.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: SizedBox(
                                                      width: width_screen - 100,
                                                      child: Text(
                                                        value,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? value) {
                                                  // This is called when the user selects an item.
                                                  setState(() {
                                                    departamento = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0, bottom: 2),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.greenAccent),
                                          ),
                                          onPressed: () {
                                            search();
                                          },
                                          child: Text(
                                            'Pesquisar',
                                            style: GoogleFonts.acme(
                                              textStyle:
                                                  const TextStyle(fontSize: 30),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ), // Inicio Ferias
                                ),
                                (_isSearchReady)
                                    ? (_showSearch)
                                      ? SizedBox(
                                          width: width_screen - 20,
                                          height: 500,
                                          child: ListView(
                                            physics: const NeverScrollableScrollPhysics(),
                                              controller: _listScrollController,
                                              children: generateListPontoEletronicoCards(
                                                databaseSintetico: databasePontoSintetico,
                                                database: databasePonto,
                                              ),
                                            ),
                                        )
                                      : const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ],
                                        )
                                    : SizedBox(
                                        width: width_screen - 150,
                                        height: 200,
                                        child: Text(
                                          returnSearch,
                                          style: GoogleFonts.acme(
                                            textStyle: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
  }

  void search() {
    setState(() {
      if (fimController.text != '' && inicioController.text != '') {
        getPonto();
        _isSearchReady = true;
      } else {
        returnSearch = 'Os campos Data Inicial e\nData Final não podem\n'
            'ficar em branco.';
      }
    });
  }

  void getPonto() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');

      if (firstName != null && lastName != null) {
        String matricula = '';
        String inicio = inicioController.text.substring(6, 10) +
          inicioController.text.substring(3, 5) +
          inicioController.text.substring(0, 2);
        String fim = fimController.text.substring(6, 10) +
          fimController.text.substring(3, 5) +
          fimController.text.substring(0, 2);

        if(mounted){
          setState(() {
            _showSearch = false;
          });
        }

        databaseSze.forEach((key, value) {
          if (value.ze_nome.trim() == departamento) {
            matricula = value.ze_mat;
          }
        });

        _sp8010Service.searchColaborador(matricula, inicio, fim).then((List<Sp8010> listSp8010) {
          setState(() {
            databasePonto = {};
            for (Sp8010 sp8010 in listSp8010) {
              databasePonto[sp8010.r_e_c_n_o_field] = sp8010;
              databasePontoSintetico[sp8010.p8_data] = sp8010;
            }
            _showSearch = true;
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  void refreshFerias() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');
      String id = '';

      if (firstName != null && lastName != null) {
        _colaboradoresService.getAll().then((List<Sze010> listColaboradores) {
          setState(() {
            databaseColaboradores = {};
            for (Sze010 colaborador in listColaboradores) {
              databaseColaboradores[colaborador.ze_mat] = colaborador;
            }
          });
        });

        _feriasService.getAll().then((List<FeriasSze> listFerias) {
          setState(() {
            userId = id;
            databaseFerias = {};
            for (FeriasSze ferias in listFerias) {
              databaseFerias[ferias.r_e_c_n_o_field.toString()] = ferias;
            }

            databaseFerias.forEach((key, value) {
              databaseColaboradores.forEach((keyColab, valueColab) {
                if (value.rh_mat == valueColab.ze_mat) {
                  nomeColaborador = valueColab.ze_nome.trim();
                }
              });
            });
          });
        });

        databaseFerias.forEach((key, value) {});
        _colaboradoresService.getAll().then((List<Sze010> listColaboradores) {
          setState(() {
            userId = id;
            databaseColaboradores = {};
            for (Sze010 colaborador in listColaboradores) {
              databaseColaboradores[colaborador.ze_nome] = colaborador;
            }
          });
        });
        _srh010FaltaDiasService
            .getAll()
            .then((List<Sze010FaltaDias> listSze010FaltaDias) {
          setState(() {
            databaseFaltaDias = {};
            userId = prefs.getString('id')!;
            for (Sze010FaltaDias sze010 in listSze010FaltaDias) {
              databaseFaltaDias[sze010.ze_nome] = sze010;
            }

            databaseFaltaDias.forEach((key, value) {
              if (userId == value.ze_mat) {
                sze010 = value;
              }
            });
            _isloading = false;
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  void getPeriodos() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');
      String? id = prefs.getString('id');

      if (firstName != null && lastName != null) {
        _periodosService.getId(id!).then((List<Periodos> listPeriodos) {
          setState(() {
            databasePeriodos = {};
            for (Periodos periodos in listPeriodos) {
              databasePeriodos[periodos.rf_databas] = periodos;
            }

            databasePeriodos.forEach((key, value) {
              _feriasColaboradorService
                  .getAll(value.rf_mat, value.rf_databas)
                  .then((List<Srh010> listPeriodoColaborador) {
                if(mounted){
                  setState(() {
                    userId = id;
                    databasePeriodosColaborador = {};
                    for (Srh010 feriasColaborador in listPeriodoColaborador) {
                      databasePeriodosColaborador[feriasColaborador.rh_dataini] =
                          feriasColaborador;
                    }

                    databasePeriodosColaborador.forEach((key, value) {});
                    _isloading = false;
                  });
                }
              });
            });
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }

  void getSze010() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');
      String? id = prefs.getString('id');
      String? group = prefs.getString('group');

      if (firstName != null &&
          lastName != null &&
          id != null &&
          group != null) {
        _sze010service.getId(id).then((List<Sze010> listSze010) {
          if (mounted) {
            setState(() {
              depto = '';
              for (Sze010 sze010 in listSze010) {
                depto = sze010.ze_depto;
              }
            });
          }
        });

        _sze010service.getAll().then((List<Sze010> listSze010) {
          if (mounted) {
            setState(() {
              for (Sze010 sze010 in listSze010) {
                if (group == '1') {
                  name.add(sze010.ze_nome.trim());
                } else if(group == '2') {
                  if (sze010.ze_depto == depto) {
                    name.add(sze010.ze_nome.trim());
                  }
                } else if(group == '3'){
                  if(id == sze010.ze_mat){
                    name.add(sze010.ze_nome.trim());
                  }
                }
                databaseSze[sze010.ze_mat] = sze010;
              }

              departamento = name.first;
              _isloading = false;
            });
          }
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}
