import 'package:flutter/material.dart';
import 'package:menschen/models/adjective_mode.dart';
import 'package:menschen/screens/pages/adjectives_page.dart';
import 'package:menschen/screens/updates/update_adjective.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AdjectiveCard extends StatefulWidget {
  final Adjective adjective;

  const AdjectiveCard({super.key, required this.adjective});

  @override
  State<AdjectiveCard> createState() => _AdjectiveCardState();
}

class _AdjectiveCardState extends State<AdjectiveCard> {
  final SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showOptionsMenu(context),
      child: Row(
        children: [
          _leftSide(),
          _buildDivider(),
          _rightSide(),
        ],
      ),
    );
  }

  Widget _leftSide() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.adjective.adjective),
              SizedBox(width: Dimensions.width(10)),
              Flexible(
                child: Text(
                  widget.adjective.adjective,
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    widget.adjective.adjTranslation,
                    overflow: TextOverflow.visible,
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

  Widget _rightSide() {
    if (widget.adjective.opposite == null ||
        widget.adjective.opposite!.trim().isEmpty) {
      return SizedBox();
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.adjective.opposite!),
              SizedBox(width: Dimensions.width(10)),
              Flexible(
                child: Text(
                  widget.adjective.opposite!,
                  overflow: TextOverflow.visible,
                  style: TextStyle(fontSize: Dimensions.fontSize(15)),
                ),
              ),
            ],
          ),
          if (widget.adjective.oppTranslation != null &&
              widget.adjective.oppTranslation!.trim().isNotEmpty)
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      widget.adjective.oppTranslation!,
                      overflow: TextOverflow.visible,
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

  Widget _buildDivider() {
    if (widget.adjective.opposite == null ||
        widget.adjective.opposite!.trim().isEmpty) {
      return const SizedBox();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(15)),
      color: Colors.black,
      height: Dimensions.height(40),
      width: Dimensions.width(1.5),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            MyWidgets.deleteButton(
              context,
              title: MyText.deleteThisAdjective,
              accept: () async {
                await sqlDb.deleteData(
                  "DELETE FROM adjectives WHERE adjective_id = ${widget.adjective.id}",
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdjectivesPage()),
                );
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        AdjectiveUpdate(adjective: widget.adjective),
                  ),
                );
              },
            ),
            MyWidgets.copyTextButton(
              context,
              widget.adjective.adjective,
              "Kopieren Sie das ${widget.adjective.adjective}",
            ),
            if (widget.adjective.opposite != null &&
                widget.adjective.opposite!.trim().isNotEmpty)
              MyWidgets.copyTextButton(
                context,
                widget.adjective.opposite!,
                "Kopieren Sie das ${widget.adjective.opposite}",
              ),
          ],
        );
      },
    );
  }
}
