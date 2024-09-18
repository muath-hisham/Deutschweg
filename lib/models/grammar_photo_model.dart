class GrammarPhoto {
  late int id;
  late String path;
  late int grammarId;

  GrammarPhoto.fromMap(Map<String, dynamic> map) {
    id = map['grammar_photo_id'];
    path = map['path'].toString().trim();
    grammarId = map['grammar_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'grammar_photo_id': id,
      'path': path,
      'grammar_id': grammarId,
    };
  }
}
