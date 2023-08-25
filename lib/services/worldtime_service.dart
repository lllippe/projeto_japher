import 'dart:convert';
import 'dart:io';
import 'package:projeto_aucs/services/web_client.dart';
import 'package:http/http.dart' as http;

class WorldTimeService {
  http.Client client = WebClient().client;

  Future<List<String>> getAll() async {

    http.Response response = await client.get(
      Uri.parse("https://worldtimeapi.org/api/timezone/America/Sao_Paulo"),
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      verifyException(json.decode(response.body));
    }

    List<String> result = [];

    Map<String, dynamic> jsonList = json.decode(response.body);

    jsonList.forEach((key, value) {
      if(key == 'datetime'){
        result.add(value);
      }
    });

    return result;
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
