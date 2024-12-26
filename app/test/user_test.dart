import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

/// Hàm logic chính (thay vì UserService)
Future<String> login(String email, String password, {Client? client}) async {
  client ??= Client();
  final response = await client.post(
    Uri.parse('https://orderly-poem-b4e978fec1.strapiapp.com/api/auth/login'),
    body: jsonEncode({'identifier': email, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['user']['username'];
  } else {
    throw Exception('Login failed');
  }
}

Future<Response> register(
  String email,
  String password,
  String username,
  String fullName, {
  Client? client,
}) async {
  client ??= Client();
  final response = await client.post(
    Uri.parse(
        'https://orderly-poem-b4e978fec1.strapiapp.com/api/auth/register'),
    body: jsonEncode({
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  return response;
}

void main() {
  group('Login', () {
    test('returns username when login is successful', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'user': {
              'id': 1,
              'email': 'test@example.com',
              'username': 'testuser'
            }
          }),
          200,
        );
      });

      // Act
      final username = await login(
        'test@example.com',
        'password123',
        client: mockHTTPClient,
      );

      // Assert
      expect(username, equals('testuser'));
    });

    test('throws Exception when login fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Invalid credentials', 401);
      });

      // Act & Assert
      expect(
        () => login(
          'test@example.com',
          'wrongpassword',
          client: mockHTTPClient,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('Register', () {
    test('returns Response when registration is successful', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response(
          jsonEncode({
            'user': {
              'id': 1,
              'email': 'test@example.com',
              'username': 'testuser',
              'fullName': 'Test User'
            }
          }),
          200,
        );
      });

      // Act
      final response = await register(
        'test@example.com',
        'password123',
        'testuser',
        'Test User',
        client: mockHTTPClient,
      );

      // Assert
      expect(response.statusCode, equals(200));
      expect(
        jsonDecode(response.body),
        equals({
          'user': {
            'id': 1,
            'email': 'test@example.com',
            'username': 'testuser',
            'fullName': 'Test User'
          }
        }),
      );
    });

    test('returns error Response when registration fails', () async {
      // Arrange
      final mockHTTPClient = MockClient((request) async {
        return Response('Email already exists', 400);
      });

      // Act
      final response = await register(
        'test@example.com',
        'password123',
        'testuser',
        'Test User',
        client: mockHTTPClient,
      );

      // Assert
      expect(response.statusCode, equals(400));
      expect(response.body, equals('Email already exists'));
    });
  });
}
