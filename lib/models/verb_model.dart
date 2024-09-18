class Verb {
  late int id;
  late String verb;
  late String translation;
  late String ich;
  late String du;
  late String er;
  late String wir;
  late String ihr;
  late String sie;
  late String partizipTwo;
  late String imperative;
  late bool dativ;
  late String perfekt;
  late String prateritumIch;
  late String prateritumDu;
  late String prateritumEr;
  late String prateritumWir;
  late String prateritumIhr;
  late String prateritumSie;
  late int lessonId;

  Verb.fromMap(Map<String, dynamic> map) {
    id = map['verb_id'];
    verb = map['verb'].toString().trim();
    translation = map['translation'].toString().trim();

    ich = (map['ich'] ?? '').toString().trim();
    du = (map['du'] ?? '').toString().trim();
    er = (map['er'] ?? '').toString().trim();
    wir = (map['wir'] ?? '').toString().trim();
    ihr = (map['ihr'] ?? '').toString().trim();
    sie = (map['sie'] ?? '').toString().trim();

    partizipTwo = (map['partizip_two'] ?? '').toString().trim();
    imperative = (map['imperative'] ?? '').toString().trim();
    dativ = (map['dativ'] ?? 0) == 1;
    perfekt = (map['perfekt'] ?? '').toString().trim();

    prateritumIch = (map['prateritum_ich'] ?? '').toString().trim();
    prateritumDu = (map['prateritum_du'] ?? '').toString().trim();
    prateritumEr = (map['prateritum_er'] ?? '').toString().trim();
    prateritumWir = (map['prateritum_wir'] ?? '').toString().trim();
    prateritumIhr = (map['prateritum_ihr'] ?? '').toString().trim();
    prateritumSie = (map['prateritum_sie'] ?? '').toString().trim();

    lessonId = map['lesson_id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'verb_id': id,
      'verb': verb,
      'translation': translation,
      'ich': ich,
      'du': du,
      'er': er,
      'wir': wir,
      'ihr': ihr,
      'sie': sie,
      'partizip_two': partizipTwo,
      'imperative': imperative,
      'dativ': dativ,
      'perfekt': perfekt,
      'prateritum_ich': prateritumIch,
      'prateritum_du': prateritumDu,
      'prateritum_er': prateritumEr,
      'prateritum_wir': prateritumWir,
      'prateritum_ihr': prateritumIhr,
      'prateritum_sie': prateritumSie,
      'lesson_id': lessonId
    };
  }
}
