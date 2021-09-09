import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class ForumLogin {
  static String baseUrl = 'https://forum.freecodecamp.org';
  static Future<dynamic> getCSRF() async {
    final response =
        await http.get(Uri.parse(baseUrl + '/session/csrf'), headers: {
      'X-CSRF-Token': 'undefined',
      'Referer': baseUrl,
      'X-Requested-With': 'XMLHttpRequest'
    });

    if (response.statusCode == 200) {
      dev.log('Got CSRF token!');
    } else if (response.statusCode == 403) {
      throw Exception('403 error');
    } else {
      throw Exception(
          'Error during fetch status code:' + response.statusCode.toString());
    }
    String? encoded = jsonDecode(response.body)['csrf'];
    dev.log(encoded!);
    String decoded = utf8.decode(base64.decode(encoded));
    dev.log(decoded);
    return;
  }

  static Future<dynamic> discourseAuth(csrf, username, password) async {
    Map<String, String> headers = {
      "Origin": baseUrl,
      "Referer": baseUrl,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    Map<String, String> data = {
      "login": username,
      "password": password,
      "authenticity_token": csrf
    };

    final response = await http.post(Uri.parse(baseUrl + '/session'),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      String? cookie = response.headers['set-cookie'];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('@Discourse.loginCookie', cookie as String);
      return response;
    } else {
      dev.log(response.body);
    }
  }

  static Future<void> login(username, password) async {
    final response =
        await getCSRF().then((csrf) => discourseAuth(csrf, username, password));
  }
}
