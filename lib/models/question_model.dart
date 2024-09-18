class Question {
  late int id;
  late String question;
  late String quTranslation;
  late int lessonId;

  Question.fromMap(Map<String, dynamic> map) {
    id = map['question_id'];
    question = (map['question'] ?? '').toString().trim();
    quTranslation = (map['translation'] ?? '').toString().trim();
    lessonId = map['lesson_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'question_id': id,
      'question': question,
      'translation': quTranslation,
      'lesson_id': lessonId
    };
  }
}
