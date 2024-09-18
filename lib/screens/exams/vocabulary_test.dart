import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';

class VocabularyTest extends StatefulWidget {
  final List<Word> publicWordsList;
  const VocabularyTest({super.key, required this.publicWordsList});

  @override
  State<VocabularyTest> createState() => _VocabularyTestState();
}

class _VocabularyTestState extends State<VocabularyTest> {
  List<Word> wordsList = [];
  List<Word> copyWordsList = [];
  int _currentQuestionIndex = 0;
  Word? _selectedAnswer;
  bool _isCorrectAnswer = false;
  bool _isCheckPressed = false;
  int score = 0;
  Word currentQuestion = Word.impty();

  List<Word> answers = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.publicWordsList.isNotEmpty) {
      wordsList = List.from(widget.publicWordsList);
      copyWordsList = List.from(widget.publicWordsList);
      _getRandomQuestion();
      _fillAnswers();
    }
  }

  // Selects a random question from the list
  void _getRandomQuestion() {
    if (wordsList.isNotEmpty) {
      Random random = Random();
      _currentQuestionIndex = random.nextInt(wordsList.length);
      currentQuestion = wordsList[_currentQuestionIndex];
    }
  }

  // Fills the answers list with the correct answer and two random wrong answers
  void _fillAnswers() {
    if (wordsList.isNotEmpty) {
      answers.clear();

      // Add the correct answer
      answers.add(wordsList[_currentQuestionIndex]);

      // Create a copy of the list excluding the current correct answer
      List<Word> tempList = List.from(copyWordsList)
        ..removeWhere(
            (word) => word.word == wordsList[_currentQuestionIndex].word);

      Random random = Random();

      // Select two unique random wrong answers
      Set<int> usedIndices = {};
      while (usedIndices.length < 2) {
        int index = random.nextInt(tempList.length);
        if (!usedIndices.contains(index)) {
          usedIndices.add(index);
        }
      }

      // Add the unique wrong answers to the answers list
      for (int index in usedIndices) {
        answers.add(tempList[index]);
      }

      answers.shuffle(Random());
    }
  }

  // Checks if the selected answer is correct
  void _onCheckPressed() {
    if (_selectedAnswer != null) {
      setState(() {
        _isCheckPressed = true;
        _isCorrectAnswer = _selectedAnswer == wordsList[_currentQuestionIndex];
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
        wordsList.removeAt(_currentQuestionIndex);
      }
      _isCheckPressed = false;
      _isCorrectAnswer = false;
      _selectedAnswer = null;
      if (wordsList.isNotEmpty) {
        _getRandomQuestion();
        _fillAnswers();
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
        title: Text(MyText.vocabularyTest),
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
        Center(
          child: Text(
            currentQuestion.translation,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
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
  Widget _answerButtonToExams(Word answer) {
    bool isSelected = _selectedAnswer == answer;
    Color color = isSelected ? Colors.orangeAccent : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;

    if (_isCheckPressed) {
      if (isSelected) {
        color = _isCorrectAnswer ? Colors.green : Colors.redAccent;
      } else if (answer == wordsList[_currentQuestionIndex] &&
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
              _selectedAnswer = answer;
            });
          }
          await MyFunctions.speak(answer.word);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          backgroundColor: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${answer.artical} ",
              style: TextStyle(
                color: textColor,
                fontSize: Dimensions.fontSize(12),
              ),
            ),
            Text(
              answer.word,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
