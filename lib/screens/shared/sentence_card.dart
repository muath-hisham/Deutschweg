import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/screens/pages/sentences_page.dart';
import 'package:menschen/screens/updates/update_sentence.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class SentenceCard extends StatefulWidget {
  final Sentence sentence;

  const SentenceCard({super.key, required this.sentence});

  @override
  State<SentenceCard> createState() => _SentenceCardState();
}

class _SentenceCardState extends State<SentenceCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.sentence.sentence),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  widget.sentence.sentence,
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
                    widget.sentence.translation,
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
              title: MyText.deleteThisSentence,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM sentences WHERE sentence_id = ${widget.sentence.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SentencesPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        SentenceUpdate(sentence: widget.sentence)));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.sentence.sentence,
              MyText.copyTheSentence,
            ),
          ],
        );
      },
    );
  }
}
