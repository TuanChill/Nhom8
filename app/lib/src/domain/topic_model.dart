class Topic {
  final String id;
  final String documentId;
  final String name;
  final String level;
  final String thumbnail;

  Topic(
      {required this.id,
      required this.documentId,
      required this.name,
      required this.level,
      required this.thumbnail});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      level: json['level'],
      thumbnail: json['thumbnail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'level': level,
      'thumbnail': thumbnail,
    };
  }
}
