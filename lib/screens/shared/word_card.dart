import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/updates/update_word.dart';
import 'package:menschen/screens/pages/words_page.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class WordCard extends StatefulWidget {
  final Word word;

  const WordCard({super.key, required this.word});

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              TTSWidget(audioText: widget.word.word),
              const SizedBox(width: Dimensions.horizontalSpace),
              widget.word.artical == "null" ||
                      widget.word.artical!.trim().isEmpty
                  ? SizedBox()
                  : Text(
                      widget.word.artical!,
                      style: TextStyle(
                          fontSize: Dimensions.fontSize(12),
                          color: MyFunctions.colored(widget.word)),
                    ),
              const SizedBox(width: Dimensions.horizontalSpace),
              Text(
                widget.word.word,
                style: TextStyle(
                    fontSize: Dimensions.fontSize(15),
                    color: MyFunctions.colored(widget.word)),
              ),
              const SizedBox(width: Dimensions.horizontalSpace),
              widget.word.plural == "null" || widget.word.plural!.trim().isEmpty
                  ? SizedBox()
                  : Text(
                      "[pl: ${widget.word.plural}]",
                      style: TextStyle(fontSize: Dimensions.fontSize(12)),
                    ),
              const SizedBox(width: Dimensions.horizontalSpace),
              widget.word.feminine == "null" ||
                      widget.word.feminine!.trim().isEmpty
                  ? SizedBox()
                  : Text(
                      "[feminin: ${widget.word.feminine}]",
                      style: TextStyle(fontSize: Dimensions.fontSize(12)),
                    ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Text(
                  widget.word.translation,
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
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
              title: MyText.deleteThisWord,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM words WHERE word_id = ${widget.word.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => WordsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => WordUpdate(word: widget.word)));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.word.word,
              MyText.copyTheWord,
            ),
            widget.word.plural == "null" || widget.word.plural!.trim().isEmpty
                ? SizedBox()
                : MyWidgets.copyTextButton(
                    context,
                    widget.word.plural!,
                    MyText.copyThePlural,
                  ),
            widget.word.feminine == "null" ||
                    widget.word.feminine!.trim().isEmpty
                ? SizedBox()
                : MyWidgets.copyTextButton(
                    context,
                    widget.word.feminine!,
                    MyText.copyTheFeminine,
                  ),
            widget.word.plural == "null" || widget.word.plural!.trim().isEmpty
                ? SizedBox()
                : ReadTextButton(
                    audioText: widget.word.plural!,
                    title: MyText.listenToThePlural,
                  ),
            widget.word.feminine == "null" ||
                    widget.word.feminine!.trim().isEmpty
                ? SizedBox()
                : ReadTextButton(
                    audioText: widget.word.feminine!,
                    title: MyText.listenToTheFeminin,
                  ),
          ],
        );
      },
    );
  }
}
