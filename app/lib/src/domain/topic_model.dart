import 'package:daily_e/src/domain/lesson_model.dart';
import 'package:daily_e/src/domain/media.dart';

class Topic {
  final int id;
  final String documentId;
  final String name;
  final String level;
  final Media thumbnail;
  final List<Lesson> lessons;

  Topic({
    required this.id,
    required this.documentId,
    required this.name,
    required this.level,
    required this.thumbnail,
    this.lessons = const [],
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      level: json['level'],
      thumbnail: Media.fromMap(json['thumbnail']),
      lessons: (json['lessions'] as List)
          .map((lesson) => Lesson.fromJson(lesson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'level': level,
      'thumbnail': thumbnail.toMap(),
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
