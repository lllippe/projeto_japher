import 'dart:convert';
import 'dart:io';
import 'package:projeto_aucs/models/ferias.dart';
import 'package:projeto_aucs/models/quem_esta_ferias.dart';
import 'package:projeto_aucs/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FeriasService {
  static const String resource = "ferias/";

  http.Client client = WebClient().client;

  String getURL() {
    return "${WebClient.url}$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<List<FeriasSze>> getAll() async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}$resource"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<FeriasSze> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(FeriasSze.fromMap(jsonMap));
    }

    return result;
  }

  Future<List<QuemEstaFerias>> getListVacation() async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}quem_esta_ferias/"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<QuemEstaFerias> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(QuemEstaFerias.fromMap(jsonMap));
    }

    return result;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');
    if (token != null) {
      return token;
    }
    return '';
  }

  Future<String> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('id');
    if (user != null) {
      return user;
    }
    return '';
  }

  Future<String> getPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString('password');
    if (password != null) {
      return password;
    }
    return '';
  }

  verifyException(String error) {
    switch (error) {
      case 'jwt expired':
        throw TokenExpiredException();
      case 'Nao Cadastrado':
        throw NaoCadastradoException();
    }

    throw HttpException(error);
  }
}

class TokenExpiredException implements Exception {}

class NaoCadastradoException implements Exception {}