import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_aucs/models/ferias.dart';
import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/commom/menu_drawer.dart';
import 'package:projeto_aucs/screens/commom/success_dialog.dart';
import 'package:projeto_aucs/screens/home_screen/home_screen.dart';
import 'package:projeto_aucs/services/homeoffice_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:projeto_aucs/validations/homeOfficeValidation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

var depto;
const List<String> active = <String>['Sim', 'Não'];

class AddHomeOfficeScreen extends StatefulWidget {
  final bool isLoading;
  final bool isEditing;
  final Spi010 spi010;

  const AddHomeOfficeScreen({Key? key,
    required this.isLoading,
    required this.isEditing,
    required this.spi010})
      : super(key: key);

  @override
  State<AddHomeOfficeScreen> createState() => _AddHomeOfficeScreenState();
}

class _AddHomeOfficeScreenState extends State<AddHomeOfficeScreen> {
  String email = 'Seja bem-vindo(a)';
  final Sze010Service _sze010service = Sze010Service();
  final HomeOfficeService _homeOfficeService = HomeOfficeService();
  Map<String, String> database = {};
  Map<String, Sze010> databaseSze = {};
  Map<int, FeriasSze> databaseVacation = {};
  Map<int, Szh010> databaseHomeOffice = {};
  List<TableRow> tableContainer = [];
  List<String> name = [];
  int qtdeDias = 0;
  int diasDireito = 0;
  int diasSzh = 40;
  int diasSrh = 40;
  TextEditingController inicioController = TextEditingController();
  TextEditingController fimController = TextEditingController();
  DateTime? pickedDateFim;
  DateTime? pickedDateInicio;
  DateTime initialDate = DateTime.now();
  String periodoInicial = '        ';
  String periodoFinal = '        ';
  final ScrollController _controller = ScrollController();
  bool validateColaborador = false;
  bool validateVacation = false;
  homeOfficeValidation validation = homeOfficeValidation();
  var departamento;
  bool _isloading = false;
  String matricula = '';
  DateTime time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _isloading = widget.isLoading;
    getSze010();
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = DateTime.now();
    DateTime lastDate = initialDate.add(const Duration(days: 60));

