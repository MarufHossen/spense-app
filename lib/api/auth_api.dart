// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../model/auth.dart';

class AuthApi {
  static const String loginEndpointParam = '/login';
  static const String signUpEndpointParam = '/signup';
  static Future<Auth> login(Auth auth) async {
    Map<String, String> requestBody = {};
    requestBody["email"] = auth.email;
    requestBody["password"] = auth.password;
    String json = jsonEncode(requestBody);
    http.Response response = await http.post(
        Uri.https(baseApiUrl, loginEndpointParam),
        headers: {"Content-Type": "application/json"},
        body: json);
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    print(responseMap);

    if (responseMap["status"] == true) {
      // Auth auth = Auth(responseMap["data"]["email"], responseMap["data"]["password"]);
      Auth response = Auth.fromJson(responseMap["data"]);
      response.success = true;
      return response;
    }
    auth.success = false;
    return auth;
  }

  static Future<Auth> register(Auth auth) async {
    Map<String, String> requestBody = {};
    requestBody["name"] = auth.name!;
    requestBody["email"] = auth.email;
    requestBody["password"] = auth.password;
    String json = jsonEncode(requestBody);
    http.Response response = await http.post(
        Uri.https(baseApiUrl, signUpEndpointParam),
        headers: {"Content-Type": "application/json"},
        body: json);
    Map<String, dynamic> responseMap = jsonDecode(response.body);
    print(responseMap);

    if (responseMap["status"] == true) {
      // Auth auth = Auth(responseMap["data"]["email"], responseMap["data"]["password"]);
      Auth response = Auth.fromJson(responseMap["data"]);
      response.success = true;
      return response;
    }
    auth.success = false;
    return auth;
  }
}
