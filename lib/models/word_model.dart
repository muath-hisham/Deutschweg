class Word {
  late int id;
  late String word;
  String? artical;
  late String translation;
  String? plural;
  String? feminine;
  late int lessonId;

  Word.impty();
  Word.fromMap(Map<String, dynamic> map) {
    id = map['word_id'];
    word = map['word'].trim();
    artical = map['artical'].trim();
    translation = map['translation'].trim();
    plural = map['plural'].trim();
    feminine = map['feminine'].trim();
    lessonId = map['lesson_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'word_id': id,
      'word': word,
      'artical': artical,
      'translation': translation,
      'plural': plural,
      'feminine': feminine,
      'lesson_id': lessonId
    };
  }
}
