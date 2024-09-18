class Level {
  late int id;
  late String name;

  Level.fromMap(Map<String, dynamic> map) {
    id = map['level_id'];
    name = (map['level'] ?? "").trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'level_id': id,
      'level': name,
    };
  }
}
