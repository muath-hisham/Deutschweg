import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/screens/pages/display_preposition.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/screens/updates/update_preposition.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
// import 'package:menschen/screens/pages/prepositions_page.dart';
// import 'package:menschen/screens/updates/update_preposition.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class PrepositionCard extends StatefulWidget {
  final Preposition preposition;

  const PrepositionCard({super.key, required this.preposition});

  @override
  State<PrepositionCard> createState() => _PrepositionCardState();
}

class _PrepositionCardState extends State<PrepositionCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PrepositionDisplay(preposition: widget.preposition))),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.preposition.preposition),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  widget.preposition.preposition,
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
                  ///////////////////////////////////////////// let it like see more
                  child: Text(
                    widget.preposition.function,
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
              title: MyText.deleteThisPreposition,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM prepositions WHERE preposition_id = ${widget.preposition.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PrepositionsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        PrepositionUpdate(preposition: widget.preposition)));
              },
            ),
          ],
        );
      },
    );
  }
}
