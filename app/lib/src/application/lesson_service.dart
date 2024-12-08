import 'dart:convert';
import 'package:daily_e/constant.dart';
import 'package:daily_e/src/application/storage.dart';
import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:http/http.dart';

class LessonService {
  Future<List<Lesson>> getLessonsByTopic(String documentId, keyword) async {
    String? token = await SecureStorage().getToken();
    Response response = await get(
        Uri.parse(
            '${API_URL.lessons}?populate[0]=challenges&filters[topic][documentId][\$eq]=$documentId&filters[name][\$contains]=$keyword'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token ?? '',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> lessonsJson = data['data'];

      List<Lesson> lessons =
          lessonsJson.map((json) => Lesson.fromJson(json)).toList();
      return lessons;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
