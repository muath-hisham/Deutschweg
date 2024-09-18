import 'package:flutter/material.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/screens/adds/add_verb.dart';
import 'package:menschen/screens/shared/Verb_card.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class VerbsPage extends StatefulWidget {
  const VerbsPage({super.key});

  @override
  State<VerbsPage> createState() => _VerbsPageState();
}

class _VerbsPageState extends State<VerbsPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereVerbs = true;
  List<Verb> verbsList = [];
  bool _isDativClicked = false;

  @override
  void initState() {
    super.initState();
    getLevels();
    _getVerbs();
  }

  Future<void> _getVerbs() async {
    List<Map<String, dynamic>> li = [];
    if (_isDativClicked) {
      li = await sqlDb.readData("SELECT * FROM verbs WHERE dativ = 1");
    } else if (isAllChecked) {
      li = await sqlDb.readData("SELECT * FROM verbs");
    } else {
      li = await sqlDb
          .readData("SELECT * FROM verbs WHERE lesson_id = $getLessonSelected");
    }

    if (li.isNotEmpty) {
      List<Verb> featchData = [];
      li.forEach((element) {
        Verb verb = Verb.fromMap(element);
        featchData.add(verb);
      });
      setState(() {
        verbsList.clear();
        verbsList.addAll(featchData);
        print(verbsList);
      });
    } else {
      setState(() {
        verbsList.clear();
        isThereVerbs = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM verbs");
    showSearch(context: context, delegate: DataSearch(dataList, Option.verb));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${verbsList.length} ${MyText.verbs}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Text(
              "Dativ",
              style: TextStyle(
                fontSize: Dimensions.fontSize(12),
                color: _isDativClicked ? Colors.redAccent : Colors.white,
              ),
            ),
            onPressed: () {
              setState(() {
                _isDativClicked = !_isDativClicked;
              });
              _getVerbs();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _search();
            },
          ),
        ],
      ),
      body: isThereVerbs && (verbsList.isEmpty || getLessonsList.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : getLessonsList.isEmpty && !isThereVerbs
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
              .push(MaterialPageRoute(builder: (context) => AddVerb()));
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        controlsDesignToViewPages(() {
          setState(() {
            _getVerbs();
          });
        }),
        verbsList.isEmpty && !isThereVerbs
            ? SizedBox(
                height: Dimensions.height(400),
                child: Center(
                    child: Text(
                  MyText.addVerbs,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                )),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.vertical(20)),
                  child: ListView.builder(
                    itemCount: verbsList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < verbsList.length) {
                        return VerbCard(verb: verbsList[index]);
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
