import 'package:flutter/material.dart';
import 'package:projeto_aucs/models/sqb010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/commom/menu_drawer.dart';
import 'package:projeto_aucs/screens/szh010_screen/szh010_screen_list.dart';
import 'package:projeto_aucs/services/sqb010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Szh010Screen extends StatefulWidget {
  final bool isloading;
  const Szh010Screen({Key? key, required this.isloading}) : super(key: key);

  @override
  State<Szh010Screen> createState() => _Szh010ScreenState();
}

class _Szh010ScreenState extends State<Szh010Screen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;
  Map<String, Sqb010> database = {};
  final ScrollController _listScrollController = ScrollController();
  final Sqb010Service _sqb010service = Sqb010Service();
  String userId = '';
  final Sze010 sze010 = Sze010.empty();
  final Sqb010 sqb010 = Sqb010.empty();
  final bool isEditing = false;
  bool _isloading = false;

  @override
  void initState() {
    refresh();
    super.initState();
    _isloading = widget.isloading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            title: const Text(
              "Férias",
            ),
            titleTextStyle: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            backgroundColor: Colors.greenAccent,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Szh010Screen(isloading: true,)),
                  );
                },
                icon: const Icon(
                  Icons.refresh,
                ),
              ),
            ],
          ),
          body: (!_isloading)
          ? ListView(
              controller: _listScrollController,
              children:
              generateListSzh010Cards(
                database: database,
                refreshFunction: refresh,
              ),
            )
          : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
          drawer: Drawer(
            child: menuDrawer(context),
          ),
        );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');

      if (firstName != null && lastName != null) {
      _sqb010service.getAll().then((List<Sqb010> listSqb010) {
        setState(() {
          database = {};
          for (Sqb010 sqb010 in listSqb010) {
            database[sqb010.qb_depto] = sqb010;
          }
          _isloading = false;
        });
      });
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}
