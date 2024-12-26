import 'package:daily_e/constant.dart';
import 'package:daily_e/src/domain/Meta_data_dto.dart';
import 'package:daily_e/src/domain/challenge_model.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ChallengeService {
  Future<ChallengeResponse> getChallenge(String lessonId, int page) async {
    Response response = await get(
        Uri.parse(
            '${API_URL.challenges}?filters[lession][documentId][\$eq]=$lessonId&populate=*&pagination[page]=$page&pagination[pageSize]=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> challengesJson = data['data'];

      if (challengesJson.isNotEmpty) {
        Challenge challenge = Challenge.fromJson(challengesJson[0]);
        return ChallengeResponse(
            challenges: [challenge],
            metaData: MetaDataDto.fromJson(data['meta']['pagination']));
      } else {
        throw Exception("No challenges available");
      }
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<Challenge>> getChallenges(String lessonId) async {
    Response response = await get(
        Uri.parse(
            '${API_URL.challenges}?filters[lession][documentId][\$eq]=$lessonId&populate=*&pagination[page]=1&pagination[pageSize]=10000'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> challengesJson = data['data'];

      return challengesJson.map((json) => Challenge.fromJson(json)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
