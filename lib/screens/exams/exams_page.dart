import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/level_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/artical_test.dart';
import 'package:menschen/screens/exams/fash_card_sentences/flash_cards_page.dart';
import 'package:menschen/screens/exams/fash_card_words/flash_cards_page.dart';
import 'package:menschen/screens/exams/sentence_order_page.dart';
import 'package:menschen/screens/exams/translation_test.dart';
import 'package:menschen/screens/exams/vocabulary_test.dart';
import 'package:menschen/screens/exams/w_question_test.dart';
import 'package:menschen/screens/exams/words_order_test.dart';
import 'package:menschen/shared/BottomBar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ExamsPage extends StatefulWidget {
  final List<Word> publicWordsList;
  const ExamsPage({super.key, required this.publicWordsList});

  @override
  State<ExamsPage> createState() => _ExamsPageState();
}

class _ExamsPageState extends State<ExamsPage> {
  SqlDb sqlDb = SqlDb();

  List<Word> wordsList = [];
  List<Level> levelsList = [];
  List<Lesson> lessonsList = [];
  List<Lesson> startLessonsList = [];
  List<Lesson> endLessonsList = [];
  String startLevelSelected = "";
  String startLessonSelected = "";
  String endLevelSelected = "";
  String endLessonSelected = "";
  bool isAllChecked = true;

  @override
  void initState() {
    super.initState();
    if (widget.publicWordsList.isNotEmpty) {
      wordsList = List.from(widget.publicWordsList);
      _fillTheLists();
    }
  }

