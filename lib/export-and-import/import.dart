import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:menschen/models/adjective_mode.dart';
import 'package:menschen/models/answer_model.dart';
import 'package:menschen/models/color_model.dart';
import 'package:menschen/models/country_model.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/models/informal_question_model.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/level_model.dart';
import 'package:menschen/models/preposition_example_model.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/progress_dialog.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

Future<void> pickData(BuildContext context) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result != null && result.files.isNotEmpty) {
    String jsonFilePath = result.files.first.path!;
    try {
      String jsonData = await File(jsonFilePath).readAsString();
      await _importData(context, jsonData);
      print("Data imported successfully!");
    } catch (e) {
      print("Error importing data: $e");
      _showErrorDialog(context, MyText.dataError);
    }
  }
}

Future<void> _importData(BuildContext context, String data) async {
  SqlDb sqlDb = SqlDb();
  Map<String, dynamic> allData;

  ValueNotifier<double> progress = ValueNotifier<double>(0.0);
  _showProgressDialog(context, progress);

  try {
    allData = jsonDecode(data) as Map<String, dynamic>;
  } catch (e) {
    print("Error parsing data: $e");
    Navigator.of(context, rootNavigator: true).pop(); // Hide progress dialog
    _showErrorDialog(context, MyText.dataError);
    return;
  }

  Map<MyTable, List<Map<String, dynamic>>> tableDataMap = {
    MyTable.levels: [],
    MyTable.lessons: [],
    MyTable.words: [],
    MyTable.verbs: [],
    MyTable.sentences: [],
    MyTable.questions: [],
    MyTable.prepositions: [],
    MyTable.prepositionExamples: [],
    MyTable.adjectives: [],
    MyTable.questionAnswers: [],
    MyTable.formalQuestions: [],
    MyTable.informalQuestions: [],
    MyTable.grammer: [],
    MyTable.colors: [],
    MyTable.countries: [],
  };

  tableDataMap.forEach((tableEnum, list) {
    final tableName = getMyTableName(tableEnum);
    if (allData[tableName] != null) {
      list.addAll((allData[tableName] as List).cast<Map<String, dynamic>>());
    }
  });

  if (tableDataMap.values.every((list) => list.isEmpty)) {
    print("No data to import");
    Navigator.of(context, rootNavigator: true).pop(); // Hide progress dialog
    return;
  }

  await sqlDb.deleteDataBase();

  int totalItems =
      tableDataMap.values.fold(0, (sum, list) => sum + list.length);
  int processedItems = 0;

  for (MyTable tableEnum in MyTable.values) {
    String tableName = getMyTableName(tableEnum);

    try {
      switch (tableEnum) {
        case MyTable.levels:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Level.fromMap);
          break;
        case MyTable.lessons:
          await _insertData(sqlDb, tableDataMap[tableEnum]!, tableName,
              Lesson.fromMapWithoutLevel);
          break;
        case MyTable.words:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Word.fromMap);
          break;
        case MyTable.verbs:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Verb.fromMap);
          break;
        case MyTable.sentences:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Sentence.fromMap);
          break;
        case MyTable.questions:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Question.fromMap);
          break;
        case MyTable.prepositions:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Preposition.fromMap);
          break;
        case MyTable.prepositionExamples:
          await _insertData(sqlDb, tableDataMap[tableEnum]!, tableName,
              PrepositionExample.fromMap);
          break;
        case MyTable.adjectives:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Adjective.fromMap);
          break;
        case MyTable.questionAnswers:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Answer.fromMap);
          break;
        case MyTable.formalQuestions:
          await _insertData(sqlDb, tableDataMap[tableEnum]!, tableName,
              FormalQuestion.fromMap);
          break;
        case MyTable.informalQuestions:
          await _insertData(sqlDb, tableDataMap[tableEnum]!, tableName,
              InformalQuestion.fromMap);
          break;
        case MyTable.grammer:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Grammar.fromMap);
          break;
        case MyTable.colors:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, MyColor.fromMap);
          break;
        case MyTable.countries:
          await _insertData(
              sqlDb, tableDataMap[tableEnum]!, tableName, Country.fromMap);
          break;
      }
    } catch (e) {
      print("Error in $tableName: $e");
      _showErrorDialog(context, MyText.dataError);
    }

    processedItems += tableDataMap[tableEnum]!.length;
    progress.value = processedItems / totalItems;
  }

  Navigator.of(context, rootNavigator: true).pop(); // Hide progress dialog

  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.bottomSlide,
    desc: MyText.importCompletedSuccessfully,
  ).show();
}

Future<List<String>> _getColumnNames(SqlDb sqlDb, String tableName) async {
  final result = await sqlDb.readData('PRAGMA table_info($tableName)');
  return result.map((row) => row['name'] as String).toList();
}

Future<void> _insertData<T>(SqlDb sqlDb, List<Map<String, dynamic>> dataList,
    String tableName, T Function(Map<String, dynamic>) fromMap) async {
  // Get existing columns in the table
  List<String> columns = await _getColumnNames(sqlDb, tableName);

  for (var row in dataList) {
    try {
      T data = fromMap(row);

      // Filter columns and values based on existing columns
      final filteredRow = Map.fromEntries(
          row.entries.where((entry) => columns.contains(entry.key)));

      String columnNames = filteredRow.keys.join(', ');
      String placeholders =
          List.filled(filteredRow.keys.length, '?').join(', ');

      await sqlDb.insertData(
        'INSERT INTO $tableName ($columnNames) VALUES ($placeholders)',
        filteredRow.values.toList(),
      );
    } catch (e) {
      print('Error inserting data into $tableName: $e');
      // Handle error, possibly continue to next iteration or rethrow
    }
  }
}

void _showProgressDialog(BuildContext context, ValueNotifier<double> progress) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ProgressDialog(progress: progress);
    },
  );
}

void _showErrorDialog(BuildContext context, String message) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.bottomSlide,
    desc: message,
  ).show();
}
