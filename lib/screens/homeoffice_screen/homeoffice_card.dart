import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:projeto_aucs/models/sqb010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/widget/homeOffice_tile_list.dart';
import 'package:projeto_aucs/services/homeoffice_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeOfficeCard extends StatefulWidget {
  const HomeOfficeCard({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeOfficeCard> createState() => _HomeOfficeCardState();
}

class _HomeOfficeCardState extends State<HomeOfficeCard> {
  Map<String, Sze010> database = {};
  Map<String, Szh010> databaseSzh = {};
  int soma = 0;

  final HomeOfficeService _homeOfficeService = HomeOfficeService();
  final Sze010Service _sze010service = Sze010Service();
  final ScrollController _controller = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  bool isExpanded = false;
  TextEditingController inicioController = TextEditingController();
  TextEditingController fimController = TextEditingController();
  DateTime? pickedDateFim;
  DateTime? pickedDateInicio;
  bool _isSearchReady = false;
  bool _showSearch = false;
  String returnSearch = 'Realize sua pesquisa.';
  String dateSearch = '';

  @override
  void initState() {
    super.initState();
    getSze010();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    DateTime lastDate = DateTime.now().add(const Duration(days: 90));
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 90));

    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: 390,
              height: 150,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14.0),
                      child: TextField(
                          controller: inicioController,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            labelText: "Selecione a data: ",
                          ),
                          readOnly: true,
                          onTap: () async {
                            pickedDateInicio = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: initialDate,
                              lastDate: lastDate,
                            );

                            if (pickedDateInicio != null) {
                              String formattedDate = DateFormat('dd/MM/yyyy')
                                  .format(pickedDateInicio!);

                              setState(() {
                                inicioController.text = formattedDate;
                              });
                            } else {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(initialDate);

                              setState(() {
                                formattedDate; //set foratted date to TextField value.
                              });
                            }
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 2),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.greenAccent),
                        ),
                        onPressed: () {
                          search();
                        },
                        child: Text(
                          'Pesquisar',
                          style: GoogleFonts.acme(
                            textStyle: const TextStyle(fontSize: 30),
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), // Inicio Ferias
            ),
            (_isSearchReady)
                ? (_showSearch)
                    ? Column(
                        children: [
                          databaseSzh.isEmpty
                              ? Card(
                                  child: SizedBox(
                                    width: 380,
                                    height: 40,
                                    child: Text(
                                      'Ninguém cadastrado presencial',
                                      style: GoogleFonts.acme(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : Card(
                                  child: SizedBox(
                                    width: 380,
                                    height: 40,
                                    child: Text(
                                      'Presencial dia: $dateSearch',
                                      style: GoogleFonts.acme(
                                        textStyle: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                          Card(
                            child: SizedBox(
                              width: 380,
                              height: 400,
                              child: Scrollbar(
                                controller: _controller,
                                thumbVisibility: true,
                                thickness: 10,
                                radius: const Radius.circular(5),
                                child: ListView(
                                  controller: _listScrollController,
                                  children: generateListTilHomeOffice(
                                    database: databaseSzh,
                                    databaseSze: database,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                : Card(
                  child: SizedBox(
                      width: 380,
                      height: 40,
                      child: Text(
                        returnSearch,
                        style: GoogleFonts.acme(
                          textStyle: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ),
          ],
        ),
      ],
    );
  }

  void search() {
    setState(() {
      if (inicioController.text != '') {
        setState(() {
          _showSearch = false;
        });
        getSze010();
        _isSearchReady = true;
        dateSearch = inicioController.text;
      } else {
        returnSearch = 'O campo Data Inicial não pode\n'
            'ficar em branco.';
      }
    });
  }

  callAddSqb010Screen(BuildContext context, {Sqb010? sqb010}) {
    Sqb010 internalSqb010 = Sqb010(
      qb_depto: '',
      qb_descric: '',
      r_e_c_n_o_field: 0,
    );

    if (sqb010 != null) {
      internalSqb010 = sqb010;
    }

    Map<String, dynamic> map = {
      'sqb010': internalSqb010,
      'is_editing': sqb010 != null
    };

    Navigator.pushNamed(
      context,
      'edit_sqb010',
      arguments: map,
    ).then((value) {
      //widget.refreshFunction();

      if (value == DisposeStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro salvo com sucesso."),
          ),
        );
      } else if (value == DisposeStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Houve uma falha ao registar."),
          ),
        );
      }
    });
  }

  void getSze010() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');

      if (firstName != null && lastName != null) {
        String inicio = inicioController.text.substring(6, 10) +
            inicioController.text.substring(3, 5) +
            inicioController.text.substring(0, 2);

        _homeOfficeService.searchDay(inicio).then((List<Szh010> listSzh010) {
          setState(() {
            databaseSzh = {};
            for (Szh010 szh010 in listSzh010) {
              databaseSzh[szh010.zh_mat] = szh010;
              soma += 1;
            }
          });
        });

        _sze010service.getAll().then((List<Sze010> listSze010) {
          setState(() {
            database = {};
            for (Sze010 sze010 in listSze010) {
              database[sze010.ze_nome] = sze010;
            }
            _showSearch = true;
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}

enum DisposeStatus { exit, error, success }
