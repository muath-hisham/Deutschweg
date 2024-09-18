import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class FormalQuestionUpdate extends StatefulWidget {
  final FormalQuestion formalQuestion;
  final Question question;
  const FormalQuestionUpdate(
      {super.key, required this.formalQuestion, required this.question});

  @override
  State<FormalQuestionUpdate> createState() => _FormalQuestionUpdateState();
}

class _FormalQuestionUpdateState extends State<FormalQuestionUpdate> {
  final _formKey = GlobalKey<FormState>();
  final formalQuestionController = TextEditingController();
  final forQuTranslationController = TextEditingController();
  final formalAnswerController = TextEditingController();
  final forAnsTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    formalQuestionController.text = widget.formalQuestion.formalQuestion;
    forQuTranslationController.text = widget.formalQuestion.forQuTranslation!;
    formalAnswerController.text = widget.formalQuestion.formalAnswer!;
    forAnsTranslationController.text = widget.formalQuestion.forAnsTranslation!;
  }

  Future _updateFormal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE formal_question SET formal_question = ?, for_qu_translation = ?, formal_answer = ?, for_ans_translation = ? WHERE formal_question_id = ?''',
          [
            MyFunctions.clearTheText(formalQuestionController.text),
            MyFunctions.clearTheText(forQuTranslationController.text),
            MyFunctions.clearTheText(formalAnswerController.text),
            MyFunctions.clearTheText(forAnsTranslationController.text),
            widget.formalQuestion.id
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
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.updateFormalQuestion),
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
                  controller: formalQuestionController,
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
                  controller: formalAnswerController,
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
                  child: Text(
                    MyText.update,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _updateFormal();
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
