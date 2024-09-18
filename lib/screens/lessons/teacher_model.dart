class Teacher {
  late String name;
  late String image;
  late List<Map<String, String>> chapters;

  Teacher.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    image = map['image'].trim();
    chapters = map['chapters'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'chapters': chapters,
    };
  }
}
