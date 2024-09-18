class FormalQuestion {
  late int id;
  late String formalQuestion;
  String? forQuTranslation;
  String? formalAnswer;
  String? forAnsTranslation;
  late int questionId;

  FormalQuestion.fromMap(Map<String, dynamic> map) {
    id = map['formal_question_id'];
    formalQuestion = map['formal_question'].trim();
    forQuTranslation = map['for_qu_translation'].trim();
    formalAnswer = map['formal_answer'].trim();
    forAnsTranslation = map['for_ans_translation'].trim();
    questionId = map['question_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'formal_question_id': id,
      'formal_question': formalQuestion,
      'for_qu_translation': forQuTranslation,
      'formal_answer': formalAnswer,
      'for_ans_translation': forAnsTranslation,
      'question_id': questionId
    };
  }
}
