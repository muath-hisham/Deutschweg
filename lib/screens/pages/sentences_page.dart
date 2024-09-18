import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/screens/adds/add_sentence.dart';
import 'package:menschen/screens/shared/sentence_card.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class SentencesPage extends StatefulWidget {
  const SentencesPage({super.key});

  @override
  State<SentencesPage> createState() => _SentencesPageState();
}

class _SentencesPageState extends State<SentencesPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereSentences = true;
  List<Sentence> sentencesList = [];

  @override
  void initState() {
    super.initState();
    getLevels();
    _getsentences();
  }

  Future<void> _getsentences() async {
    List<Map<String, dynamic>> li = [];
    if (isAllChecked) {
      li = await sqlDb.readData("SELECT * FROM sentences");
    } else {
      li = await sqlDb.readData(
          "SELECT * FROM sentences WHERE lesson_id = $getLessonSelected");
    }

    if (li.isNotEmpty) {
      List<Sentence> featchData = [];
      li.forEach((element) {
        Sentence sentence = Sentence.fromMap(element);
        featchData.add(sentence);
      });
      setState(() {
        sentencesList.clear();
        sentencesList.addAll(featchData);
        print(sentencesList);
      });
    } else {
      setState(() {
        sentencesList.clear();
        isThereSentences = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM sentences");
    showSearch(
        context: context, delegate: DataSearch(dataList, Option.sentence));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${sentencesList.length} ${MyText.sentences}"),
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
      body:
          isThereSentences && (sentencesList.isEmpty || getLessonsList.isEmpty)
              ? Center(child: CircularProgressIndicator())
              : getLessonsList.isEmpty && !isThereSentences
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
              .push(MaterialPageRoute(builder: (context) => AddSentence()));
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        controlsDesignToViewPages(() {
          setState(() {
            _getsentences();
          });
        }),
        sentencesList.isEmpty && !isThereSentences
            ? SizedBox(
                height: Dimensions.height(400),
                child: Center(
                    child: Text(
                  MyText.addSentences,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                )),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.vertical(20)),
                  child: ListView.builder(
                    itemCount: sentencesList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < sentencesList.length) {
                        return SentenceCard(sentence: sentencesList[index]);
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
