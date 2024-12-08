import 'package:daily_e/src/domain/media.dart';

class Topic {
  final int id;
  final String documentId;
  final String name;
  final String level;
  final Media thumbnail;

  Topic({
    required this.id,
    required this.documentId,
    required this.name,
    required this.level,
    required this.thumbnail,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      level: json['level'],
      thumbnail: Media.fromMap(json['thumbnail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'level': level,
      'thumbnail': thumbnail.toMap(),
    };
  }
}