    return (!_isloading)
        ? Scaffold(
                appBar: AppBar(
                  foregroundColor: Colors.black,
                  title: const Text('Editar Home Office'),
                  titleTextStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  backgroundColor: Colors.greenAccent,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 2.0),
                                child: Text(
                                  'Colaborador?',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: DropdownButton<String>(
                                  value: departamento,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.deepPurple,
                                      fontSize: 16),
                                  items: name.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                        width: 200,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
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
                        ), // Nome
                        const Divider(
                          height: 2,
                          thickness: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                              controller: inicioController,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                labelText: "Data: ",
                              ),
                              readOnly: true,
                              onTap: () async {
                                pickedDateInicio = await showDatePicker(
                                  selectableDayPredicate: (DateTime date) {
                                    if (date.weekday == DateTime.saturday ||
                                        date.weekday == DateTime.sunday) {
                                      return false;
                                    }
                                    return true;
                                  },
                                  context: context,
                                  initialDate: initialDate,
                                  firstDate: initialDate,
                                  lastDate: lastDate,
                                );

                                if (pickedDateInicio != null) {
                                  String formattedDate = DateFormat('dd/MM/yyyy')
                                      .format(pickedDateInicio!);

                                  setState(() {
                                    inicioController.text =
                                        formattedDate;
                                    time = DateTime(int.parse(inicioController.text.substring(6, 10)),
                                        int.parse(inicioController.text.substring(3, 5)),
                                        int.parse(inicioController.text.substring(0, 2)));//set foratted date to TextField value.
                                  });
                                  primaryValidation();
                                } else {
                                  String formattedDate =
                                      DateFormat('dd/MM/yyyy').format(initialDate);

                                  setState(() {
                                    formattedDate;
                                  });
                                }
                              }),
                        ), // Inicio Ferias
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0, bottom: 30),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.greenAccent),
                            ),
                            onPressed: () {
                              validateHomeOffice(context);
                            },
                            child: Text(
                              'Adicionar',
                              style: GoogleFonts.acme(
                                textStyle: const TextStyle(fontSize: 30),
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ), // Button Solicitar
                      ],
                    ),
                  ),
                ),
                drawer: menuDrawer(context),
            )
        : Container(
          color: Colors.white,
          child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
        );
  }

  void primaryValidation() {
    String matriculaColab = '';
    String initialDate = inicioController.text.substring(6, 10) +
        inicioController.text.substring(3, 5) +
        inicioController.text.substring(0, 2);

    databaseSze.forEach((key, value) {
      if (value.ze_nome.trim() == departamento) {
        matriculaColab = value.ze_mat;
      }
    });

    if(validation.searchUniqueName(matriculaColab, initialDate)){
      ErrorDialog(context,
          'Colaborador já cadastrado esse dia.');
    }

    if(validation.SearchColabVacation(matriculaColab, time)){
      ErrorDialog(context,
          'Colaborador em férias não pode trabalhar presencial.');
    }
  }

  void validateHomeOffice(BuildContext context) {
    String matriculaColab = '';
    String initialDate = inicioController.text.substring(6, 10) +
        inicioController.text.substring(3, 5) +
        inicioController.text.substring(0, 2);

    databaseSze.forEach((key, value) {
      if (value.ze_nome.trim() == departamento) {
        matriculaColab = value.ze_mat;
      }
    });

    if(validation.searchUniqueName(matriculaColab, initialDate)){
      ErrorDialog(context,
          'Colaborador já cadastrado esse dia.');
      validateColaborador = true;
    } else {
      validateColaborador = false;
    }

    if(validation.SearchColabVacation(matriculaColab, time)){
      ErrorDialog(context,
          'Colaborador em férias não pode trabalhar presencial.');
      validateVacation = true;
    } else {
      validateVacation = false;
    }

    (validateColaborador || validateVacation)
        ? ErrorDialog(
        context, 'Existem erros que impedem a gravação, verificar!!')
        : registerSzh010(context);
  }

  registerSzh010(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      String? group = prefs.getString('group');
      String? name = prefs.getString('first_name');

      String matricula = '';
      String dpto = '';

      databaseSze.forEach((key, value) {
        if (value.ze_nome.trim() == departamento) {
          matricula = value.ze_mat;
          dpto = value.ze_depto;
        }
      });

      Szh010 internalSzh010 = Szh010(
          zh_mat: matricula,
          zh_inipaq: inicioController.text.substring(6, 10) +
              inicioController.text.substring(3, 5) +
              inicioController.text.substring(0, 2),
          zh_fimpaq: inicioController.text.substring(6, 10) +
              inicioController.text.substring(3, 5) +
              inicioController.text.substring(0, 2),
          zh_saldfer: double.parse(diasDireito.toString()),
          zh_diasfer: double.parse(qtdeDias.toString()),
          zh_dataini: inicioController.text.substring(6, 10) +
              inicioController.text.substring(3, 5) +
              inicioController.text.substring(0, 2),
          zh_datafim: inicioController.text.substring(6, 10) +
              inicioController.text.substring(3, 5) +
              inicioController.text.substring(0, 2),
          zh_aprvges: '2',
          zh_aprvdir: '2',
          zh_recibvi: '2',
          zh_dtrecvi: '2',
          zh_recibap: '2',
          zh_dtrecap: '',
          zh_integra: '2',
          zh_depto: dpto,
          r_e_c_n_o_field: 0,
          r_e_c_d_e_l_field: 0,
          d_e_l_e_t_field: '');

      _homeOfficeService.register(internalSzh010).then((value) {
        if (value) {
          Navigator.pop(context, DisposeStatus.success);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (name != null && group != null)
                  ? HomeScreen(
                      selectedIndex: 2,
                      name: name,
                      userGroup: group,
                    )
                  : Container(),
            ),
          );
          return SuccessDialog(context, 'HomeOffice cadastrado com Sucesso!');
        } else {
          Navigator.pop(context, DisposeStatus.error);
          return ErrorDialog(context, 'Erro na solicitação, tente mais tarde!');
        }
      });
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
        _homeOfficeService.getAll().then((List<Szh010> listSzh010) {
          if(mounted){
            setState(() {
              databaseHomeOffice = {};
              for (Szh010 szh010 in listSzh010) {
                databaseHomeOffice[szh010.r_e_c_n_o_field] = szh010;
              }
            });
          }
        });

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
                if (sze010.ze_nome.trim() == departamento) {
                  matricula = sze010.ze_mat;
                }
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

enum DisposeStatus { exit, error, success }
