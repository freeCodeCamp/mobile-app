import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

// get, post, put and delete methods based in one file for connecting to the Discourse api

class ForumConnect {
  static String baseUrl = 'https://forum.freecodecamp.org';

  static Future<dynamic> connectAndGet(String endpoint) async {
    await dotenv.load(fileName: ".env");

    final response = await http.get(Uri.parse(baseUrl + endpoint),
        headers: <String, String>{'Accept': 'application/json'});
    dev.log(baseUrl + endpoint);
    //dev.log(response.body.toString());
    return response;
  }

  static Future<dynamic> connectAndPost(String endpoint,
      Map<String, String> headers, Map<String, String> body) async {
    await dotenv.load(fileName: ".env");
    headers['Api-key'] = dotenv.env['DISCOURSE_API'] as String;
    headers['Api-Username'] = dotenv.env['DISCOURSE_USERNAME'] as String;

    final response = await http.post(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<dynamic> connectAndPut(String endpoint,
      Map<String, String> headers, Map<String, String> body) async {
    await dotenv.load(fileName: ".env");

    final response = await http.put(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<dynamic> connectAnDelete(String endpoint,
      Map<String, String> headers, Map<String, String> body) async {
    await dotenv.load(fileName: ".env");

    final response = await http.delete(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }
}
