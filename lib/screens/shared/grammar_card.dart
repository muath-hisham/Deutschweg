import 'package:flutter/material.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/screens/pages/display_grammar.dart';
import 'package:menschen/screens/pages/grammar_page.dart';
import 'package:menschen/screens/updates/update_grammar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class GrammarCard extends StatefulWidget {
  final Grammar grammar;

  const GrammarCard({super.key, required this.grammar});

  @override
  State<GrammarCard> createState() => _GrammarCardState();
}

class _GrammarCardState extends State<GrammarCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GrammarDisplay(grammar: widget.grammar))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.vertical(12)),
        child: Text(
          widget.grammar.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: Dimensions.fontSize(15)),
        ),
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
              title: MyText.deleteThisGrammar,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM grammar WHERE grammar_id = ${widget.grammar.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => GrammarPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        GrammarUpdate(grammar: widget.grammar)));
              },
            ),
          ],
        );
      },
    );
  }
}
