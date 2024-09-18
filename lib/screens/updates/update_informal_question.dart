import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/informal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class InformalQuestionUpdate extends StatefulWidget {
  final InformalQuestion informalQuestion;
  final Question question;
  const InformalQuestionUpdate(
      {super.key, required this.informalQuestion, required this.question});

  @override
  State<InformalQuestionUpdate> createState() => _InformalQuestionUpdateState();
}

class _InformalQuestionUpdateState extends State<InformalQuestionUpdate> {
  final _formKey = GlobalKey<FormState>();
  final informalQuestionController = TextEditingController();
  final inforQuTranslationController = TextEditingController();
  final informalAnswerController = TextEditingController();
  final inforAnsTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    informalQuestionController.text = widget.informalQuestion.informalQuestion;
    inforQuTranslationController.text =
        widget.informalQuestion.inforQuTranslation!;
    informalAnswerController.text = widget.informalQuestion.informalAnswer!;
    inforAnsTranslationController.text =
        widget.informalQuestion.inforAnsTranslation!;
  }

  Future _updateInformal() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE informal_question SET informal_question = ?, infor_qu_translation = ?, informal_answer = ?, infor_ans_translation = ? WHERE informal_question_id = ?''',
          [
            MyFunctions.clearTheText(informalQuestionController.text),
            MyFunctions.clearTheText(inforQuTranslationController.text),
            MyFunctions.clearTheText(informalAnswerController.text),
            MyFunctions.clearTheText(inforAnsTranslationController.text),
            widget.informalQuestion.id
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
                  controller: informalQuestionController,
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
                  controller: informalAnswerController,
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
                  child: Text(
                    MyText.update,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _updateInformal();
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
