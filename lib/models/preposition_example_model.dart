class PrepositionExample {
  late int id;
  late String example;
  late String translation;
  late int prepositionId;

  PrepositionExample.fromMap(Map<String, dynamic> map) {
    id = map['preposition_example_id'];
    example = map['example'].trim();
    translation = map['translation'].trim();
    prepositionId = map['preposition_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'preposition_example_id': id,
      'example': example,
      'translation': translation,
      'preposition_id': prepositionId
    };
  }
}
