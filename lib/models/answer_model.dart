class Answer {
  late int id;
  late String answer;
  String? ansTranslation;
  late int questionId;

  Answer.fromMap(Map<String, dynamic> map) {
    id = map['question_answer_id'];
    answer = map['answer'].trim();
    ansTranslation = map['ans_translation'].trim();
    questionId = map['question_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'question_answer_id': id,
      'answer': answer,
      'ans_translation': ansTranslation,
      'question_id': questionId
    };
  }
}
