import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/screens/pages/display_lessons.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class LessonUpdate extends StatefulWidget {
  final Lesson lesson;
  const LessonUpdate({super.key, required this.lesson});

  @override
  State<LessonUpdate> createState() => _LessonUpdateState();
}

class _LessonUpdateState extends State<LessonUpdate> {
  final _formKey = GlobalKey<FormState>();
  final lessonController = TextEditingController();
  late String _levelSelected;
  SqlDb sqlDb = SqlDb();
  bool isThereLevels = true;
  List<Map> levels = [];

  @override
  void initState() {
    super.initState();
    _getLevels();
    lessonController.text = widget.lesson.name;
  }

  Future<void> _getLevels() async {
    List<Map> li = await sqlDb.readData("SELECT * FROM levels");
    if (li.isEmpty) {
      setState(() {
        isThereLevels = false;
      });
      return;
    }
    setState(() {
      levels = li;
      _levelSelected = widget.lesson.level.id.toString();
    });
  }

  Future _updateLesson(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int ins = await sqlDb.updateData(
          "UPDATE lessons SET lesson = ?, level_id = ? WHERE lesson_id = ?",
          [
            MyFunctions.clearTheText(lessonController.text),
            int.parse(_levelSelected),
            widget.lesson.id,
          ],
        );
        // pop and replasment
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LessonsDisplay()));
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          desc: MyText.somethingWrong,
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        desc: MyText.pleaseEnterAllData,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyText.updateLesson),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
              child: isThereLevels && levels.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : !isThereLevels
                      ? Center(child: Text(MyText.addLevels))
                      : _form(),
            ),
          ),
        ));
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    MyText.level,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontal(10)),
                  margin: EdgeInsets.all(Dimensions.horizontal(10)),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 0.6), // Add border
                    borderRadius: BorderRadius.circular(5), // Set border radius
                  ),
                  child: DropdownButton<String>(
                    value: _levelSelected,
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _levelSelected = newValue!;
                      });
                    },
                    items: levels.map((map) {
                      return DropdownMenuItem<String>(
                        value: map['level_id']!.toString(),
                        child: Text(map['level']!), // Display the name
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height(25)),
          TextFormField(
            controller: lessonController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return MyText.enterTheLesson;
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: MyText.lesson),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.update, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _updateLesson(context);
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
