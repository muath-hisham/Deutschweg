import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class QuestionUpdate extends StatefulWidget {
  final Question question;
  const QuestionUpdate({super.key, required this.question});

  @override
  State<QuestionUpdate> createState() => _QuestionUpdateState();
}

class _QuestionUpdateState extends State<QuestionUpdate> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final quTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;
  // late String _lessonSelected;
  Lesson? selectedLesson;
  bool isFinishLoad = false;

  @override
  void initState() {
    super.initState();
    if (getLessonsList.isEmpty) isThereLessons = false;
    questionController.text = widget.question.question;
    quTranslationController.text = widget.question.quTranslation;
    _getData();
  }

  Future _getData() async {
    await getLessonById(widget.question.lessonId).then((lesson) {
      setState(() {
        selectedLesson = lesson;
      });
    });
    await getLevelsUndLessonsToUpdatePages(selectedLesson!.levelId);
    setState(() {
      isFinishLoad = true;
    });
  }

  Future _updateSentence() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int id = await sqlDb.updateData(
          '''
        UPDATE questions SET question = ?, translation = ?, lesson_id = ? WHERE question_id = ?''',
          [
            MyFunctions.clearTheText(questionController.text),
            MyFunctions.clearTheText(quTranslationController.text),
            selectedLesson!.id,
            widget.question.id
          ],
        );
        List<Map<String, dynamic>> li = await sqlDb.readData(
            "SELECT * FROM questions WHERE question_id = ${widget.question.id}");
        Question question = Question.fromMap(li.first);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QuestionDisplay(question: question)));
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
        title: Text(MyText.updateQuestion),
        centerTitle: true,
      ),
      body: isThereLessons && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereLessons
              ? Text(MyText.addLessons)
              : selectedLesson == null || isFinishLoad == false
                  ? Center(child: CircularProgressIndicator())
                  : _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.horizontal(50),
            vertical: Dimensions.vertical(50),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                controlsDesignToUpdatePages(
                  () => setState(() {}),
                  selectedLesson!,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputForm(
                  controller: questionController,
                  label: MyText.question,
                  error: MyText.enterTheQuestion,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabic(
                  controller: quTranslationController,
                  label: MyText.quTranslation,
                  error: MyText.enterTheTranslation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MaterialButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    MyText.update,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _updateSentence();
                  },
                ),
                SizedBox(height: Dimensions.height(25)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
