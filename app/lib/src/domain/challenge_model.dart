import 'package:daily_e/src/domain/media.dart';

class Challenge {
  final int id;
  final String documentId;
  final Media source;
  final String answer;

  Challenge({
    required this.id,
    required this.documentId,
    required this.source,
    required this.answer,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      documentId: json['documentId'],
      source: json['source'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'source': source.toMap(),
      'answer': answer,
    };
  }
}
