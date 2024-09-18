import 'package:flutter/material.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/screens/pages/display_verb.dart';
import 'package:menschen/screens/pages/verbs_page.dart';
import 'package:menschen/screens/updates/update_verb.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class VerbCard extends StatefulWidget {
  final Verb verb;

  const VerbCard({super.key, required this.verb});

  @override
  State<VerbCard> createState() => _VerbCardState();
}

class _VerbCardState extends State<VerbCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DisplayVerb(verb: widget.verb)));
      },
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.verb.verb),
              const SizedBox(width: Dimensions.horizontalSpace),
              Text(
                widget.verb.verb,
                style: TextStyle(fontSize: Dimensions.fontSize(15)),
              ),
              const SizedBox(width: Dimensions.horizontalSpace),
              if (widget.verb.dativ)
                Text(
                  "(mit Dativ)",
                  style: TextStyle(
                    fontSize: Dimensions.fontSize(10),
                    color: mainColor,
                  ),
                ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Text(
                  widget.verb.translation,
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
              title: MyText.deleteThisVerb,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM verbs WHERE verb_id = ${widget.verb.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => VerbsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => VerbUpdate(verb: widget.verb)));
              },
            ),
            MyWidgets.copyTextButton(
                context, widget.verb.verb, MyText.copyTheVerb),
          ],
        );
      },
    );
  }
}
