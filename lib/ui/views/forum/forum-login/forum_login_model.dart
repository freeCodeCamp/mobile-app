import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import 'dart:developer' as dev;

class ForumLoginModel extends BaseViewModel {
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
      dev.log(response.headers.toString());
    } else if (response.statusCode == 403) {
      throw Exception('403 error');
    } else {
      throw Exception(
          'Error during fetch status code:' + response.statusCode.toString());
    }
    String? csrf = jsonDecode(response.body)['csrf'];
    String headers = jsonEncode(response.headers);
    dynamic cookie = jsonDecode(headers)['set-cookie'];
    return [csrf, cookie];
  }

  static Future<dynamic> discourseAuth(csrf, username, password, cookie) async {
    Map<String, String> headers = {
      "X-CSRF-Token": csrf,
      "Cookie": cookie,
      'X-Requested-With': 'XMLHttpRequest',
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
    };

    final response = await http.post(
        Uri.parse(baseUrl + '/session?login=$username&password=$password'),
        headers: headers);

    if (response.statusCode == 200) {
      dev.log(response.body);
      return response.body;
    } else {
      dev.log(response.body);
    }
  }

  static Future<void> login(username, password) async {
    getCSRF()
        .then((keys) => {discourseAuth(keys[0], username, password, keys[1])});
  }
}
