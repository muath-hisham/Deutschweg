import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/screens/adds/add_lesson.dart';
import 'package:menschen/screens/shared/lesson_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class LessonsDisplay extends StatefulWidget {
  const LessonsDisplay({super.key});

  @override
  State<LessonsDisplay> createState() => _LessonsDisplayState();
}

class _LessonsDisplayState extends State<LessonsDisplay> {
  SqlDb sqlDb = SqlDb();
  List<Lesson> lessonsList = [];
  bool isThereLessons = true;

  @override
  void initState() {
    super.initState();
    _getLessons();
  }

  Future<void> _getLessons() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM lessons INNER JOIN levels ON lessons.level_id = levels.level_id");

    if (li.isNotEmpty) {
      List<Lesson> fetchedLessons = [];
      li.forEach((element) {
        fetchedLessons.add(Lesson.fromMap(element));
      });

      setState(() {
        lessonsList.clear();
        lessonsList.addAll(fetchedLessons);
      });
    } else {
      setState(() {
        isThereLessons = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.lessons),
        centerTitle: true,
      ),
      body: isThereLessons && lessonsList.isEmpty
          ? Center(child: SingleChildScrollView())
          : !isThereLessons
              ? Center(
                  child: Text(
                  MyText.addLessons,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddLesson()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(15),
        vertical: Dimensions.vertical(30),
      ),
      child: ListView.builder(
        itemCount: lessonsList.length,
        itemBuilder: (context, index) {
          return LessonCard(lesson: lessonsList[index]);
        },
      ),
    );
  }
}
