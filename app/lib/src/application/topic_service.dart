import 'package:daily_e/constant.dart';
import 'package:daily_e/src/domain/topic_model.dart';
import 'package:http/http.dart';
import 'dart:convert';

class TopicService {
  Future<List<Topic>> getTopics() async {
    Response response =
        await get(Uri.parse('${API_URL.topics}?populate=*'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> topicsJson = data['data'];

      // Deserialize the list of topics
      List<Topic> topics =
          topicsJson.map((json) => Topic.fromJson(json)).toList();
      return topics;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
