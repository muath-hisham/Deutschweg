import 'dart:math';
import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_game_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/screens/exams/fash_card_sentences/flash_card_sentence.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class FlashCardSentenceGame extends StatefulWidget {
  final String startLesson;
  final String endLesson;
  final bool isAllChecked;
  const FlashCardSentenceGame({
    super.key,
    required this.startLesson,
    required this.endLesson,
    required this.isAllChecked,
  });

  @override
  State<FlashCardSentenceGame> createState() => _FlashCardSentenceGameState();
}

class _FlashCardSentenceGameState extends State<FlashCardSentenceGame> {
  List<SentenceGame> sentencesList = [];
  late int _currentIndex;
  bool _showAnswer = false;
  late String currentSentence;
  bool _isLoading = true;
  // int currentIndex = 0;
  Random random = Random();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    _getTheSentences();
  }

  void _getTheSentences() async {
    List<Map<String, dynamic>> li;
    if (widget.isAllChecked) {
      li = await sqlDb.readData('''SELECT * FROM sentences WHERE 
          sentence NOT LIKE '%(%'
          AND sentence NOT LIKE '%)%'
          AND sentence NOT LIKE '%/%' LIMIT 80;''');
    } else {
      li = await sqlDb.readDataWithArg('''SELECT * FROM sentences WHERE
          sentence NOT LIKE '%(%'
          AND sentence NOT LIKE '%)%'
          AND sentence NOT LIKE '%/%' AND
          lesson_id BETWEEN ? AND ? LIMIT 80; ''',
          [widget.startLesson, widget.endLesson]);
    }

    for (Map<String, dynamic> map in li) {
      SentenceGame sentence = SentenceGame(map["sentence"], map["translation"]);
      setState(() {
        sentencesList.add(sentence);
      });
    }

    if (widget.isAllChecked) {
      li = await sqlDb.readData('''SELECT * FROM questions WHERE 
          question NOT LIKE '%(%'
          AND question NOT LIKE '%)%'
          AND question NOT LIKE '%/%' LIMIT 80;''');
    } else {
      li = await sqlDb.readDataWithArg('''SELECT * FROM questions WHERE
          question NOT LIKE '%(%'
          AND question NOT LIKE '%)%'
          AND question NOT LIKE '%/%' AND
          lesson_id BETWEEN ? AND ? LIMIT 80; ''',
          [widget.startLesson, widget.endLesson]);
    }

    for (Map<String, dynamic> map in li) {
      SentenceGame sentence = SentenceGame(map["question"], map["translation"]);
      setState(() {
        sentencesList.add(sentence);
      });
    }

    if (sentencesList.isEmpty) {
      setState(() {
        _isLoading = false;
        return;
      });
    } else {
      _getRandomSentence();
    }
  }

  void _getRandomSentence() {
    setState(() {
      _isLoading = true;
    });

    Random random = Random();
    _currentIndex = random.nextInt(sentencesList.length);

    currentSentence = sentencesList[_currentIndex].sentence;

    setState(() {
      _isLoading = false;
    });
  }

  void _nextCard() async {
    if (sentencesList.length == 1) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CongratulationsPage()));
      return;
    }

    if (_showAnswer) {
      setState(() {
        _showAnswer = false;
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
    setState(() {
      sentencesList.removeAt(_currentIndex);
    });
    if (sentencesList.isNotEmpty) {
      setState(() {
        _currentIndex = random.nextInt(sentencesList.length);
      });
    }
  }

  void _toggleCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.flashcardsSentence),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : sentencesList.isEmpty
              ? _emptyListPage()
              : _body(),
      floatingActionButton: sentencesList.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: _nextCard,
              child: Icon(Icons.arrow_forward),
            ),
    );
  }

  Widget _emptyListPage() {
    return Container(
      child: Column(children: [
        Spacer(),
        Center(
          child: Text(
            MyText.sorry,
            style: TextStyle(fontSize: Dimensions.fontSize(20)),
          ),
        ),
        Spacer(),
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.horizontal(10),
                vertical: Dimensions.vertical(10),
              ),
              child: Text(
                MyText.back,
                style: TextStyle(fontSize: Dimensions.fontSize(15)),
              ),
            )),
        SizedBox(height: Dimensions.height(50)),
      ]),
    );
  }

  Widget _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: TTSWidget(
            audioText: sentencesList[_currentIndex].sentence,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: _toggleCard,
          child: FlashCard(
            sentence: sentencesList[_currentIndex],
            showAnswer: _showAnswer,
          ),
        ),
      ],
    );
  }
}
