import 'dart:convert';
import 'dart:io';
import 'package:projeto_aucs/models/spi010.dart';
import 'package:projeto_aucs/services/web_client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Spi010Service {
  static const String resource = "banco_horas/";

  http.Client client = WebClient().client;

  String getURL() {
    return "${WebClient.url}$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<bool> register(Spi010 spi010) async {
    String Spi010JSON = json.encode(spi010.toMap());
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
      body: Spi010JSON,
    );

    if (response.statusCode != 201) {
      verifyException(json.decode(response.body));
    }

    return true;
  }

  Future<bool> edit(int recno, Spi010 spi010) async {
    String spi010JSON = json.encode(spi010.toMap());
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
      body: spi010JSON,
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    return true;
  }

  Future<List<Spi010>> getAll() async {
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

    List<Spi010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Spi010.fromMap(jsonMap));
    }

    return result;
  }

  Future<List<Spi010>> searchColaborador(String matricula, String inicio, String fim) async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}consulta_banco/$matricula&$inicio&$fim"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<Spi010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Spi010.fromMap(jsonMap));
    }

    return result;
  }

  Future<List<Spi010>> searchGestor(String depto, String inicio, String fim) async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}consulta_banco_gestor/$depto&$inicio&$fim"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<Spi010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Spi010.fromMap(jsonMap));
    }

    return result;
  }

  Future<List<Spi010>> searchDiretor(String inicio, String fim) async {
    String user = await getUser();
    String password = await getPassword();
    final bytes = utf8.encode('$user:$password');
    final base64Str = base64.encode(bytes);
    http.Response response = await client.get(
      Uri.parse("${WebClient.url}consulta_banco_diretor/$inicio&$fim"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Basic $base64Str',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<Spi010> result = [];

    List<dynamic> jsonList = json.decode(response.body);

    for (var jsonMap in jsonList) {
      result.add(Spi010.fromMap(jsonMap));
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
    }

    throw HttpException(error);
  }
}

class TokenExpiredException implements Exception {}