  Future _fillTheLists() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM levels");
    List<Level> list = [];
    li.forEach((element) {
      list.add(Level.fromMap(element));
    });
    setState(() {
      levelsList.addAll(list);
    });
    if (levelsList.isNotEmpty) {
      startLevelSelected = levelsList[0].id.toString();
      endLevelSelected = levelsList[0].id.toString();
    }
    // the lesson list
    lessonsList = await MyFunctions.getAllLessons();
    if (lessonsList.isNotEmpty) {
      startLessonSelected = lessonsList[0].id.toString();
      endLessonSelected = lessonsList[0].id.toString();
    }
    startLessonsList = lessonsList.where((lesson) {
      return lesson.level.id.toString() == startLevelSelected;
    }).toList();
    endLessonsList = lessonsList.where((lesson) {
      return lesson.level.id.toString() == endLevelSelected;
    }).toList();
  }

  void updateStartLessonList() {
    setState(() {
      startLessonsList = lessonsList.where((lesson) {
        return lesson.level.id.toString() == startLevelSelected;
      }).toList();

      // Reset the selected lesson if it is no longer available
      if (!startLessonsList
          .any((lesson) => lesson.id.toString() == startLessonSelected)) {
        startLessonSelected = startLessonsList.isNotEmpty
            ? startLessonsList[0].id.toString()
            : "";
      }
    });
  }

  void updateEndLessonList() {
    setState(() {
      endLessonsList = lessonsList.where((lesson) {
        return lesson.level.id.toString() == endLevelSelected;
      }).toList();

      // Reset the selected lesson if it is no longer available
      if (!endLessonsList
          .any((lesson) => lesson.id.toString() == endLessonSelected)) {
        endLessonSelected =
            endLessonsList.isNotEmpty ? endLessonsList[0].id.toString() : "";
      }
    });
  }

  void _getWords() async {
    if (isAllChecked) {
      wordsList = List.from(widget.publicWordsList);
      Navigator.of(context).pop();
    } else if (int.parse(endLessonSelected) >= int.parse(startLessonSelected)) {
      // get the words
      List li = await sqlDb.readDataWithArg(
        '''SELECT * FROM words
    JOIN lessons ON words.lesson_id = lessons.lesson_id
    WHERE lessons.lesson_id BETWEEN ? AND ?''',
        [
          startLessonSelected,
          endLessonSelected,
        ],
      );
      List<Word> li2 = [];
      for (var word in li) {
        li2.add(Word.fromMap(word));
      }
      setState(() {
        wordsList.clear();
        wordsList.addAll(li2);
      });
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(MyText.beginningBeforeEnd),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.exams),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomBar(active: "exams"),
      body: WillPopScope(
        onWillPop: () async {
          bool shouldExit = await MyWidgets.showExitConfirmationDialog(context);
          return shouldExit;
        },
        child: _body(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_list),
        onPressed: () {
          _showFilterDialog(context);
        },
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.vertical(20)),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(20)),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            MyWidgets.buttonDesign(MyText.vocabularyTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      VocabularyTest(publicWordsList: wordsList)));
            }),
            MyWidgets.buttonDesign(MyText.translationTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      TranslationTest(publicWordsList: wordsList)));
            }),
            MyWidgets.buttonDesign(MyText.articleTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ArticalTest(publicWordsList: wordsList)));
            }),
            MyWidgets.buttonDesign(MyText.wQuestionTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WQuestionTest(
                        startLesson: startLessonSelected,
                        endLesson: endLessonSelected,
                        isAllChecked: isAllChecked,
                      )));
            }),
            MyWidgets.buttonDesign(MyText.wordWritingTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      WordOrderTest(publicWordsList: wordsList)));
            }),
            MyWidgets.buttonDesign(MyText.sentenceOrder, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SentenceOrderPage(
                        startLesson: startLessonSelected,
                        endLesson: endLessonSelected,
                        isAllChecked: isAllChecked,
                      )));
            }),
            MyWidgets.buttonDesign(MyText.flashcardTest, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      FlashCardGame(publicWordsList: wordsList)));
            }),
            MyWidgets.buttonDesign(MyText.flashcardsSentence, () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FlashCardSentenceGame(
                        startLesson: startLessonSelected,
                        endLesson: endLessonSelected,
                        isAllChecked: isAllChecked,
                      )));
            }),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isAllChecked,
                        onChanged: (value) {
                          setState(() {
                            isAllChecked = value!;
                          });
                        },
                      ),
                      Text(
                        MyText.all,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(18),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: Dimensions.width(50)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height(15)),
                    child: Text(MyText.start),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.horizontal(10)),
                          margin: EdgeInsets.all(Dimensions.horizontal(10)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: 0.6), // Add border
                            borderRadius:
                                BorderRadius.circular(5), // Set border radius
                          ),
                          child: DropdownButton<String>(
                            value: startLevelSelected,
                            underline: SizedBox(),
                            onChanged: isAllChecked
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      startLevelSelected = newValue!;
                                      updateStartLessonList();
                                    });
                                  },
                            items: levelsList.map((level) {
                              return DropdownMenuItem<String>(
                                value: level.id.toString(),
                                child: Text(level.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.horizontal(10)),
                          margin: EdgeInsets.all(Dimensions.horizontal(10)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: 0.6), // Add border
                            borderRadius:
                                BorderRadius.circular(5), // Set border radius
                          ),
                          child: DropdownButton<String>(
                            value: startLessonSelected,
                            underline: SizedBox(),
                            onChanged: isAllChecked
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      startLessonSelected = newValue!;
                                      updateEndLessonList();
                                    });
                                  },
                            items: startLessonsList.map((lesson) {
                              return DropdownMenuItem<String>(
                                value: lesson.id.toString(),
                                child: Text(lesson.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height(10)),
                    child: Text(MyText.end),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.horizontal(10)),
                          margin: EdgeInsets.all(Dimensions.horizontal(10)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: 0.6), // Add border
                            borderRadius:
                                BorderRadius.circular(5), // Set border radius
                          ),
                          child: DropdownButton<String>(
                            value: endLevelSelected,
                            underline: SizedBox(),
                            onChanged: isAllChecked
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      endLevelSelected = newValue!;
                                      updateEndLessonList();
                                    });
                                  },
                            items: levelsList.map((level) {
                              return DropdownMenuItem<String>(
                                value: level.id.toString(),
                                child: Text(level.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.horizontal(10)),
                          margin: EdgeInsets.all(Dimensions.horizontal(10)),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black, width: 0.6), // Add border
                            borderRadius:
                                BorderRadius.circular(5), // Set border radius
                          ),
                          child: DropdownButton<String>(
                            value: endLessonSelected,
                            underline: SizedBox(),
                            onChanged: isAllChecked
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      endLessonSelected = newValue!;
                                    });
                                  },
                            items: endLessonsList.map((lesson) {
                              return DropdownMenuItem<String>(
                                value: lesson.id.toString(),
                                child: Text(lesson.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Container(
              margin: EdgeInsets.only(bottom: Dimensions.vertical(10)),
              child: ElevatedButton(
                onPressed: () {
                  _getWords();
                },
                child: Text(MyText.save),
              ),
            ),
          ],
        );
      },
    );
  }
}
