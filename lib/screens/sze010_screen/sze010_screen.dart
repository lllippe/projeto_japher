import 'package:flutter/material.dart';
import 'package:projeto_aucs/models/sqb010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/add_screen/add_sze010_screen.dart';
import 'package:projeto_aucs/screens/sze010_screen/sze010_screen_list.dart';
import 'package:projeto_aucs/screens/commom/menu_drawer.dart';
import 'package:projeto_aucs/services/sqb010_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sze010Screen extends StatefulWidget {
  final bool isloading;
  const Sze010Screen({Key? key, required this.isloading}) : super(key: key);

  @override
  State<Sze010Screen> createState() => _Sze010ScreenState();
}

class _Sze010ScreenState extends State<Sze010Screen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
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
          "Colaboradores",
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
                MaterialPageRoute(builder: (context) => const Sze010Screen(isloading: true,)),
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
          children: generateListSze010Cards(
            database: database,
            windowPage: windowPage,
            currentDay: currentDay,
            refreshFunction: refresh,
          )
        )
       : const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSze010Screen(
                refreshFunction: refresh,
                sze010: sze010,
                isEditing: isEditing,
              ),
            ),
          );
        },
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add,
          color: Colors.black,),
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
          //userId = id;
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
