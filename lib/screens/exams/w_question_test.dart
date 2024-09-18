import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class WQuestionTest extends StatefulWidget {
  final String startLesson;
  final String endLesson;
  final bool isAllChecked;
  const WQuestionTest(
      {super.key,
      required this.startLesson,
      required this.endLesson,
      required this.isAllChecked});

  @override
  State<WQuestionTest> createState() => _WQuestionTestState();
}

class _WQuestionTestState extends State<WQuestionTest> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  String? _firstWord;
  String? _questionWithoutFirstWord;
  bool _isCorrectAnswer = false;
  bool _isCheckPressed = false;
  bool _isLoading = true;
  int score = 0;

  List<Question> questionList = [];
  List<String> answers = [
    "Wo",
    "Was",
    "Wer",
    "Wie",
    "Wann",
    "Woher",
    "Warum",
    "Welche",
    "Wohin",
  ];
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _getTheQuestions();
  }

  void _getTheQuestions() async {
    SqlDb sqlDb = SqlDb();
    List<Map<String, dynamic>> li;
    if (widget.isAllChecked) {
      li = await sqlDb.readData('''SELECT * FROM questions WHERE 
    question LIKE 'wo %' OR question LIKE 'Wo %' OR 
    question LIKE 'was %' OR question LIKE 'Was %' OR 
    question LIKE 'wer %' OR question LIKE 'Wer %' OR 
    question LIKE 'wie %' OR question LIKE 'Wie %' OR 
    question LIKE 'wann %' OR question LIKE 'Wann %' OR 
    question LIKE 'woher %' OR question LIKE 'Woher %' OR 
    question LIKE 'warum %' OR question LIKE 'Warum %' OR 
    question LIKE 'welche %' OR question LIKE 'Welche %' OR 
    question LIKE 'wohin %' OR question LIKE 'Wohin %'; ''');
    } else {
      li = await sqlDb.readDataWithArg('''SELECT * FROM questions WHERE 
    (question LIKE 'wo %' OR question LIKE 'Wo %' OR 
    question LIKE 'was %' OR question LIKE 'Was %' OR 
    question LIKE 'wer %' OR question LIKE 'Wer %' OR 
    question LIKE 'wie %' OR question LIKE 'Wie %' OR 
    question LIKE 'wann %' OR question LIKE 'Wann %' OR 
    question LIKE 'woher %' OR question LIKE 'Woher %' OR 
    question LIKE 'warum %' OR question LIKE 'Warum %' OR 
    question LIKE 'welche %' OR question LIKE 'Welche %' OR 
    question LIKE 'wohin %' OR question LIKE 'Wohin %')
    AND lesson_id BETWEEN ? AND ?; ''', [widget.startLesson, widget.endLesson]);
    }

    for (Map<String, dynamic> map in li) {
      Question question = Question.fromMap(map);
      setState(() {
        questionList.add(question);
      });
    }

    if (questionList.isEmpty) {
      setState(() {
        _isLoading = false;
        return;
      });
    } else {
      _getRandomQuestion();
    }
  }

  // Selects a random question from the list
  void _getRandomQuestion() {
    setState(() {
      _isLoading = true;
    });

    Random random = Random();
    _currentQuestionIndex = random.nextInt(questionList.length);

    _firstWord = _getTheFirstWord(questionList[_currentQuestionIndex].question);
    _questionWithoutFirstWord = _getTheQuestionWithoutFirstWord(
        questionList[_currentQuestionIndex].question);
    setState(() {
      _isLoading = false;
    });
  }

  String _getTheFirstWord(String text) {
    // Trim leading and trailing whitespace
    String trimmedText = text.trim();

    // Split the text by spaces
    List<String> words = trimmedText.split(' ');

    // Get the first word (considering the case where there might be multiple spaces)
    String firstWord =
        words.firstWhere((word) => word.isNotEmpty, orElse: () => '');
    return firstWord;
  }

  String _getTheQuestionWithoutFirstWord(String text) {
    // Trim leading and trailing whitespace
    String trimmedText = text.trim();

    // Find the index of the first space after trimming
    int firstSpaceIndex = trimmedText.indexOf(' ');

    String textWithoutFirstWord = "";
    // If there is no space, the entire text is one word
    if (firstSpaceIndex == -1) {
      print("No other words, only first word present.");
    } else {
      // Extract the text after the first space
      textWithoutFirstWord = trimmedText.substring(firstSpaceIndex).trim();
    }

    return textWithoutFirstWord;
  }

  // Checks if the selected answer is correct
  void _onCheckPressed() {
    print("i am hear");
    if (_selectedAnswer != null) {
      setState(() {
        _isCheckPressed = true;
        _isCorrectAnswer = _selectedAnswer == _firstWord;
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
      _isLoading = true;
    });
    setState(() {
      if (_isCorrectAnswer) {
        questionList.removeAt(_currentQuestionIndex);
      }
      _isCheckPressed = false;
      _isCorrectAnswer = false;
      _selectedAnswer = null;
      if (questionList.isNotEmpty) {
        _getRandomQuestion();
        _firstWord =
            _getTheFirstWord(questionList[_currentQuestionIndex].question);
      } else {
        // Handle the case where there are no more questions
        if (questionList.isEmpty) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CongratulationsPage()));
        }
      }
    });
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
        title: Text(MyText.wQuestionTest),
        centerTitle: true,
      ),
      body: questionList.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : questionList.isEmpty
              ? _emptyQustionsPage()
              : _body(),
    );
  }

  Widget _emptyQustionsPage() {
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
        SizedBox(height: Dimensions.height(70)),
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
                onPressed: () => MyFunctions.speak(_questionWithoutFirstWord!),
                icon: Icon(Icons.volume_up_outlined)),
            Flexible(
              child: Text(
                "....... $_questionWithoutFirstWord",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.height(35)),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: (answers.length / 2).ceil(),
              itemBuilder: (context, index) {
                // Calculate the index for the left and right buttons
                int leftIndex = index * 2;
                int rightIndex = leftIndex + 1;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Check if leftIndex is within the range of answers
                    if (leftIndex < answers.length)
                      _answerButtonToExams(answers[leftIndex]),
                    // Check if rightIndex is within the range of answers
                    if (rightIndex < answers.length)
                      _answerButtonToExams(answers[rightIndex]),
                  ],
                );
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
      } else if (title == _firstWord && !_isCorrectAnswer) {
        color = Colors.green;
        textColor = Colors.white;
      }
    }

    return Container(
      width: Dimensions.width(110),
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
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
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
