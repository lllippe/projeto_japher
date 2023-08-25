import 'dart:convert';
import 'dart:io';
import 'package:projeto_aucs/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  http.Client client = WebClient().client;
  static const String resource = "usuarios/";

  Future<String> login(String email, String password) async {
    final bytes = utf8.encode('$email:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}$resource?search=$email"),
      headers: {'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',},
    );

    if (response.statusCode != 200) {

      if (response.statusCode == 401) {
        throw UserNotFoundException();
      }

      throw HttpException(response.body.toString());
    }

    return saveInfosFromResponse(response.body, password);
  }

  Future<String> saveInfosFromResponse(String body, String password) async {
    String token = '';

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<dynamic> jsonList = json.decode(body);

    for (var jsonMap in jsonList) {
      List<dynamic> userGroup = jsonMap['groups'];
      token = jsonMap["first_name"];
      prefs.setString('first_name', jsonMap["first_name"]);
      prefs.setString('last_name', jsonMap["last_name"]);
      prefs.setString('id', jsonMap["username"]);
      prefs.setString('group', userGroup.first.toString());
      prefs.setString('password', password);
    }

    return token;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('first_name');
    if (token != null) {
      return token;
    }
    return '';
  }

  verifyException(String error) {
    switch (error) {
      case 'jwt expired':
        throw HttpException(error);
    }

    throw HttpException(error);
  }
}

class UserNotFoundException implements Exception {}
