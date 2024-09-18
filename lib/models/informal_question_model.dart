class InformalQuestion {
  late int id;
  late String informalQuestion;
  String? inforQuTranslation;
  String? informalAnswer;
  String? inforAnsTranslation;
  late int questionId;

  InformalQuestion.fromMap(Map<String, dynamic> map) {
    id = map['informal_question_id'];
    informalQuestion = map['informal_question'].trim();
    inforQuTranslation = map['infor_qu_translation'].trim();
    informalAnswer = map['informal_answer'].trim();
    inforAnsTranslation = map['infor_ans_translation'].trim();
    questionId = map['question_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'informal_question_id': id,
      'informal_question': informalQuestion,
      'infor_qu_translation': inforQuTranslation,
      'informal_answer': informalAnswer,
      'infor_ans_translation': inforAnsTranslation,
      'question_id': questionId
    };
  }
}
