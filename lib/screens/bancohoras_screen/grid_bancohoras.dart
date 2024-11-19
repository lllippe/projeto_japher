import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/ferias.dart';
import 'package:projeto_aucs/models/periodos.dart';
import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/models/sqb010.dart';
import 'package:projeto_aucs/models/srh010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/add_screen/add_bancohoras_screen.dart';
import 'package:projeto_aucs/screens/bancohoras_screen/bancoHoras_screen_list.dart';
import 'package:projeto_aucs/services/ferias_service.dart';
import 'package:projeto_aucs/services/periodo_service.dart';
import 'package:projeto_aucs/services/spi010_service.dart';
import 'package:projeto_aucs/services/sqb010_service.dart';
import 'package:projeto_aucs/services/srh010_service.dart';
import 'package:projeto_aucs/services/sze010_falta_dias_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class BancoHoras extends StatefulWidget {
  final Sze010FaltaDias? sze010;
  final bool isloading;

  const BancoHoras({
    Key? key,
    this.sze010,
    required this.isloading,
  }) : super(key: key);

  @override
  State<BancoHoras> createState() => _BancoHorasState();
}

class _BancoHorasState extends State<BancoHoras> {
  Sze010FaltaDias? sze010;
  String userId = '';
  String nomeColaborador = '';
  final Sze010Service _sze010service = Sze010Service();
  final PeriodoService _periodosService = PeriodoService();
  final FeriasService _feriasService = FeriasService();
  final Sze010Service _colaboradoresService = Sze010Service();
  final Srh010Service _feriasColaboradorService = Srh010Service();
  final Spi010Service _spi010service = Spi010Service();
  final Sqb010Service _sqb010service = Sqb010Service();
  final Srh010FaltaDiasService _srh010FaltaDiasService =
      Srh010FaltaDiasService();
  Map<String, FeriasSze> databaseFerias = {};
  Map<String, Sqb010> databaseSqb = {};
  Map<String, Sze010> databaseColaboradores = {};
  Map<String, Sze010> databaseSze = {};
  Map<String, Spi010> databaseBancoSintetico = {};
  Map<int, Spi010> databaseBanco = {};
  Map<String, Sze010FaltaDias> databaseFaltaDias = {};
  Map<String, Periodos> databasePeriodos = {};
  Map<String, Srh010> databasePeriodosColaborador = {};
  List<TableRow> tableContainer = [];
  List<TableRow> tableContainerPeriodos = [];
  List<ListTile> listTile = [];
  bool _isloading = false;
    TextEditingController inicioController = TextEditingController();
  TextEditingController fimController = TextEditingController();
  Spi010 spi010 = Spi010.empty();
  DateTime? pickedDateFim;
  DateTime? pickedDateInicio;
  var departamento;
  List<String> name = [];
  bool _isSearchReady = false;
  bool _showSearch = false;
  String returnSearch = 'Realize sua pesquisa.';
  int detail = 0;
  double saldoInicial = 0;
  double saldoFinal = 0;
  double saldoPeriodo = 0;
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
    DateTime lastDate = DateTime.now();
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
                        'Banco de Horas',
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
                            text: 'Adicionar',
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
                      AddBancoHorasScreen(
                        isLoading: true,
                        spi010: spi010,
                        isEditing: false,
                      ),
                      SingleChildScrollView(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: width_screen - 30,
                                  height: 250,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8),
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
                                            const EdgeInsets.only(left: 8),
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
                                                        .format(pickedDateFim!);

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
                                                      width: width_screen - 200,
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
                                            top: 2.0),
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
                                  ), // Inicio
                                ),
                                (_isSearchReady)
                                    ? (_showSearch)
                                      ? SizedBox(
                                        width: width_screen - 30,
                                        height: 70,
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: Text(
                                                  'Saldo Inicial: $saldoInicial',
                                                  style: GoogleFonts.acme(
                                                    textStyle: const TextStyle(
                                                        fontSize: 23,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.blue),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: true,
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: Text(
                                                'Saldo Final: ${saldoInicial + saldoPeriodo}',
                                                style: GoogleFonts.acme(
                                                  textStyle: const TextStyle(
                                                      fontSize: 23,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            ),
                                          ],
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
                                    : Container(),
                                (_isSearchReady)
                                    ? (_showSearch)
                                      ? SizedBox(
                                          width: width_screen - 20,
                                          height: 400,
                                          child: ListView(
                                            physics: const NeverScrollableScrollPhysics(),
                                            controller: _listScrollController,
                                            children: generateListBancoHorasCards(
                                              databaseSintetico:
                                                  databaseBancoSintetico,
                                              database: databaseBanco,
                                              titulo:
                                                  '${inicioController.text} a ${fimController.text}',
                                              detail: detail,
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
      saldoInicial = 0;
      saldoPeriodo = 0;
      if (fimController.text != '' && inicioController.text != '') {
        getBanco();
        _isSearchReady = true;
      } else {
        returnSearch = 'Os campos Data Inicial e\nData Final não podem\n'
            'ficar em branco.';
      }
    });
  }

  void getBanco() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');
      String? id = prefs.getString('id');
      String? group = prefs.getString('group');
      String depto = '';

      if (firstName != null && lastName != null) {
        String matricula = '';
        DateTime fimSaldo = DateTime(int.parse(inicioController.text.substring(6, 10)),
            int.parse(inicioController.text.substring(3, 5)),
            int.parse(inicioController.text.substring(0, 2))).subtract(const Duration(days: 1));
        String buscaSaldo = fimSaldo.toString().substring(0, 4) +
            fimSaldo.toString().substring(5, 7) +
            fimSaldo.toString().substring(8, 10);
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
          if (group == '1' || group == '2') {
            if (id == value.ze_mat) {
              depto = value.ze_depto;
            }
          }
        });

        if (group == '1') {
          _sqb010service.getAll().then((List<Sqb010> listSqb010) {
            setState(() {
              for (Sqb010 sqb010 in listSqb010) {
                if (departamento.trim() == sqb010.qb_descric.trim()) {
                  detail = 2;
                  depto = sqb010.qb_depto.trim();
                  _spi010service
                      .searchGestor(depto, inicio, fim)
                      .then((List<Spi010> listSpi010) {
                    setState(() {
                      databaseBanco = {};
                      databaseBancoSintetico = {};
                      saldoPeriodo = 0.0;
                      for (Spi010 spi010 in listSpi010) {
                        databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                        databaseBancoSintetico[spi010.pi_data] = spi010;
                      }
                      databaseBanco.forEach((key, value) {
                        saldoPeriodo += value.pi_quant;
                      });
                    });
                  });
                  _spi010service
                      .searchGestor(depto, '20230101', buscaSaldo)
                      .then((List<Spi010> listSpi010) {
                    setState(() {
                      saldoInicial = 0.0;
                      for (Spi010 spi010 in listSpi010) {
                        saldoInicial += spi010.pi_quant;
                      }
                    });
                  });
                  setState(() {
                    _showSearch = true;
                  });
                  break;
                } else if (departamento == 'TODOS') {
                  detail = 2;
                  _spi010service
                      .searchDiretor(inicio, fim)
                      .then((List<Spi010> listSpi010) {
                    setState(() {
                      databaseBanco = {};
                      databaseBancoSintetico = {};
                      saldoPeriodo = 0.0;
                      for (Spi010 spi010 in listSpi010) {
                        databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                        databaseBancoSintetico[spi010.pi_data] = spi010;
                      }
                      databaseBanco.forEach((key, value) {
                        saldoPeriodo += value.pi_quant;
                      });
                    });
                  });
                  _spi010service
                      .searchDiretor('20230101', buscaSaldo)
                      .then((List<Spi010> listSpi010) {
                    setState(() {
                      saldoInicial = 0.0;
                      for (Spi010 spi010 in listSpi010) {
                        saldoInicial += spi010.pi_quant;
                      }
                      _showSearch = true;
                    });
                  });
                } else {
                  detail = 1;
                  databaseSze.forEach((key, value) {
                    if (departamento.trim() == value.ze_nome.trim()) {
                      _spi010service
                          .searchColaborador(matricula, inicio, fim)
                          .then((List<Spi010> listSpi010) {
                        setState(() {
                          databaseBanco = {};
                          databaseBancoSintetico = {};
                          saldoPeriodo = 0.0;
                          for (Spi010 spi010 in listSpi010) {
                            databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                            databaseBancoSintetico[spi010.pi_data] = spi010;
                          }
                          databaseBanco.forEach((key, value) {
                            saldoPeriodo += value.pi_quant;
                          });
                        });
                      });
                      _spi010service
                          .searchColaborador(matricula, '20230101', buscaSaldo)
                          .then((List<Spi010> listSpi010) {
                        setState(() {
                          saldoInicial = 0.0;
                          for (Spi010 spi010 in listSpi010) {
                            saldoInicial += spi010.pi_quant;
                          }
                          _showSearch = true;
                        });
                      });
                    }
                  });
                }
              }
            });
          });
        } else if (group == '2') {
          if(mounted){
            setState(() {
              _showSearch = false;
            });
          }
          if (departamento == 'TODOS') {
            detail = 2;
            _spi010service
                .searchGestor(depto, inicio, fim)
                .then((List<Spi010> listSpi010) {
              setState(() {
                databaseBanco = {};
                databaseBancoSintetico = {};
                saldoPeriodo = 0.0;
                for (Spi010 spi010 in listSpi010) {
                  databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                  databaseBancoSintetico[spi010.pi_data] = spi010;
                }
                databaseBanco.forEach((key, value) {
                  saldoPeriodo += value.pi_quant;
                });
              });
            });
            _spi010service
                .searchGestor(depto, '20230101', buscaSaldo)
                .then((List<Spi010> listSpi010) {
              setState(() {
                saldoInicial = 0.0;
                for (Spi010 spi010 in listSpi010) {
                  saldoInicial += spi010.pi_quant;
                }
                _showSearch = true;
              });
            });
          } else {
            detail = 1;
            _spi010service
                .searchColaborador(matricula, inicio, fim)
                .then((List<Spi010> listSpi010) {
              setState(() {
                databaseBanco = {};
                databaseBancoSintetico = {};
                saldoPeriodo = 0.0;
                for (Spi010 spi010 in listSpi010) {
                  databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                  databaseBancoSintetico[spi010.pi_data] = spi010;
                }
                databaseBanco.forEach((key, value) {
                  saldoPeriodo += value.pi_quant;
                });
              });
            });
            _spi010service
                .searchColaborador(matricula, '20230101', buscaSaldo)
                .then((List<Spi010> listSpi010) {
              setState(() {
                saldoInicial = 0.0;
                for (Spi010 spi010 in listSpi010) {
                  saldoInicial += spi010.pi_quant;
                }
                _showSearch = true;
              });
            });
          }
        } else if (group == '3') {
          if(mounted){
            setState(() {
              _showSearch = false;
            });
          }
          detail = 1;
          _spi010service
              .searchColaborador(matricula, inicio, fim)
              .then((List<Spi010> listSpi010) {
            setState(() {
              databaseBanco = {};
              databaseBancoSintetico = {};
              saldoPeriodo = 0.0;
              for (Spi010 spi010 in listSpi010) {
                databaseBanco[spi010.r_e_c_n_o_field] = spi010;
                databaseBancoSintetico[spi010.pi_data] = spi010;
              }
              databaseBanco.forEach((key, value) {
                saldoPeriodo += value.pi_quant;
              });
            });
          });
          _spi010service
              .searchColaborador(matricula, '20230101', buscaSaldo)
              .then((List<Spi010> listSpi010) {
            setState(() {
              saldoInicial = 0.0;
              for (Spi010 spi010 in listSpi010) {
                saldoInicial += spi010.pi_quant;
              }
              _showSearch = true;
            });
          });
        }
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
      int soma = 0;

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
                  if (soma == 0) {
                    name.add('TODOS');
                    _sqb010service.getAll().then((List<Sqb010> listSqb010) {
                      setState(() {
                        for (Sqb010 sqb010 in listSqb010) {
                          name.add(sqb010.qb_descric.trim());
                        }
                      });
                    });
                  }
                  name.add(sze010.ze_nome.trim());
                  soma++;
                } else if (group == '2') {
                  if (sze010.ze_depto == depto) {
                    if (soma == 0) {
                      name.add('TODOS');
                    }
                    name.add(sze010.ze_nome.trim());
                    soma++;
                  }
                } else if (group == '3') {
                  if (id == sze010.ze_mat) {
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
