import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    _db ??= await intialDb();
    return _db;
  }

  Database? get dbPrivate => _db;

  intialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'menschen.db'); // name of database
    Database mydb = await openDatabase(path, onCreate: _onCreate, version: 1);
    return mydb;
  }

  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
      CREATE TABLE 'levels' (
        'level_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'level' TEXT 
      )
    ''');

    batch.execute('''
      CREATE TABLE 'lessons' (
        'lesson_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'lesson' TEXT,
        'level_id' INTEGER,
        FOREIGN KEY (level_id) REFERENCES levels (level_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'words' (
        'word_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'word' TEXT,
        'artical' TEXT,
        'translation' TEXT,
        'plural' TEXT,
        'feminine' Text,
        'lesson_id' INTEGER,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'verbs' (
        'verb_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'verb' TEXT,
        'translation' TEXT,
        'ich' TEXT,
        'du' TEXT,
        'er' TEXT,
        'wir' TEXT,
        'ihr' TEXT,
        'sie' TEXT,
        'partizip_two' TEXT,
        'imperative' TEXT,
        'dativ' INTEGER,
        'perfekt' TEXT,
        'prateritum_ich' TEXT,
        'prateritum_du' TEXT,
        'prateritum_er' TEXT,
        'prateritum_wir' TEXT,
        'prateritum_ihr' TEXT,
        'prateritum_sie' TEXT,
        'lesson_id' INTEGER,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'countries' (
        'country_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'country' TEXT,
        'translation' TEXT,
        'article' TEXT,
        'nationality' TEXT,
        'language' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'grammar' (
        'grammar_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'name' TEXT,
        'grammar' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'grammar_photos' (
        'grammar_photo_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'grammar_id' INTEGER,
        'path' TEXT,
        FOREIGN KEY (grammar_id) REFERENCES grammar (grammar_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'conversations' (
        'conversation_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'conversation' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'colors' (
        'color_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'color' TEXT,
        'translation' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'sentences' (
        'sentence_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'sentence' TEXT,
        'translation' TEXT,
        'lesson_id' INTEGER,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'questions' (
        'question_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'question' TEXT,
        'translation' TEXT,
        'lesson_id' INTEGER,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'prepositions' (
        'preposition_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'preposition' TEXT,
        'function' TEXT
      )
    ''');

    batch.execute('''
      CREATE TABLE 'preposition_examples' (
        'preposition_example_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'example' TEXT,
        'translation' TEXT,
        'preposition_id' INTEGER,
        FOREIGN KEY (preposition_id) REFERENCES prepositions (preposition_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'adjectives' (
        'adjective_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'adjective' TEXT,
        'adj_translation' TEXT,
        'opposite' TEXT,
        'opp_translation' TEXT,
        'lesson_id' INTEGER,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)                  
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'question_answers' (
        'question_answer_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'answer' TEXT,
        'ans_translation' TEXT,
        'question_id' INTEGER,
        FOREIGN KEY (question_id) REFERENCES questions (question_id)
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'formal_question' (
        'formal_question_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'formal_question' TEXT,
        'for_qu_translation' TEXT,
        'formal_answer' TEXT,
        'for_ans_translation' TEXT,
        'question_id' INTEGER,
        FOREIGN KEY (question_id) REFERENCES questions (question_id)
        ON DELETE CASCADE
      )
    ''');

    batch.execute('''
      CREATE TABLE 'informal_question' (
        'informal_question_id' INTEGER PRIMARY KEY AUTOINCREMENT,
        'informal_question' TEXT,
        'infor_qu_translation' TEXT,
        'informal_answer' TEXT,
        'infor_ans_translation' TEXT,
        'question_id' INTEGER,
        FOREIGN KEY (question_id) REFERENCES questions (question_id)
        ON DELETE CASCADE
      )
    ''');

    await batch.commit();
    print("db created ===============================");
  }

  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  Future<List<Map<String, dynamic>>> readDataWithArg(
      String sql, List list) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql, list);
    return response;
  }

  Future<int> insertData(String sql, List list) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql, list);
    return response;
  }

  Future<int> updateData(String sql, List<Object> list) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql, list);
    return response;
  }

  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<int> deletePath(String sql, List list) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql, list);
    return response;
  }

  Future<int> deleteAll(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.delete(sql);
    return response;
  }

  deleteDataBase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'menschen.db'); // name of database
    await deleteDatabase(path);
    print("deleted success");
    _db = await intialDb();
  }
}
