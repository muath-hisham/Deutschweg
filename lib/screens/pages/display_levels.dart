import 'package:flutter/material.dart';
import 'package:menschen/models/level_model.dart';
import 'package:menschen/screens/adds/add_level.dart';
import 'package:menschen/screens/shared/level_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class LevelsDisplay extends StatefulWidget {
  const LevelsDisplay({super.key});

  @override
  State<LevelsDisplay> createState() => _LevelsDisplayState();
}

class _LevelsDisplayState extends State<LevelsDisplay> {
  SqlDb sqlDb = SqlDb();
  List<Level> levelsList = [];
  bool isThereLevels = true;

  @override
  void initState() {
    super.initState();
    _getLevels();
  }

  Future<void> _getLevels() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM levels");
    if (li.isNotEmpty) {
      setState(() {
        li.forEach((element) {
          Level level = Level.fromMap(element);
          levelsList.add(level);
        });
      });
    } else {
      setState(() {
        isThereLevels = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.level),
        centerTitle: true,
      ),
      body: isThereLevels && levelsList.isEmpty
          ? Center(child: SingleChildScrollView())
          : !isThereLevels
              ? Center(
                  child: Text(
                  MyText.addLevels,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddLevel()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(15),
        vertical: Dimensions.vertical(30),
      ),
      child: ListView.builder(
        itemCount: levelsList.length,
        itemBuilder: (context, index) {
          return LevelCard(level: levelsList[index]);
        },
      ),
    );
  }
}
