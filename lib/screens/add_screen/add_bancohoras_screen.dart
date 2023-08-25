import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/models/srh010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/commom/menu_drawer.dart';
import 'package:projeto_aucs/screens/commom/success_dialog.dart';
import 'package:projeto_aucs/screens/home_screen/home_screen.dart';
import 'package:projeto_aucs/services/spi010_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:projeto_aucs/validations/bancoHorasValidation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

var depto;
const List<String> active = <String>['Sim', 'Não'];

class AddBancoHorasScreen extends StatefulWidget {
  final bool isLoading;
  final Spi010? spi010;
  final bool isEditing;

  const AddBancoHorasScreen({Key? key,
    required this.isLoading,
    required this.spi010,
    required this.isEditing})
      : super(key: key);

  @override
  State<AddBancoHorasScreen> createState() => _AddBancoHorasScreenState();
}

class _AddBancoHorasScreenState extends State<AddBancoHorasScreen> {
  String email = 'Seja bem-vindo(a)';
  final Sze010Service _sze010service = Sze010Service();
  final Spi010Service _spi010Service = Spi010Service();
  Map<String, String> database = {};
  Map<String, Sze010> databaseSze = {};
  Map<String, Srh010> databaseSrh = {};
  List<TableRow> tableContainer = [];
  List<String> name = [];
  TextEditingController inicioController = TextEditingController();
  TextEditingController horasController = TextEditingController();
  TextEditingController justificativaController = TextEditingController();
  DateTime? pickedDateInicio;
  DateTime initialDate = DateTime.now();
  String periodoInicial = '        ';
  final ScrollController _controller = ScrollController();
  bool validateHour = false;
  bool validateJust = false;
  bool validateDate = false;
  bancoHorasValidation validation = bancoHorasValidation();
  var departamento;
  bool _isloading = false;

