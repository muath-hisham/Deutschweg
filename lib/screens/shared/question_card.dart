import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/pages/display_question.dart';
import 'package:menschen/screens/pages/questions_page.dart';
import 'package:menschen/screens/updates/update_question.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class QuestionCard extends StatefulWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuestionDisplay(question: widget.question))),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.question.question),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  widget.question.question,
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question.quTranslation,
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
              title: MyText.deleteThisQuestion,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM questions WHERE question_id = ${widget.question.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => QuestionsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        QuestionUpdate(question: widget.question)));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.question.question,
              MyText.copyTheQuestion,
            ),
            // MyWidgets.copyTextButton(
            //   context,
            //   widget.question.answer,
            //   MyText.copyTheAnswer,
            // ),
          ],
        );
      },
    );
  }
}
