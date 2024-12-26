import 'dart:convert';
import 'package:daily_e/constant.dart';
import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:http/http.dart';

class LessonService {
  Future<List<Lesson>> getLessonsByTopic(
      String documentId, keyword, page, pageSize) async {
    Response response = await get(
        Uri.parse(
            '${API_URL.lessons}?populate[0]=challenges&filters[topic][documentId][\$eq]=$documentId&filters[name][\$contains]=$keyword&pagination[pageSize]=$pageSize&pagination[page]=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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

  Future<Lesson> getLessonById(String documentId) async {
    Response response =
        await get(Uri.parse('${API_URL.lessons}/$documentId'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Lesson.fromJson(data);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
