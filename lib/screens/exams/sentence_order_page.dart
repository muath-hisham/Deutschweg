import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_game_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class SentenceOrderPage extends StatefulWidget {
  final String startLesson;
  final String endLesson;
  final bool isAllChecked;

  const SentenceOrderPage({
    super.key,
    required this.startLesson,
    required this.endLesson,
    required this.isAllChecked,
  });

  @override
  _SentenceOrderPageState createState() => _SentenceOrderPageState();
}

class _SentenceOrderPageState extends State<SentenceOrderPage>
    with SingleTickerProviderStateMixin {
  List<SentenceGame> sentencesList = [];
  List<String> words = [];
  List<String> currentSentence = [];
  late String originalSentence;
  int currentIndex = 0;
  int score = 0;
  bool _isCorrectAnswer = false;
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _getTheSentences();
  }

  void _getTheSentences() async {
    SqlDb sqlDb = SqlDb();
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
    currentIndex = random.nextInt(sentencesList.length);

    _loadSentence();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadSentence() {
    originalSentence = sentencesList[currentIndex].sentence;
    words = originalSentence.split(' ');
    words.shuffle(); // Shuffle words
    currentSentence.clear();
  }

  void _addWord(String word) {
    setState(() {
      if (words.contains(word)) {
        words.remove(word);
        currentSentence.add(word);
      }
    });
  }

  void _removeWord(int index) {
    setState(() {
      String word = currentSentence.removeAt(index);
      words.add(word);
      words.shuffle();
    });
  }

  // Plays a sound based on whether the answer is correct or not
  Future<void> _playSound(bool isCorrect) async {
    String soundPath = isCorrect ? 'sounds/correct.mp3' : 'sounds/wrong.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  void _checkSentence() {
    bool isCorrect = currentSentence.join(' ') == originalSentence;
    setState(() {
      _isCorrectAnswer = isCorrect;
    });
    _playSound(_isCorrectAnswer);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: Dimensions.height(350),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: SizedBox(
                        width: Dimensions.width(100),
                        child: Divider(color: Color(0xffe0e0e0), thickness: 4),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Center(
                      child: Text(
                        _isCorrectAnswer ? MyText.excellent : MyText.wrong,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(20),
                          fontWeight: FontWeight.bold,
                          color: _isCorrectAnswer
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TTSWidget(
                            audioText: sentencesList[currentIndex].sentence,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: Dimensions.width(20)),
                        Expanded(
                          child: Text(
                            sentencesList[currentIndex].sentence,
                            overflow: TextOverflow.visible,
                            style: TextStyle(fontSize: Dimensions.fontSize(18)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Text(
                      sentencesList[currentIndex].translation,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: Dimensions.fontSize(18)),
                    ),
                  ],
                ),
              ),
              Spacer(),
              MyWidgets.questionsButton(() => _nextSentence(), isNext: true),
            ],
          ),
        );
      },
    );
  }

  void _nextSentence() {
    setState(() {
      if (_isCorrectAnswer) {
        sentencesList.removeAt(currentIndex);
        score++;
      }
    });
    if (sentencesList.isNotEmpty) {
      _getRandomSentence();
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CongratulationsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.sentenceOrder),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : sentencesList.isEmpty
              ? _emptyListPage()
              : _body(),
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
      children: <Widget>[
        SizedBox(height: Dimensions.height(60)),
        _rankDesign(),
        SizedBox(height: Dimensions.height(25)),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(30)),
          alignment: Alignment.centerRight,
          child: Text(
            sentencesList[currentIndex].translation,
            style: TextStyle(fontSize: Dimensions.fontSize(17)),
          ),
        ),
        SizedBox(height: Dimensions.height(5)),
        _answerDesgin(),
        Spacer(),
        _wordsPlaceDesgin(),
        Spacer(),
        MyWidgets.questionsButton(() => _checkSentence(),
            caseImplemented: words.isEmpty),
      ],
    );
  }

  Widget _rankDesign() {
    return Center(
      child: Text(
        "${MyText.score} / $score",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _answerDesgin() {
    return CustomPaint(
      painter: LinePainter(),
      child: Container(
        alignment: Alignment.topLeft,
        height: Dimensions.height(150.0),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(15),
        ),
        child: Wrap(
          spacing: Dimensions.width(8.0),
          runSpacing: Dimensions.height(4.0),
          children: <Widget>[
            for (int i = 0; i < currentSentence.length; i++)
              GestureDetector(
                onTap: () => _removeWord(i),
                child: Chip(
                  label: Text(
                    currentSentence[i],
                    style: TextStyle(fontSize: Dimensions.fontSize(18)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.horizontal(12),
                    vertical: Dimensions.vertical(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _wordsPlaceDesgin() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(25)),
        child: Wrap(
          spacing: Dimensions.width(8.0),
          runSpacing: Dimensions.height(8.0),
          children: words.map((word) {
            return GestureDetector(
              onTap: () => _addWord(word),
              child: Chip(
                label: Text(
                  word,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.horizontal(12.0),
                  vertical: Dimensions.vertical(8.0),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
