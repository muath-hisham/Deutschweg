import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';

class ArticalTest extends StatefulWidget {
  final List<Word> publicWordsList;
  const ArticalTest({super.key, required this.publicWordsList});

  @override
  State<ArticalTest> createState() => _ArticalTestState();
}

class _ArticalTestState extends State<ArticalTest> {
  List<Word> wordsList = [];
  int _currentWordIndex = 0;
  String? _selectedAnswer;
  bool _isCorrectAnswer = false;
  bool _isCheckPressed = false;
  int score = 0;
  Word currentWord = Word.impty();

  List<String> answers = [
    "die",
    "der",
    "das",
  ];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.publicWordsList.isNotEmpty) {
      wordsList = List<Word>.from(
        widget.publicWordsList
            .where((word) => word.artical != null && word.artical!.isNotEmpty),
      );
      _getRandomWord();
    }
  }

  // Selects a random question from the list
  void _getRandomWord() {
    if (wordsList.isNotEmpty) {
      Random random = Random();
      _currentWordIndex = random.nextInt(wordsList.length);
      MyFunctions.speak(wordsList[_currentWordIndex].word);
      currentWord = wordsList[_currentWordIndex];
    }
  }

  // Checks if the selected answer is correct
  void _onCheckPressed() {
    if (_selectedAnswer != null) {
      setState(() {
        _isCheckPressed = true;
        _isCorrectAnswer =
            _selectedAnswer == wordsList[_currentWordIndex].artical;
        _playSound(_isCorrectAnswer);
        if (_isCorrectAnswer) {
          score++;
        }
      });
    }
  }

  // Moves to the next question
  void _onNextPressed() {
    setState(() {
      if (_isCorrectAnswer) {
        wordsList.removeAt(_currentWordIndex);
      }
      _isCheckPressed = false;
      _isCorrectAnswer = false;
      _selectedAnswer = null;
      if (wordsList.isNotEmpty) {
        _getRandomWord();
      }
    });
    if (wordsList.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => CongratulationsPage()));
    }
  }

  // Plays a sound based on whether the answer is correct or not
  Future<void> _playSound(bool isCorrect) async {
    String soundPath = isCorrect ? 'sounds/correct.mp3' : 'sounds/wrong.mp3';
    await _audioPlayer.play(AssetSource(soundPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.articleTest),
        centerTitle: true,
      ),
      body: widget.publicWordsList.isEmpty ? _emptyListPage() : _body(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.height(80)),
        Center(
          child: Text(
            "${MyText.score} / $score",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: Dimensions.height(40)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => MyFunctions.speak(currentWord.word),
              icon: Icon(Icons.volume_up_outlined),
            ),
            SizedBox(width: Dimensions.horizontalSpace),
            Text(
              currentWord.word,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height(25)),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: answers.length,
              itemBuilder: (context, index) {
                return _answerButtonToExams(answers[index]);
              },
            ),
          ),
        ),
        MyWidgets.questionsButton(
          () => _isCheckPressed ? _onNextPressed() : _onCheckPressed(),
          caseImplemented: _selectedAnswer != null,
          isNext: _isCheckPressed,
        ),
      ],
    );
  }

  // Builds an answer button
  Widget _answerButtonToExams(String title) {
    bool isSelected = _selectedAnswer == title;
    Color color = isSelected ? Colors.orangeAccent : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;

    if (_isCheckPressed) {
      if (isSelected) {
        color = _isCorrectAnswer ? Colors.green : Colors.redAccent;
      } else if (title == wordsList[_currentWordIndex].artical &&
          !_isCorrectAnswer) {
        color = Colors.green;
        textColor = Colors.white;
      }
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: Dimensions.vertical(8)),
      height: Dimensions.height(48),
      child: ElevatedButton(
        onPressed: () async {
          if (!_isCheckPressed) {
            setState(() {
              _selectedAnswer = title;
            });
          }
          await MyFunctions.speak(title);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: color,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
