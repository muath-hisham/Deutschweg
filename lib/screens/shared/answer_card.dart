import 'package:flutter/material.dart';
import 'package:menschen/models/answer_model.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/screens/updates/update_answer.dart';
import 'package:menschen/screens/updates/update_formal_question.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AnswerCard extends StatefulWidget {
  final Answer answer;
  final Question question;

  const AnswerCard({super.key, required this.answer, required this.question});

  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.answer.answer),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  "= ${widget.answer.answer}",
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          widget.answer.ansTranslation == null ||
                  widget.answer.ansTranslation!.trim() == ""
              ? SizedBox()
              : Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.answer.ansTranslation!,
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
                    "DELETE FROM question_answers WHERE question_answer_id = ${widget.answer.id}");
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
                    builder: (context) => AnswerUpdate(
                          answer: widget.answer,
                          question: widget.question,
                        )));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.answer.answer,
              MyText.copyTheAnswer,
            ),
          ],
        );
      },
    );
  }
}
