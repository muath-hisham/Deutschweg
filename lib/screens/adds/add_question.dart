import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({super.key});

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  final questionController = TextEditingController();
  final quTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;

  @override
  void initState() {
    super.initState();
    getLevels();
    if (getLessonsList.isEmpty) isThereLessons = false;
  }

  Future addQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int id = await sqlDb.insertData(
          '''
        INSERT INTO questions (question, translation, lesson_id) VALUES 
        (?, ?, ?)
      ''',
          [
            MyFunctions.clearTheText(questionController.text),
            MyFunctions.clearTheText(quTranslationController.text),
            int.parse(getLessonSelected),
          ],
        );
        List<Map<String, dynamic>> li = await sqlDb
            .readData("SELECT * FROM questions WHERE question_id = $id");
        Question question = Question.fromMap(li.first);
        // print(await sqlDb.readData("SELECT * FROM levels"));
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
        title: Text(MyText.addQuestions),
        centerTitle: true,
      ),
      body: isThereLessons && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereLessons
              ? Center(
                  child: Text(
                  MyText.addLessons,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
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
                controlsDesignToAddPages(() {
                  setState(() {});
                }),
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
                  child:
                      Text(MyText.add, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    addQuestion();
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
