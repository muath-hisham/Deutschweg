// to search
enum Option { word, verb, sentence, question, preposition, color }

String getOptionName(Option option) {
  switch (option) {
    case Option.word:
      return "word";
    case Option.verb:
      return "verb";
    case Option.sentence:
      return "sentence";
    case Option.question:
      return "question";
    case Option.preposition:
      return "preposition";
    case Option.color:
      return "color";
    default:
      return "";
  }
}

enum MyTable {
  levels,
  lessons,
  words,
  verbs,
  sentences,
  questions,
  prepositions,
  prepositionExamples,
  adjectives,
  questionAnswers,
  formalQuestions,
  informalQuestions,
  grammer,
  colors,
  countries
}

String getMyTableName(MyTable table) {
  switch (table) {
    case MyTable.levels:
      return "levels";
    case MyTable.lessons:
      return "lessons";
    case MyTable.words:
      return "words";
    case MyTable.verbs:
      return "verbs";
    case MyTable.sentences:
      return "sentences";
    case MyTable.questions:
      return "questions";
    case MyTable.prepositions:
      return "prepositions";
    case MyTable.prepositionExamples:
      return "preposition_examples";
    case MyTable.adjectives:
      return "adjectives";
    case MyTable.questionAnswers:
      return "question_answers";
    case MyTable.formalQuestions:
      return "formal_question";
    case MyTable.informalQuestions:
      return "informal_question";
    case MyTable.grammer:
      return "grammar";
    case MyTable.colors:
      return "colors";
    case MyTable.countries:
      return "countries";
  }
}
