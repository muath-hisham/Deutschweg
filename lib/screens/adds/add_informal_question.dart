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

class AddInformalQuestion extends StatefulWidget {
  final Question question;
  const AddInformalQuestion({super.key, required this.question});

  @override
  State<AddInformalQuestion> createState() => _AddInformalQuestionState();
}

class _AddInformalQuestionState extends State<AddInformalQuestion> {
  final _formKey = GlobalKey<FormState>();
  final inforQuController = TextEditingController();
  final inforQuTranslationController = TextEditingController();
  final inforAnsController = TextEditingController();
  final inforAnsTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addFormalQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO informal_question (informal_question, infor_qu_translation, informal_answer, infor_ans_translation, question_id) VALUES 
        (?, ?, ?, ?, ?)
      ''',
          [
            MyFunctions.clearTheText(inforQuController.text),
            MyFunctions.clearTheText(inforQuTranslationController.text),
            MyFunctions.clearTheText(inforAnsController.text),
            MyFunctions.clearTheText(inforAnsTranslationController.text),
            widget.question.id,
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
        title: Text(MyText.addInformalQuestion),
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
                  controller: inforQuController,
                  label: MyText.informalQuestion,
                  error: MyText.enterTheInformalQuestion,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabicOptional(
                  controller: inforQuTranslationController,
                  label: MyText.translation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: inforAnsController,
                  label: MyText.answer,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabicOptional(
                  controller: inforAnsTranslationController,
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
