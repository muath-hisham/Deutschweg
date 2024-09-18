class Grammar {
  late int id;
  late String name;
  late String grammar;

  Grammar.fromMap(Map<String, dynamic> map) {
    id = map['grammar_id'];
    name = map['name'].toString().trim();
    grammar = (map['grammar'] ?? "").toString().trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'grammar_id': id,
      'name': name,
      'grammar': grammar,
    };
  }
}
