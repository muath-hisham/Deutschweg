class Adjective {
  late int id;
  late String adjective;
  late String adjTranslation;
  String? opposite;
  String? oppTranslation;
  late int lessonId;

  Adjective.fromMap(Map<String, dynamic> map) {
    id = map['adjective_id'];
    adjective = map['adjective'].trim();
    adjTranslation = map['adj_translation'].trim();
    opposite = map['opposite'].trim();
    oppTranslation = map['opp_translation'].trim();
    lessonId = map['lesson_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'adjective_id': id,
      'adjective': adjective,
      'adj_translation': adjTranslation,
      'opposite': opposite,
      'opp_translation': oppTranslation,
      'lesson_id': lessonId
    };
  }
}
