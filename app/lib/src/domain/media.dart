class Media {
  int id;
  String documentId;
  String name;
  String url;

  Media({
    required this.id,
    required this.documentId,
    required this.name,
    required this.url,
  });

  factory Media.fromMap(Map<String, dynamic> map) {
    return Media(
      id: map['id'],
      documentId: map['documentId'],
      name: map['name'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentId,
      'name': name,
      'url': url,
    };
  }
}