  @override
  void initState() {
    _isloading = widget.isLoading;
    if(widget.isEditing){
      justificativaController.text = widget.spi010!.pi_justifi;
      horasController.text = widget.spi010!.pi_quant.toString();
      inicioController.text = DateFormat('dd/MM/yyyy')
          .format(DateTime.parse(widget.spi010!.pi_data));
    }
    getSze010();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now().subtract(const Duration(days: 90));
    DateTime lastDate = DateTime.now();

    return (!_isloading)
        ? (widget.isEditing)
          ? Scaffold(
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
                              'Horas',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              alignment: Alignment.center,
                              width: 30,
                              height: 40,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: TextField(
                                  controller: horasController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(fontSize: 18),),
                              ),
                            )
                          ),
                        ],
                      ),
                    ), // Nome
                    const Divider(
                      height: 2,
                      thickness: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              'Justificativa',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: 200,
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: TextField(
                                    controller: justificativaController,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(fontSize: 18),
                                    expands: true,
                                    minLines: null,
                                    maxLines: null,),
                                ),
                              )
                          ),
                        ],
                      ),
                    ), // Nome
                    const Divider(
                      height: 2,
                      thickness: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Text(
                              'Colaborador',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
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
                      )
                    ), // Inicio Ferias
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0, bottom: 30),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.greenAccent),
                        ),
                        onPressed: () {
                          validateBancoHoras(context);
                          (validateJust || validateHour || validateDate)
                              ? ErrorDialog(
                                  context, 'Existem erros que impedem a alteração, verificar!')
                              : registerSpi010(context);
                        },
                        child: Text(
                          'Alterar',
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
          : Scaffold(
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
                                'Horas',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 70,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextField(
                                      controller: horasController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(fontSize: 18),),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ), // Nome
                      const Divider(
                        height: 2,
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                'Justificativa',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 200,
                                  height: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: TextField(
                                      controller: justificativaController,
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(fontSize: 18),
                                      expands: true,
                                      minLines: null,
                                      maxLines: null,),
                                  ),
                                )
                            ),
                          ],
                        ),
                      ), // Nome
                      const Divider(
                        height: 2,
                        thickness: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Text(
                                'Colaborador',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
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
                                context: context,
                                initialDate: initialDate,
                                firstDate: firstDate,
                                lastDate: lastDate,
                              );

                              if (pickedDateInicio != null) {
                                String formattedDate = DateFormat('dd/MM/yyyy')
                                    .format(pickedDateInicio!);

                                setState(() {
                                  inicioController.text =
                                      formattedDate; //set foratted date to TextField value.
                                });
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
                            validateBancoHoras(context);
                            (validateJust || validateHour || validateDate)
                                ? ErrorDialog(
                                context, 'Existem erros que impedem a gravação, verificar!')
                                : registerSpi010(context);
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

  void validateBancoHoras(BuildContext context) {
    String initialDate = (inicioController.text != '')
        ? inicioController.text.substring(6, 10) +
          inicioController.text.substring(3, 5) +
          inicioController.text.substring(0, 2)
        : '';
    double hourValidator = (horasController.text != '')
          ? (horasController.text.contains(','))
            ? double.parse(horasController.text.replaceAll(',', '.'))
            : double.parse(horasController.text)
          : 0.0;

    if(validation.hourDifferentZero(hourValidator)){
      validateHour = true;
      ErrorDialog(
          context, 'Quantidade de horas deve ser preenchida!');
    } else {
      validateHour = false;
    }

    if(validation.justificationDifferentBlank(justificativaController.text)){
      validateJust = true;
      ErrorDialog(
          context, 'Justificativa deve ser preenchida!');
    } else {
      validateJust = false;
    }

    if (validation.dateDifferenteBlank(initialDate)) {
      validateDate = true;
      ErrorDialog(
          context, 'Dia deve ser preenchido!');
    } else {
      validateDate = false;
    }
  }

  registerSpi010(BuildContext context) async {
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

      if(widget.isEditing) {
        double horas = (horasController.text.contains(','))
            ? double.parse(horasController.text.replaceAll(',', '.'))
            : double.parse(horasController.text);

        Spi010 internalSpi010 = Spi010(
            pi_mat: widget.spi010!.pi_mat,
            pi_data: widget.spi010!.pi_data,
            pi_pd: (horas < 0) ? '002' : '001',
            pi_quant: horas,
            pi_quantv: widget.spi010!.pi_quantv,
            pi_status: widget.spi010!.pi_status,
            pi_depto: widget.spi010!.pi_depto,
            pi_justifi: justificativaController.text.trim(),
            d_e_l_e_t_field: '',
            r_e_c_n_o_field: widget.spi010!.r_e_c_n_o_field,
            r_e_c_d_e_l_field: widget.spi010!.r_e_c_d_e_l_field);

            _spi010Service.edit(widget.spi010!.r_e_c_n_o_field, internalSpi010).then((value) {
              if (value) {
                Navigator.pop(context, DisposeStatus.success);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => (name != null && group != null)
                        ? HomeScreen(
                      selectedIndex: 4,
                      name: name,
                      userGroup: group,
                    )
                        : Container(),
                  ),
                );
                return SuccessDialog(context, 'Horas alteradas com sucesso!');
              } else {
                Navigator.pop(context, DisposeStatus.error);
                return ErrorDialog(context, 'Erro na solicitação, tente mais tarde!');
              }
            });
      } else {
        double horas = (horasController.text.contains(','))
            ? double.parse(horasController.text.replaceAll(',', '.'))
            : double.parse(horasController.text);

        Spi010 internalSpi010 = Spi010(
            pi_mat: matricula,
            pi_data: inicioController.text.substring(6, 10) +
                inicioController.text.substring(3, 5) +
                inicioController.text.substring(0, 2),
            pi_pd: (horas < 0) ? '002' : '001',
            pi_quant: horas,
            pi_quantv: 0,
            pi_status: 'A',
            pi_depto: dpto,
            pi_justifi: justificativaController.text.trim(),
            d_e_l_e_t_field: '',
            r_e_c_n_o_field: 0,
            r_e_c_d_e_l_field: 0);

        _spi010Service.register(internalSpi010).then((value) {
          if (value) {
            Navigator.pop(context, DisposeStatus.success);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => (name != null && group != null)
                    ? HomeScreen(
                  selectedIndex: 4,
                  name: name,
                  userGroup: group,
                )
                    : Container(),
              ),
            );
            return SuccessDialog(context, 'Horas inseridas com sucesso!');
          } else {
            Navigator.pop(context, DisposeStatus.error);
            return ErrorDialog(context, 'Erro na solicitação, tente mais tarde!');
          }
        });
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
                  if(widget.isEditing) {
                    if(widget.spi010!.pi_mat == sze010.ze_mat){
                      name.add(sze010.ze_nome.trim());
                    }
                  } else {
                    name.add(sze010.ze_nome.trim());
                  }
                } else if(group == '2') {
                  if (widget.isEditing) {
                    if(widget.spi010!.pi_mat == sze010.ze_mat){
                      if (sze010.ze_depto == depto) {
                        name.add(sze010.ze_nome.trim());
                      }
                    }
                  } else {
                    if (sze010.ze_depto == depto) {
                      name.add(sze010.ze_nome.trim());
                    }
                  }
                } else if(group == '3'){
                  if(widget.isEditing) {
                    if(widget.spi010!.pi_mat == sze010.ze_mat){
                      if(id == sze010.ze_mat){
                        name.add(sze010.ze_nome.trim());
                      }
                    }
                  } else {
                    if(id == sze010.ze_mat){
                      name.add(sze010.ze_nome.trim());
                    }
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
