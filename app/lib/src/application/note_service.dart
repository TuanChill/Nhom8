import 'dart:convert';

import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/domain/note_model.dart';
import 'package:http/http.dart';

class NoteService {
  Future<Response> createNote(String text, int challengeId) async {
    String? token = await SecureStorage().getToken();

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
            }
          }));

      return res;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Note>> getNotes() async {
    String? token = await SecureStorage().getToken();

    Response response =
        await get(Uri.parse('${API_URL.topics}?populate=*'), headers: {
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
      throw Exception(response.reasonPhrase);
    }
  }
}
