class Lesson {
  int id;
  String documentId;
  String name;

  Lesson({
    required this.id,
    required this.documentId,
    required this.name,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
    };
  }
}
