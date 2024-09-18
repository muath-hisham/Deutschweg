import 'package:flutter/material.dart';
import 'package:menschen/models/adjective_mode.dart';
import 'package:menschen/screens/adds/add_adjective.dart';
import 'package:menschen/screens/shared/adjective_card.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/search_adjective_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class AdjectivesPage extends StatefulWidget {
  const AdjectivesPage({super.key});

  @override
  State<AdjectivesPage> createState() => _AdjectivesPageState();
}

class _AdjectivesPageState extends State<AdjectivesPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereAdjectives = true;
  List<Adjective> adjectivesList = [];

  @override
  void initState() {
    super.initState();
    getLevels();
    _getAdjectives();
  }

  Future<void> _getAdjectives() async {
    List<Map<String, dynamic>> li = [];
    if (isAllChecked) {
      li = await sqlDb.readData("SELECT * FROM adjectives");
    } else {
      li = await sqlDb.readData(
          "SELECT * FROM adjectives WHERE lesson_id = $getLessonSelected");
    }

    if (li.isNotEmpty) {
      List<Adjective> featchData = [];
      li.forEach((element) {
        Adjective adjective = Adjective.fromMap(element);
        featchData.add(adjective);
      });
      setState(() {
        adjectivesList.clear();
        adjectivesList.addAll(featchData);
        print(adjectivesList);
      });
    } else {
      setState(() {
        adjectivesList.clear();
        isThereAdjectives = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM adjectives");
    List<Adjective> alladjectives = [];
    dataList.forEach((element) {
      Adjective adjective = Adjective.fromMap(element);
      alladjectives.add(adjective);
    });
    showSearch(
        context: context, delegate: DataSearchToAdjective(alladjectives));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${adjectivesList.length} ${MyText.adjectives}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _search();
            },
          ),
        ],
      ),
      body: isThereAdjectives &&
              (adjectivesList.isEmpty || getLessonsList.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : getLessonsList.isEmpty && !isThereAdjectives
              ? Center(
                  child: Text(
                  MyText.addLessons,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddAdjective()));
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        controlsDesignToViewPages(() {
          setState(() {
            _getAdjectives();
          });
        }),
        adjectivesList.isEmpty && !isThereAdjectives
            ? SizedBox(
                height: Dimensions.height(400),
                child: Center(
                    child: Text(
                  MyText.addAdjectives,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                )),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.vertical(20)),
                  child: ListView.builder(
                    itemCount: adjectivesList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < adjectivesList.length) {
                        return AdjectiveCard(adjective: adjectivesList[index]);
                      }
                      return SizedBox(height: Dimensions.height(90));
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
