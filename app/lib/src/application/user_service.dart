import 'dart:convert';

import 'package:daily_e/constant.dart';
import 'package:daily_e/src/domain/user_model.dart';
import 'package:http/http.dart';

class UserService {
  Future<UserLoginResponse> login(String identifier, String password) async {
    Response response = await post(
      Uri.parse(API_URL.login),
      body: {
        'identifier': identifier,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return UserLoginResponse.fromMap(jsonDecode(response.body));
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Response> register(String email, password, username, fullName) async {
    Response response = await post(
      Uri.parse(API_URL.register),
      body: {
        'email': email,
        'username': username,
        'password': password,
        'fullName': fullName,
      },
    );

    return response;
  }

  Future<Response> getUserById(
      String email, password, username, fullName) async {
    Response response = await post(
      Uri.parse(API_URL.register),
      body: {
        'email': email,
        'username': username,
        'password': password,
        'fullName': fullName,
      },
    );

    return response;
  }

  Future<Response> deleteUserById(String id) async {
    Response response = await delete(
      Uri.parse('${API_URL.users}/$id'),
    );

    print(response.body);

    return response;
  }
}
