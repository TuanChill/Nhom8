import 'dart:convert';

import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/storage.dart';
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

  Future<Response> getUserById(String id) async {
    Response response = await get(
      Uri.parse('${API_URL.users}/$id'),
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

  Future<Response> updateUser(String email, age, gender, fullName) async {
    String? token = await SecureStorage().getToken();
    String? userId = await SecureStorage().getUserId();

    Response response = await put(
      Uri.parse("${API_URL.users}/$userId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(
          {'email': email, 'fullName': fullName, 'age': age, "gender": gender}),
    );

    return response;
  }

  Future<Response> sendOtp(String email) async {
    Response response = await post(
      Uri.parse(API_URL.sendOtp),
      body: {'email': email},
    );

    return response;
  }

  Future<Response> resetPassword(String email, otp, password) async {
    Response response = await post(
      Uri.parse(API_URL.sendOtp),
      body: {'email': email, "otp": otp, "password": password},
    );

    return response;
  }
}
