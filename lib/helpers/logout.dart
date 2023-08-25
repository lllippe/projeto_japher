import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

logout(BuildContext context) {
  SharedPreferences.getInstance().then((sharedPreferences) {
    sharedPreferences.remove('first_name');
    sharedPreferences.remove('last_name');
    sharedPreferences.remove('group');
    sharedPreferences.remove('id');

    Navigator.pushReplacementNamed(context, 'login');
  });
}
