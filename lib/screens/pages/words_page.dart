import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/adds/add_word.dart';
import 'package:menschen/screens/shared/word_card.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereWords = true;
  List<Word> wordsList = [];

  @override
  void initState() {
    super.initState();
    getLevels();
    _getWords();
  }

  Future<void> _getWords() async {
    List<Map<String, dynamic>> li = [];
    if (isAllChecked) {
      li = await sqlDb.readData("SELECT * FROM words");
    } else {
      li = await sqlDb
          .readData("SELECT * FROM words WHERE lesson_id = $getLessonSelected");
    }

    if (li.isNotEmpty) {
      List<Word> fetchData = [];
      li.forEach((element) {
        Word word = Word.fromMap(element);
        fetchData.add(word);
      });
      setState(() {
        wordsList.clear();
        wordsList.addAll(fetchData);
      });
    } else {
      setState(() {
        wordsList.clear();
        isThereWords = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM words");
    showSearch(context: context, delegate: DataSearch(dataList, Option.word));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${wordsList.length} ${MyText.words}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _search,
          ),
        ],
      ),
      body: isThereWords && (wordsList.isEmpty || getLessonsList.isEmpty)
          ? Center(child: CircularProgressIndicator())
          : getLessonsList.isEmpty && !isThereWords
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
              .push(MaterialPageRoute(builder: (context) => AddWord()));
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        controlsDesignToViewPages(() {
          setState(() {
            _getWords();
          });
        }),
        wordsList.isEmpty && !isThereWords
            ? SizedBox(
                height: Dimensions.height(400),
                child: Center(
                    child: Text(
                  MyText.addWords,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                )),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.vertical(20)),
                  child: ListView.builder(
                    itemCount: wordsList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < wordsList.length) {
                        return WordCard(word: wordsList[index]);
                      } else {
                        return SizedBox(height: Dimensions.height(80));
                      }
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
