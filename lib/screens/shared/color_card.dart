import 'package:flutter/material.dart';
import 'package:menschen/models/color_model.dart';
import 'package:menschen/screens/pages/colors_page.dart';
import 'package:menschen/screens/updates/update_color.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
// import 'package:menschen/screens/pages/colors_page.dart';
// import 'package:menschen/screens/updates/update_color.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ColorCard extends StatefulWidget {
  final MyColor color;

  const ColorCard({super.key, required this.color});

  @override
  State<ColorCard> createState() => _ColorCardState();
}

class _ColorCardState extends State<ColorCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      child: Column(
        children: [
          Row(
            children: [
              TTSWidget(audioText: widget.color.color),
              const SizedBox(width: Dimensions.horizontalSpace),
              Expanded(
                child: Text(
                  widget.color.color,
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
                    widget.color.translation,
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
              title: MyText.deleteThisColor,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM colors WHERE color_id = ${widget.color.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ColorsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        ColorUpdate(color: widget.color)));
              },
            ),
          ],
        );
      },
    );
  }
}
