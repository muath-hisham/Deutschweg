import 'level_model.dart';

class Lesson {
  late int id;
  late String name;
  late int levelId;

  late Level level;

  // Lesson.empty();

  Lesson.fromMap(Map<String, dynamic> map) {
    id = map['lesson_id'];
    name = map['lesson'].trim();
    levelId = map['level_id'];

    level = Level.fromMap(map);
  }

  Lesson.fromMapWithoutLevel(Map<String, dynamic> map) {
    id = map['lesson_id'];
    name = map['lesson'];
    levelId = map['level_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'lesson_id': id,
      'lesson': name,
      'level_id': levelId,
    };
  }
}
