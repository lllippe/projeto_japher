import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_screen/home_screen.dart';

class TransferHome extends StatefulWidget {
  const TransferHome({Key? key}) : super(key: key);

  @override
  State<TransferHome> createState() => _TransferHomeState();
}

class _TransferHomeState extends State<TransferHome> {
  String email = '';
  String userGroup = '';

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return
      HomeScreen(
        selectedIndex: 0,
        name: email,
        userGroup: userGroup,
      );
  }

  void refresh() async {    SharedPreferences.getInstance().then((prefs) {
    String? firstName = prefs.getString('first_name');
    String? lastName = prefs.getString('last_name');
    String? group = prefs.getString('group');

    if (firstName != null && lastName != null && group != null) {
      email = firstName;
      userGroup = group;
      Navigator.pop(context);
      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => HomeScreen(
         selectedIndex: 0,
         name: email,
         userGroup: userGroup,
       )),
      );
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  });
  }
}
