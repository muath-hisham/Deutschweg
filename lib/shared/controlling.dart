import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/level_model.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

List<Level> _levelsList = [];
List<Lesson> _lessonsList = [];
late String _levelSelected;
late String _lessonSelected;
bool isAllChecked = true;

List<Level> get getLevelsList => _levelsList;
List<Lesson> get getLessonsList => _lessonsList;
String get getLevelSelected => _levelSelected;
String get getLessonSelected => _lessonSelected;

SqlDb sqlDb = SqlDb();

set setLevelSelected(String levelSelected) => _levelSelected = levelSelected;

set setLessonSelected(String lessonSelected) =>
    _lessonSelected = lessonSelected;

Future getLevels() async {
  if (_levelsList.isEmpty) {
    _levelsList = await MyFunctions.getLevels();
    if (_levelsList.isNotEmpty) {
      _levelSelected = _levelsList[0].id.toString();
    }
    getLessons();
  }
}

Future getLessons() async {
  if (_lessonsList.isEmpty) {
    _lessonsList = await MyFunctions.getLessons(_levelSelected);
    if (_lessonsList.isNotEmpty) {
      _lessonSelected = _lessonsList[0].id.toString();
    }
  }
}

Future<Lesson> getLessonById(int id) async {
  List<Map<String, dynamic>> li = await sqlDb.readDataWithArg(
      "SELECT * FROM lessons INNER JOIN levels ON lessons.level_id = levels.level_id WHERE lesson_id = ?",
      [id]);

  return Lesson.fromMap(li.first);
}

void updateLessonsList(Function callback) async {
  _lessonsList = await MyFunctions.getLessons(_levelSelected);
  if (_lessonsList.isNotEmpty) {
    _lessonSelected = _lessonsList[0].id.toString();
  }
  callback();
}

void emptyLessonList() {
  _lessonsList = [];
}

Widget controlsDesignToViewPages(Function getWords) {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.horizontal(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: isAllChecked,
          onChanged: (value) {
            isAllChecked = value!;
            getWords();
          },
        ),
        Text(
          MyText.all,
          style: TextStyle(
            fontSize: Dimensions.fontSize(18),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: Dimensions.width(35)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: isAllChecked ? Colors.grey : Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: getLevelSelected,
            underline: SizedBox(),
            onChanged: isAllChecked
                ? null
                : (String? newValue) {
                    setLevelSelected = newValue!;
                    updateLessonsList(() {
                      getWords();
                    });
                  },
            items: getLevelsList.map((level) {
              return DropdownMenuItem<String>(
                value: level.id.toString(),
                child: Text(level.name),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: Dimensions.width(25)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: isAllChecked ? Colors.grey : Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: getLessonSelected,
            underline: SizedBox(),
            onChanged: isAllChecked
                ? null
                : (String? newValue) {
                    setLessonSelected = newValue!;
                    getWords();
                  },
            items: getLessonsList.map((lesson) {
              return DropdownMenuItem<String>(
                value: lesson.id.toString(),
                child: Text(lesson.name),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget controlsDesignToAddPages(Function setState) {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.horizontal(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: getLevelSelected,
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setLevelSelected = newValue!;
              updateLessonsList(() {
                setState();
              });
            },
            items: getLevelsList.map((level) {
              return DropdownMenuItem<String>(
                value: level.id.toString(),
                child: Text(level.name),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: Dimensions.width(25)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: getLessonSelected,
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setLessonSelected = newValue!;
              setState();
            },
            items: getLessonsList.map((lesson) {
              return DropdownMenuItem<String>(
                value: lesson.id.toString(),
                child: Text(lesson.name),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

List<Level> levelsToUpdate = [];
List<Lesson> lessonsToUpdate = [];
Future getLevelsUndLessonsToUpdatePages(int levelId) async {
  levelsToUpdate.clear();
  lessonsToUpdate.clear();
  await sqlDb
      .readData("SELECT * FROM levels")
      .then((list) => list.forEach((map) {
            levelsToUpdate.add(Level.fromMap(map));
          }));
  await sqlDb
      .readData("SELECT * FROM lessons WHERE level_id = $levelId")
      .then((list) => list.forEach((map) {
            lessonsToUpdate.add(Lesson.fromMapWithoutLevel(map));
          }));
}

void updateLessonsListToUpdatePages(
    Function callback, Lesson lessonSelected) async {
  lessonsToUpdate =
      await MyFunctions.getLessons(lessonSelected.level.id.toString());
  if (lessonsToUpdate.isNotEmpty) {
    lessonSelected.id = lessonsToUpdate[0].id;
  }
  callback();
}

Widget controlsDesignToUpdatePages(Function setState, Lesson lessonSelected) {
  return Container(
    margin: EdgeInsets.only(top: Dimensions.horizontal(20)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Dropdown for Levels
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: lessonSelected.level.id.toString(),
            underline: SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                lessonSelected.level.id = int.parse(newValue);
                // Update lessons list and trigger UI update
                updateLessonsListToUpdatePages(() {
                  setState();
                }, lessonSelected);
              }
            },
            items: levelsToUpdate.map((level) {
              return DropdownMenuItem<String>(
                value: level.id.toString(),
                child: Text(level.name),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: Dimensions.width(25)),
        // Dropdown for Lessons
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(10)),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 0.6,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: lessonSelected.id != null ? lessonSelected.id.toString() : null,
            underline: SizedBox(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                lessonSelected.id = int.parse(newValue);
                setState();
              }
            },
            items: lessonsToUpdate.map((lesson) {
              return DropdownMenuItem<String>(
                value: lesson.id.toString(),
                child: Text(lesson.name),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
