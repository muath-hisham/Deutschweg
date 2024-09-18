import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_example_model.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/screens/pages/display_preposition.dart';
import 'package:menschen/screens/updates/update_preposition_example.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class PrepositionExampleCard extends StatefulWidget {
  final PrepositionExample prepositionExample;
  final Preposition preposition;

  const PrepositionExampleCard(
      {super.key, required this.prepositionExample, required this.preposition});

  @override
  State<PrepositionExampleCard> createState() => _PrepositionExampleCardState();
}

class _PrepositionExampleCardState extends State<PrepositionExampleCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.prepositionExample.example),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  widget.prepositionExample.example,
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
                    widget.prepositionExample.translation,
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
              title: MyText.deleteThisExample,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM preposition_examples WHERE preposition_example_id = ${widget.prepositionExample.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        PrepositionDisplay(preposition: widget.preposition)));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PrepositionExampleUpdate(
                          example: widget.prepositionExample,
                          preposition: widget.preposition,
                        )));
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.prepositionExample.example,
              MyText.copyTheExample,
            ),
          ],
        );
      },
    );
  }
}
