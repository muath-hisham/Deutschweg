import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/level_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/sqldb.dart';

class MyFunctions {
  static final FlutterTts _flutterTts = FlutterTts();
  static final SqlDb _sqlDb = SqlDb();

  static Future<void> speak(String text) async {
    try {
      // Set language to German
      await _flutterTts.setLanguage("de-DE");

      // Set speech rate
      await _flutterTts.setSpeechRate(0.6);

      // Set pitch
      await _flutterTts.setPitch(0.8);

      // Set voice to a specific German male voice
      await _flutterTts
          .setVoice({"name": "de-de-x-gfn#male_1-local", "locale": "de-DE"});

      // Speak the provided text
      await _flutterTts.speak(text);
    } catch (e) {
      print("Error occurred while trying to speak: $e");
    }
  }

  static Future<List<Lesson>> getAllLessons() async {
    List<Map<String, dynamic>> li = await _sqlDb.readData(
        "SELECT * FROM lessons INNER JOIN levels ON lessons.level_id = levels.level_id");

    if (li.isNotEmpty) {
      List<Lesson> fetchedLessons = [];
      li.forEach((element) {
        fetchedLessons.add(Lesson.fromMap(element));
      });
      return fetchedLessons;
    }
    return [];
  }

  static Future<List<Lesson>> getLessons(String levelId) async {
    List<Map<String, dynamic>> li = await _sqlDb
        .readDataWithArg("SELECT * FROM lessons WHERE level_id = ?", [levelId]);

    if (li.isNotEmpty) {
      List<Lesson> fetchedLessons = [];
      li.forEach((element) {
        fetchedLessons.add(Lesson.fromMapWithoutLevel(element));
      });
      return fetchedLessons;
    }
    return [];
  }

  static Future<List<Level>> getLevels() async {
    List<Map<String, dynamic>> li =
        await _sqlDb.readData("SELECT * FROM levels");

    if (li.isNotEmpty) {
      List<Level> fetchedLevels = [];
      li.forEach((element) {
        fetchedLevels.add(Level.fromMap(element));
      });
      return fetchedLevels;
    }
    return [];
  }

  static String clearTheText(String text) {
    String clearText = text.trim();
    return clearText;
  }

  static Color colored(Word word) {
    if (word.artical == null || word.artical!.trim() == "") {
      return Colors.black;
    } else if (word.artical!.toLowerCase() == "der") {
      return derColor;
    } else if (word.artical!.toLowerCase() == "die") {
      return dieColor;
    } else if (word.artical!.toLowerCase() == "das") {
      return dasColor;
    } else {
      return Colors.black;
    }
  }
}
