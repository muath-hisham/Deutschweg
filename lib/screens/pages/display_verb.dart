import 'package:flutter/material.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/screens/updates/update_verb.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';

class DisplayVerb extends StatelessWidget {
  final Verb verb;
  DisplayVerb({super.key, required this.verb});

  Map<String, Map<String, String>> perfect = {
    "haben": {
      "ich": "habe",
      "du": "hast",
      "er": "hat",
      "wir": "haben",
      "ihr": "habt",
      "sie": "haben"
    },
    "sein": {
      "ich": "bin",
      "du": "bist",
      "er": "ist",
      "wir": "sind",
      "ihr": "seid",
      "sie": "sind"
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(verb.verb),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: Dimensions.width(20)),
            child: TTSWidget(
              audioText: verb.verb,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => VerbUpdate(verb: verb)));
        },
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(35),
        ),
        child: Column(
          children: [
            if (verb.dativ)
              _buildTableDesign(children: [_buildSingelTableRow("mit Dativ")]),
            _buildBoxDesign(MyText.translation, verb.translation),
            _buildBoxDesign("Infinitiv", verb.verb),
            if (verb.partizipTwo.isNotEmpty)
              _buildBoxDesign("Partizip II", verb.partizipTwo),
            if (verb.imperative.isNotEmpty)
              _buildBoxDesign(MyText.imperative, verb.imperative),
            if (verb.ich.isNotEmpty) _praesens(),
            if (verb.perfekt.isNotEmpty) _perfekt(),
            if (verb.prateritumIch.isNotEmpty) _prateritum(),
            SizedBox(height: Dimensions.height(90)),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxDesign(String title, String text) {
    return _buildTableDesign(
      children: [
        _buildFirstTableRow(title),
        _buildLastTableRow(text),
      ],
    );
  }

  Widget _praesens() {
    return _buildTableDesign(
      children: [
        _buildFirstTableRow('PRÄSENS'),
        _buildTableRow("ich ${verb.ich}"),
        _buildTableRow("du ${verb.du}"),
        _buildTableRow("er/sie/es ${verb.er}"),
        _buildTableRow("wir ${verb.wir}"),
        _buildTableRow("ihr ${verb.ihr}"),
        _buildLastTableRow("sie/Sie ${verb.sie}"),
      ],
    );
  }

  Widget _perfekt() {
    return _buildTableDesign(
      children: [
        _buildFirstTableRow('PERFEKT'),
        _buildTableRow(
            "ich ${perfect[verb.perfekt]!['ich']} ${verb.partizipTwo}"),
        _buildTableRow(
            "du ${perfect[verb.perfekt]!['du']} ${verb.partizipTwo}"),
        _buildTableRow(
            "er/sie/es ${perfect[verb.perfekt]!['er']} ${verb.partizipTwo}"),
        _buildTableRow(
            "wir ${perfect[verb.perfekt]!['wir']} ${verb.partizipTwo}"),
        _buildTableRow(
            "ihr ${perfect[verb.perfekt]!['ihr']} ${verb.partizipTwo}"),
        _buildLastTableRow(
            "sie/Sie ${perfect[verb.perfekt]!['sie']} ${verb.partizipTwo}"),
      ],
    );
  }

  Widget _prateritum() {
    return _buildTableDesign(
      children: [
        _buildFirstTableRow('Präteritum'),
        _buildTableRow("ich ${verb.prateritumIch}"),
        _buildTableRow("du ${verb.prateritumDu}"),
        _buildTableRow("er/sie/es ${verb.prateritumEr}"),
        _buildTableRow("wir ${verb.prateritumWir}"),
        _buildTableRow("ihr ${verb.prateritumIhr}"),
        _buildLastTableRow("sie/Sie ${verb.prateritumSie}"),
      ],
    );
  }

  Widget _buildTableDesign({required List<TableRow> children}) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height(22)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Table(
        // border: TableBorder.all(width: 0.5, color: Colors.grey.shade400),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: children,
      ),
    );
  }

  TableRow _buildFirstTableRow(String text) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
      children: <Widget>[
        Container(
          height: Dimensions.height(40),
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String text) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[300]!),
        ),
      ),
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => MyFunctions.speak(text),
            splashColor: Colors.blue.withOpacity(0.3),
            highlightColor: Colors.blue.withOpacity(0.1),
            child: Container(
              height: Dimensions.height(43),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.fontSize(17)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildLastTableRow(String text) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
      ),
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => MyFunctions.speak(text),
            splashColor: Colors.blue.withOpacity(0.3),
            highlightColor: Colors.blue.withOpacity(0.1),
            child: Container(
              height: Dimensions.height(43),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.fontSize(17)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildSingelTableRow(String text) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => MyFunctions.speak(text),
            splashColor: Colors.blue.withOpacity(0.3),
            highlightColor: Colors.blue.withOpacity(0.1),
            child: Container(
              height: Dimensions.height(43),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: Dimensions.fontSize(17)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
