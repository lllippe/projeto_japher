import 'package:flutter/material.dart';
import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/models/sze010.dart';
import 'package:projeto_aucs/screens/add_screen/add_bancohoras_screen.dart';
import 'package:projeto_aucs/screens/add_screen/add_sze010_screen.dart';
import 'package:projeto_aucs/screens/commom/transfer_home.dart';
import 'package:projeto_aucs/screens/home_screen/home_screen.dart';
import 'package:projeto_aucs/screens/login_screen/login_screen.dart';
import 'package:projeto_aucs/screens/solicitacao_screen/solicitacao_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLogged = await verifyToken();

  String user = await getUser();

  runApp(MyApp(
    isLogged: isLogged,
    user: user,
  ));
}

Future<bool> verifyToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //TODO: Criar uma classe de valores
  String? token = sharedPreferences.getString('first_name');
  if (token != null) {
    return true;
  }
  return false;
}

Future<String> getUser() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //TODO: Criar uma classe de valores
  String? user = sharedPreferences.getString('first_name');
  if (user != null) {
    return user;
  }
  return '';
}

class MyApp extends StatefulWidget {
  final bool isLogged;
  final String user;

  const MyApp({Key? key, required this.isLogged, required this.user}) : super(key: key);

  static const String _title = 'Bem-vindo!';

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userGroup = '';

  void refresh() async {
    await SharedPreferences.getInstance().then(
          (prefs) {
        String? group = prefs.getString('group');

        if (group != null) {
          userGroup = group;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyApp._title,
      home: LoginScreen(),
      initialRoute: (widget.isLogged) ? "transfer" : "login",
      routes: {
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(
              selectedIndex: 0,
              name: widget.user,
              userGroup: userGroup,
            ),
        "transfer": (context) => const TransferHome(),
        "solicitation": (context) => SolicitacaoScreen(
          group: userGroup,
          isloading: true,
        ),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == "edit_sze010") {
          final map = routeSettings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return AddSze010Screen(
                refreshFunction: refresh,
                sze010: map["sze010"] as Sze010,
                isEditing: map["is_editing"],
              );
            },
          );
          } else if (routeSettings.name == "edit_spi010") {
            final map = routeSettings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return AddBancoHorasScreen(
                  spi010: map["spi010"] as Spi010,
                  isEditing: map["is_editing"],
                  isLoading: true,
                );
              },
            );
        }
        return null;
      },
    );
  }


}
