class Preposition {
  late int id;
  late String preposition;
  late String function;

  Preposition.fromMap(Map<String, dynamic> map) {
    id = map['preposition_id'];
    preposition = map['preposition'].trim();
    function = map['function'].trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'preposition_id': id,
      'preposition': preposition,
      'function': function,
    };
  }
}
