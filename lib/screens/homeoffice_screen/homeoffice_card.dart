import 'package:flutter/material.dart';
import 'package:projeto_aucs/models/sqb010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/models/szh010.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/homeoffice_tile_list.dart';
import 'package:projeto_aucs/services/homeoffice_service.dart';
import 'package:projeto_aucs/services/sze010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeOfficeCard extends StatefulWidget {
  final Szh010? szh010;
  final Function refreshFunction;

  const HomeOfficeCard({
    Key? key,
    this.szh010,
    required this.refreshFunction,
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
  bool _isloading = false;
  final ScrollController _controller = ScrollController();
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.refreshFunction();
    getSze010();
  }

  @override
  Widget build(BuildContext context) {
    if (soma > 0) {
      return SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildPanel() {
    return (!_isloading)
        ? ExpansionPanelList(
            dividerColor: Colors.grey,
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                this.isExpanded = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text('${widget.szh010!.zh_dataini.substring(6, 8)}/'
                        '${widget.szh010!.zh_dataini.substring(4, 6)}/'
                        '${widget.szh010!.zh_dataini.substring(0, 4)}'),
                  );
                },
                body: SizedBox(
                  height: (soma >= 4) ? 350 : 150,
                  child: Scrollbar(
                    thumbVisibility: true,
                    thickness: 13.0,
                    controller: _controller,
                    radius: const Radius.circular(20.0),
                    child: ListView(
                      controller: _controller,
                      children: generateListTileHomeOffice(
                        databaseSzh: databaseSzh,
                        database: database,
                        matricula: widget.szh010!.zh_mat,
                        recno: widget.szh010!.r_e_c_n_o_field,
                        data: widget.szh010!.zh_dataini,
                      ),
                    ),
                  ),
                ),
                isExpanded: isExpanded,
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
          );
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
      widget.refreshFunction();

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
        _homeOfficeService.getAll().then((List<Szh010> listSzh010) {
          setState(() {
            databaseSzh = {};
            for (Szh010 szh010 in listSzh010) {
              if(widget.szh010!.zh_dataini == szh010.zh_dataini){
                databaseSzh[szh010.zh_mat] = szh010;
                soma += 1;
              }
            }
          });
        });

        _sze010service.getAll().then((List<Sze010> listSze010) {
          setState(() {
            database = {};
            for (Sze010 sze010 in listSze010) {
              database[sze010.ze_nome] = sze010;
            }

            database.forEach((key, value) {
              if (widget.szh010!.zh_mat == value.ze_mat) {
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
}

enum DisposeStatus { exit, error, success }
