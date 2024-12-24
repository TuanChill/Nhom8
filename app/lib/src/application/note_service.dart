import 'dart:convert';

import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/domain/note_model.dart';
import 'package:http/http.dart';

class NoteService {
  Future<Response> createNote(String text, int challengeId) async {
    String? token = await SecureStorage().getToken();

    String? userId = await SecureStorage().getUserId();

    try {
      Response res = await post(Uri.parse(API_URL.notes),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "data": {
              "content": text,
              "challenge": challengeId,
              "users_permissions_user": userId
            }
          }));

      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Response> updateNote(String text, String documentId) async {
    String? token = await SecureStorage().getToken();

    try {
      Response res = await put(Uri.parse('${API_URL.notes}/$documentId'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer $token"
          },
          body: jsonEncode({
            "data": {
              "content": text,
            }
          }));

      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Note>> getNotes(String challengeId) async {
    String? token = await SecureStorage().getToken();
    String? userId = await SecureStorage().getUserId();

    Response response = await get(
        Uri.parse(
            '${API_URL.notes}?populate[0]=challenge&filters[challenge][documentId][\$eq]=$challengeId&pagination[pageSize]=100&pagination[page]=1&filters[users_permissions_user][id][\$eq]=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> topicsJson = data['data'];

      // Deserialize the list of topics
      List<Note> topics =
          topicsJson.map((json) => Note.fromJson(json)).toList();
      return topics;
    } else {
      print(response);
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Response> deleteNotes(String noteId) async {
    String? token = await SecureStorage().getToken();

    try {
      Response res =
          await delete(Uri.parse('${API_URL.notes}/$noteId'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token"
      });

      return res;
    } catch (e) {
      throw Exception(e);
    }
  }
}
