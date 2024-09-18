class MyColor {
  late int id;
  late String color;
  late String translation;

  MyColor.fromMap(Map<String, dynamic> map) {
    id = map['color_id'];
    color = map['color'].toString().trim();
    translation = map['translation'].toString().trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'color_id': id,
      'color': color,
      'translation': translation,
    };
  }
}
