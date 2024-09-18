import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';

class WordOrderTest extends StatefulWidget {
  final List<Word> publicWordsList;

  const WordOrderTest({
    super.key,
    required this.publicWordsList,
  });

  @override
  _WordOrderTestState createState() => _WordOrderTestState();
}

class _WordOrderTestState extends State<WordOrderTest>
    with SingleTickerProviderStateMixin {
  List<Word> wordsList = [];
  List<String> letters = [];
  List<String> currentWord = [];
  late String originalWord;
  int currentIndex = 0;
  int score = 0;
  bool _isCorrectAnswer = false;
  bool _isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.publicWordsList.isNotEmpty) {
      wordsList = List.from(widget.publicWordsList);
      _getRandomWord();
    } else {
      _isLoading = false;
    }
  }

  void _getRandomWord() {
    setState(() {
      _isLoading = true;
    });

    Random random = Random();
    currentIndex = random.nextInt(wordsList.length);

    _loadWord();

    setState(() {
      _isLoading = false;
    });
  }

  void _loadWord() {
    originalWord = wordsList[currentIndex].word;
    letters = originalWord.split(''); // Split word into letters
    letters.shuffle(); // Shuffle letters
    currentWord.clear();
  }

  void _addLetter(String letter) {
    setState(() {
      if (letters.contains(letter)) {
        letters.remove(letter);
        currentWord.add(letter);
      }
    });
  }

  void _removeLetter(int index) {
    setState(() {
      String letter = currentWord.removeAt(index);
      letters.add(letter);
      letters.shuffle();
    });
  }

  Future<void> _playSound(bool isCorrect) async {
    String soundPath = isCorrect ? 'sounds/correct.mp3' : 'sounds/wrong.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  void _checkWord() {
    bool isCorrect = currentWord.join('') == originalWord;
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
                            audioText: wordsList[currentIndex].word,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: Dimensions.width(20)),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                "${wordsList[currentIndex].artical} ",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: MyFunctions.colored(
                                      wordsList[currentIndex]),
                                  fontSize: Dimensions.fontSize(14),
                                ),
                              ),
                              Text(
                                wordsList[currentIndex].word,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: MyFunctions.colored(
                                      wordsList[currentIndex]),
                                  fontSize: Dimensions.fontSize(18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height(15)),
                    Text(
                      wordsList[currentIndex].translation,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: Dimensions.fontSize(18)),
                    ),
                  ],
                ),
              ),
              Spacer(),
              MyWidgets.questionsButton(() => _nextWord(), isNext: true),
            ],
          ),
        );
      },
    );
  }

  void _nextWord() {
    setState(() {
      if (_isCorrectAnswer) {
        wordsList.removeAt(currentIndex);
        score++;
      }
    });
    if (wordsList.isNotEmpty) {
      _getRandomWord();
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
        title: Text(MyText.wordWritingTest),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : widget.publicWordsList.isEmpty
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
            wordsList[currentIndex].translation,
            style: TextStyle(fontSize: Dimensions.fontSize(17)),
          ),
        ),
        SizedBox(height: Dimensions.height(5)),
        _answerDesign(),
        Spacer(),
        _lettersPlaceDesign(),
        Spacer(),
        MyWidgets.questionsButton(() => _checkWord(),
            caseImplemented: letters.isEmpty),
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

  Widget _answerDesign() {
    return CustomPaint(
      painter: LinePainter(),
      child: Container(
        alignment: Alignment.topLeft,
        height: Dimensions.height(150.0),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(15),
        ),
        child: Wrap(
          spacing: Dimensions.width(4.0),
          runSpacing: Dimensions.height(4.0),
          children: <Widget>[
            for (int i = 0; i < currentWord.length; i++)
              GestureDetector(
                onTap: () => _removeLetter(i),
                child: Chip(
                  label: Text(
                    currentWord[i],
                    style: TextStyle(fontSize: Dimensions.fontSize(18)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.horizontal(8),
                    vertical: Dimensions.vertical(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _lettersPlaceDesign() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(25)),
        child: Wrap(
          spacing: Dimensions.width(4.0),
          runSpacing: Dimensions.height(8.0),
          children: letters.map((letter) {
            return GestureDetector(
              onTap: () => _addLetter(letter),
              child: Chip(
                label: Text(
                  letter,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.horizontal(8.0),
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
