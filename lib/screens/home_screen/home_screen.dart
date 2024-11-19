import 'package:flutter/material.dart';
import 'package:projeto_aucs/helpers/logout.dart';
import 'package:projeto_aucs/models/sze010_falta_dias.dart';
import 'package:projeto_aucs/screens/bancohoras_screen/grid_bancohoras.dart';
import 'package:projeto_aucs/screens/commom/menu_drawer.dart';
import 'package:projeto_aucs/screens/ferias_screen/grid_ferias.dart';
import 'package:projeto_aucs/screens/homeoffice_screen/homeoffice_screen.dart';
import 'package:projeto_aucs/screens/pontoeletronico_screen/grid_pontoeletronico.dart';
import 'package:projeto_aucs/screens/warning_screen/warning.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String userGroup;
  final int selectedIndex;

  const HomeScreen(
      {super.key,
      required this.selectedIndex,
      required this.userGroup,
      required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Sze010FaltaDias? sze010;
  Map<String, Sze010FaltaDias> databaseFaltaDias = {};
  int _selectedIndex = 0;
  String email = '';
  String userId = '';
  final List<Widget> _widgetOptions = const <Widget>[
    Warning(),
    Ferias(isloading: true,),
    HomeOfficeScreen(isloading: true,),
    PontoEletronico(isloading: true,),
    BancoHoras(isloading: true,),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();

    (widget.selectedIndex > 0)
        ? _selectedIndex = widget.selectedIndex
        : _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    double width_screen = deviceData.size.width;
    return Scaffold(
            appBar: AppBar(
              foregroundColor: Colors.black,
              title: Text('Olá, ${widget.name}'),
              titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              backgroundColor: Colors.greenAccent,
              actions: [
                IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: const Icon(Icons.logout_outlined),
                  tooltip: 'Sair',
                )
              ],
            ),
            body: SizedBox(
                width: width_screen,
                child: _widgetOptions
                    .elementAt(_selectedIndex) //ListTileSelectExample(),
                ),
            drawer: Drawer(child: menuDrawer(context)),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  border:
                      Border(top: BorderSide(color: Colors.white70, width: 3))),
              child: bottomNavigationMenu(),
            ),
          );
  }

  BottomNavigationBar bottomNavigationMenu() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement_rounded),
          label: 'Avisos',
          backgroundColor: Colors.greenAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airplane_ticket_rounded),
          label: 'Férias',
          backgroundColor: Colors.greenAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment_rounded),
          label: 'HomeOffice',
          backgroundColor: Colors.greenAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Ponto',
          backgroundColor: Colors.greenAccent,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'Banco de Horas',
          backgroundColor: Colors.greenAccent,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((prefs) {
      String? firstName = prefs.getString('first_name');
      String? lastName = prefs.getString('last_name');

      if (firstName != null && lastName != null) {
        email = firstName;
      } else {
        Navigator.pushReplacementNamed(context, 'login');
      }
    });
  }
}
