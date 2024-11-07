import 'dart:convert';

import 'package:daily_e/src/domain/lession_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _key_token = 'token';

class SecureStorage {
  // Create storage
  final storage = new FlutterSecureStorage();

  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal();

  Future<void> saveToken(String token) async {
    await storage.write(key: _key_token, value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: _key_token);
  }

  Future<void> removeToken() async {
    await storage.delete(key: _key_token);
  }
}
