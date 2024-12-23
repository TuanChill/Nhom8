class Note {
  int id;
  String documentId;
  String content;

  Note({
    required this.id,
    required this.documentId,
    required this.content,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      documentId: json['documentId'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'content': content,
    };
  }
}
