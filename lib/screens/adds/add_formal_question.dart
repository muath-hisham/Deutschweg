import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/screens/pages/sentences_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddFormalQuestion extends StatefulWidget {
  final Question question;
  const AddFormalQuestion({super.key, required this.question});

  @override
  State<AddFormalQuestion> createState() => _AddFormalQuestionState();
}

class _AddFormalQuestionState extends State<AddFormalQuestion> {
  final _formKey = GlobalKey<FormState>();
  final forQuController = TextEditingController();
  final forQuTranslationController = TextEditingController();
  final forAnsController = TextEditingController();
  final forAnsTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addFormalQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO formal_question (formal_question, for_qu_translation, formal_answer, for_ans_translation, question_id) VALUES 
        (?, ?, ?, ?, ?)
      ''',
          [
            MyFunctions.clearTheText(forQuController.text),
            MyFunctions.clearTheText(forQuTranslationController.text),
            MyFunctions.clearTheText(forAnsController.text),
            MyFunctions.clearTheText(forAnsTranslationController.text),
            widget.question.id
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => QuestionDisplay(question: widget.question)));
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
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.addFormalQuestion),
        centerTitle: true,
      ),
      body: _body(),
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
                MyWidgets.inputForm(
                  controller: forQuController,
                  label: MyText.formalQuestion,
                  error: MyText.enterTheFormalQuestion,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabicOptional(
                  controller: forQuTranslationController,
                  label: MyText.translation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: forAnsController,
                  label: MyText.answer,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabicOptional(
                  controller: forAnsTranslationController,
                  label: MyText.translation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MaterialButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child:
                      Text(MyText.add, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    addFormalQuestion();
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
