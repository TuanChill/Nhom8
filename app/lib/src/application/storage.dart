import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _key_token = 'token';
const String _key_user_id = 'user_id';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

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

  Future<void> clear() async {
    await storage.deleteAll();
  }

  Future<String?> getUserId() async {
    String? value = (await storage.read(key: _key_user_id));
    return value;
  }

  Future<void> saveUserId(int value) async {
    await storage.write(key: _key_user_id, value: value.toString());
  }
}
