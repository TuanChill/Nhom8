import 'package:daily_e/src/domain/Meta_data_dto.dart';
import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:daily_e/src/domain/media.dart';

class Challenge {
  final int id;
  final String documentId;
  final Media source;
  final String answer;
  final Lesson lesson;

  Challenge({
    required this.id,
    required this.documentId,
    required this.source,
    required this.answer,
    required this.lesson,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      documentId: json['documentId'],
      source: json['source'] != null
          ? Media.fromMap(json['source'])
          : Media(
              id: 0,
              documentId: '',
              name: '',
              url: '',
            ),
      answer: json['answer'],
      lesson: Lesson.fromJson(json['lession']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'source': source.toMap(),
      'answer': answer,
      'lesson': lesson.toJson(),
    };
  }
}

class ChallengeResponse {
  List<Challenge> challenges;
  MetaDataDto metaData;

  ChallengeResponse({
    required this.challenges,
    required this.metaData,
  });

  // setters
  setChallenges(List<Challenge> challenges) {
    this.challenges = challenges;
  }

  setMetaData(MetaDataDto metaData) {
    this.metaData = metaData;
  }
}
