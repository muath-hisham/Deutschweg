class Sentence {
  late int id;
  late String sentence;
  late String translation;
  late int lessonId;

  Sentence.fromMap(Map<String, dynamic> map) {
    id = map['sentence_id'];
    sentence = map['sentence'].trim();
    translation = map['translation'].trim();
    lessonId = map['lesson_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sentence_id': id,
      'sentence': sentence,
      'translation': translation,
      'lesson_id': lessonId
    };
  }
}
