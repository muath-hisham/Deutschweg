import 'package:flutter/material.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/informal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/screens/updates/update_formal_question.dart';
import 'package:menschen/screens/updates/update_informal_question.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class InformalQuestionCard extends StatefulWidget {
  final InformalQuestion informalQuestion;
  final Question question;

  const InformalQuestionCard(
      {super.key, required this.informalQuestion, required this.question});

  @override
  State<InformalQuestionCard> createState() => _InformalQuestionCardState();
}

class _InformalQuestionCardState extends State<InformalQuestionCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.informalQuestion.informalQuestion),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  "- ${widget.informalQuestion.informalQuestion}",
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          widget.informalQuestion.inforQuTranslation == "null" ||
                  widget.informalQuestion.inforQuTranslation!.trim() == ""
              ? SizedBox()
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.informalQuestion.inforQuTranslation!,
                          style: TextStyle(fontSize: Dimensions.fontSize(15)),
                        ),
                      ),
                    ],
                  ),
                ),
          widget.informalQuestion.informalAnswer == "null" ||
                  widget.informalQuestion.informalAnswer!.trim() == ""
              ? SizedBox()
              : Row(
                  children: [
                    TTSWidget(
                        audioText: widget.informalQuestion.informalAnswer!),
                    const SizedBox(width: Dimensions.horizontalSpace),
                    Expanded(
                      child: Text(
                        "= ${widget.informalQuestion.informalAnswer}",
                        style: TextStyle(fontSize: Dimensions.fontSize(15)),
                      ),
                    ),
                  ],
                ),
          widget.informalQuestion.inforAnsTranslation == "null" ||
                  widget.informalQuestion.inforAnsTranslation!.trim() == ""
              ? SizedBox()
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.informalQuestion.inforAnsTranslation!,
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
                    "DELETE FROM informal_question WHERE informal_question_id = ${widget.informalQuestion.id}");
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
                    builder: (context) => InformalQuestionUpdate(
                          informalQuestion: widget.informalQuestion,
                          question: widget.question,
                        )));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.informalQuestion.informalQuestion,
              MyText.copyTheInformalQuestion,
            ),
            widget.informalQuestion.informalAnswer == "null" ||
                    widget.informalQuestion.informalAnswer!.trim() == ""
                ? SizedBox()
                : MyWidgets.copyTextButton(
                    context,
                    widget.informalQuestion.informalAnswer!,
                    MyText.copyTheAnswer,
                  ),
          ],
        );
      },
    );
  }
}
