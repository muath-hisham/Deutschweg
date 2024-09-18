import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/screens/updates/update_lesson.dart';
import 'package:menschen/screens/pages/display_lessons.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  LessonCard({super.key, required this.lesson});

  SqlDb sqlDb = SqlDb();

  Future _deleteLesson(context) async {
    int ins = await sqlDb
        .deleteData("DELETE FROM lessons WHERE lesson_id = ${lesson.id}");
    if (ins == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(MyText.fail),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LessonsDisplay()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(8)),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(3),
        horizontal: Dimensions.horizontal(8),
      ),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        title: Text(lesson.name),
        subtitle: Text(lesson.level.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LessonUpdate(lesson: lesson)));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(MyText.deleteThislesson),
                      content: Text(MyText.areYouSure),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: Text(MyText.no),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(MyText.yes),
                          onPressed: () async => _deleteLesson(context),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
