import 'dart:convert';
import 'dart:io';
import 'package:projeto_aucs/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/szh010.dart';

class HomeOfficeService {
  static const String resource = "home_office/";

  http.Client client = WebClient().client;

  String getURL() {
    return "${WebClient.url}$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<bool> register(Szh010 szh010) async {
    String szh010JSON = json.encode(szh010.toMap());
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.post(
      getUri(),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
      body: szh010JSON,
    );

    if (response.statusCode != 201) {
      verifyException(json.decode(response.body));
    }

    return true;
  }

  Future<bool> edit(int recno, Szh010 szh010) async {
    String szh010JSON = json.encode(szh010.toMap());
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.put(
      Uri.parse("${getURL()}$recno/"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
      body: szh010JSON,
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    return true;
  }

  Future<List<Szh010>> getAll() async {
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

    List<Szh010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Szh010.fromMap(jsonMap));
    }

    return result;
  }

  Future<List<Szh010>> searchUnique(String mat, String initialDate) async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}home_office/?search=$mat,$initialDate"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<Szh010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Szh010.fromMap(jsonMap));
    }

    return result;
  }

  Future<bool> remove(int id) async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.delete(
      Uri.parse("${getURL()}$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    return true;
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