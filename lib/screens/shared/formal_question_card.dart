import 'package:flutter/material.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/screens/updates/update_formal_question.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class FormalQuestionCard extends StatefulWidget {
  final FormalQuestion formalQuestion;
  final Question question;

  const FormalQuestionCard(
      {super.key, required this.formalQuestion, required this.question});

  @override
  State<FormalQuestionCard> createState() => _FormalQuestionCardState();
}

class _FormalQuestionCardState extends State<FormalQuestionCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.formalQuestion.formalQuestion),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  "- ${widget.formalQuestion.formalQuestion}",
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          widget.formalQuestion.forQuTranslation == "null" ||
                  widget.formalQuestion.forQuTranslation!.trim() == ""
              ? SizedBox()
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.formalQuestion.forQuTranslation!,
                          style: TextStyle(fontSize: Dimensions.fontSize(15)),
                        ),
                      ),
                    ],
                  ),
                ),
          widget.formalQuestion.formalAnswer == "null" ||
                  widget.formalQuestion.formalAnswer!.trim() == ""
              ? SizedBox()
              : Row(
                  children: [
                    TTSWidget(audioText: widget.formalQuestion.formalAnswer!),
                    const SizedBox(width: Dimensions.horizontalSpace),
                    Expanded(
                      child: Text(
                        "= ${widget.formalQuestion.formalAnswer}",
                        style: TextStyle(fontSize: Dimensions.fontSize(15)),
                      ),
                    ),
                  ],
                ),
          widget.formalQuestion.forAnsTranslation == "null" ||
                  widget.formalQuestion.forAnsTranslation!.trim() == ""
              ? SizedBox()
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.formalQuestion.forAnsTranslation!,
                          style: TextStyle(fontSize: Dimensions.fontSize(15)),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void _showList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            MyWidgets.deleteButton(
              context,
              title: MyText.deleteThisFormalQuestion,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM formal_question WHERE formal_question_id = ${widget.formalQuestion.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        QuestionDisplay(question: widget.question)));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => FormalQuestionUpdate(
                          formalQuestion: widget.formalQuestion,
                          question: widget.question,
                        )));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.formalQuestion.formalQuestion,
              MyText.copyTheFormalQuestion,
            ),
            widget.formalQuestion.formalAnswer == "null" ||
                    widget.formalQuestion.formalAnswer!.trim() == ""
                ? SizedBox()
                : MyWidgets.copyTextButton(
                    context,
                    widget.formalQuestion.formalAnswer!,
                    MyText.copyTheAnswer,
                  ),
          ],
        );
      },
    );
  }
}
