import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/commom/confirmation_dialog.dart';
import 'package:projeto_aucs/screens/commom/error_dialog.dart';
import 'package:projeto_aucs/screens/home_screen/home_screen.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/homeoffice_screen.dart';
import 'package:projeto_aucs/services/homeoffice_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:projeto_aucs/validations/deleteHomeOfficeValidation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeOfficeTileCard extends StatefulWidget {
  final Sze010? sze010;
  final String? matricula;
  final int? recno;
  final String? data;

  const HomeOfficeTileCard(
      {Key? key, this.sze010, this.matricula, this.recno, this.data})
      : super(key: key);

  @override
  State<HomeOfficeTileCard> createState() => _HomeOfficeTileCardState();
}

class _HomeOfficeTileCardState extends State<HomeOfficeTileCard> {
  deleteHomeOfficeValidation validation = deleteHomeOfficeValidation();
  bool validateBelongs = false;
  final Sze010Service _sze010service = Sze010Service();
  Map<String, Sze010> databaseGestor = {};
  String deptoGestor = '';

  @override
  Widget build(BuildContext context) {
    if (widget.sze010 != null) {
      return (userGroup == '1' || userGroup == '2')
          ? ListTile(
              title: Text(
                widget.sze010!.ze_nome.trim(),
                style: GoogleFonts.acme(
                  textStyle: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
              trailing: const Icon(Icons.cancel_outlined),
              onTap: () async {
                validateDelete(context);
              })
          : ListTile(
              title: Text(
                widget.sze010!.ze_nome.trim(),
                style: GoogleFonts.acme(
                  textStyle: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            );
    } else {
      return const ListTile(
        title: Text('Nenhum colaborador Cadastrado'),
      );
    }
  }

  void validateDelete(BuildContext context) async {
    SharedPreferences.getInstance().then((prefs) {
      String? group = prefs.getString('group');
      String? matGestor = prefs.getString('id');

      if (group != null && matGestor != null){
        _sze010service.getId(matGestor).then((List<Sze010> listSze010) {
          databaseGestor = {};
          setState(() {
            for (Sze010 sze010 in listSze010) {
              databaseGestor[sze010.ze_mat] = sze010;
            }
          });
        });

        databaseGestor.forEach((key, value) {
          if(matGestor == value.ze_mat){
            deptoGestor = value.ze_depto;
          }
        });

        setState(() {
          validateBelongs = false;
        });

        if (group == '2') {
          if (validation.colaboradorBelongs(
              widget.sze010!.ze_depto, deptoGestor)) {
            validateBelongs = true;
            ErrorDialog(context,
                'Não é possível excluir colaborador que não é do seu departamento!');
          } else {
            validateBelongs = false;
          }
        } else if (group == '1') {
          validateBelongs = false;
        }


        if (validateBelongs) {
          ErrorDialog(context, 'Não é possível completar a operação!');
        } else {
          deleteSzh010(context);
        }
      }
    });
  }

  deleteSzh010(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      String? group = prefs.getString('group');
      String? user = prefs.getString('first_name');
      String? matGestor = prefs.getString('id');

      if(matGestor != null && group != null){
        if(!validateBelongs){
          showConfirmationDialog(
            context,
            content: "Deseja realmente remover o colaborador desse dia?",
            affirmativeOption: "Remover",
          ).then((value) {
            if (value != null && value) {
              Szh010 internalSzh010 = Szh010(
                  zh_mat: widget.sze010!.ze_mat,
                  zh_inipaq: widget.data!,
                  zh_fimpaq: widget.data!,
                  zh_saldfer: 0,
                  zh_diasfer: 0,
                  zh_dataini: widget.data!,
                  zh_datafim: widget.data!,
                  zh_aprvges: '9',
                  zh_aprvdir: '9',
                  zh_recibvi: '9',
                  zh_dtrecvi: '9',
                  zh_recibap: '9',
                  zh_dtrecap: '',
                  zh_integra: '9',
                  zh_depto: '9',
                  r_e_c_n_o_field: widget.recno!,
                  r_e_c_d_e_l_field: widget.recno!,
                  d_e_l_e_t_field: '*');

              HomeOfficeService service = HomeOfficeService();
              if (widget.recno != null) {
                service.edit(widget.recno!, internalSzh010).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text((value)
                          ? "Removido com sucesso!"
                          : "Houve um erro ao remover")));
                }).then((value) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => (user != null)
                          ? HomeScreen(
                        selectedIndex: 0,
                        name: user,
                        userGroup: group,
                      )
                          : Container(),
                    ),
                  );
                });
              }
            }
          });
          validateBelongs = false;
        } else {
          ErrorDialog(
              context,
              'Não é possível excluir colaborador que não é do seu departamento!');
        }
      }
    });
  }
}
