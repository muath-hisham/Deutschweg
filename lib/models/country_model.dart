class Country {
  late int id;
  late String country;
  String? article;
  late String translation;
  String? nationality;
  String? language;

  Country.fromMap(Map<String, dynamic> map) {
    id = map['country_id'];
    country = map['country'].toString().trim();
    article = map['article'].toString().trim();
    translation = map['translation'].toString().trim();
    nationality = map['nationality'].toString().trim();
    language = map['language'].toString().trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'country_id': id,
      'country': country,
      'article': article,
      'translation': translation,
      'nationality': nationality,
      'language': language,
    };
  }
}
