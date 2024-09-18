import 'dart:math';
import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/congratulations_page.dart';
import 'package:menschen/screens/exams/fash_card_words/flash_card_word.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';

class FlashCardGame extends StatefulWidget {
  final List<Word> publicWordsList;
  const FlashCardGame({super.key, required this.publicWordsList});

  @override
  State<FlashCardGame> createState() => _FlashCardGameState();
}

class _FlashCardGameState extends State<FlashCardGame> {
  List<Word> wordsList = [];
  late int _currentIndex;
  bool _showAnswer = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    if (widget.publicWordsList.isNotEmpty) {
      wordsList = List.from(widget.publicWordsList);
      _currentIndex = random.nextInt(wordsList.length);
      MyFunctions.speak(wordsList[_currentIndex].word);
    }
  }

  void _nextCard() async {
    if (wordsList.length == 1) {
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
      wordsList.removeAt(_currentIndex);
    });
    if (wordsList.isNotEmpty) {
      setState(() {
        _currentIndex = random.nextInt(wordsList.length);
      });
      MyFunctions.speak(wordsList[_currentIndex].word);
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
        title: Text(MyText.flashcardTest),
        centerTitle: true,
      ),
      body: widget.publicWordsList.isEmpty ? _emptyListPage() : _body(),
      floatingActionButton: widget.publicWordsList.isEmpty
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
            audioText: wordsList[_currentIndex].word,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: _toggleCard,
          child: FlashCard(
            word: wordsList[_currentIndex],
            showAnswer: _showAnswer,
          ),
        ),
      ],
    );
  }
}
