import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_game_model.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import '../fash_card_words/page_flip_builder.dart';

class FlashCard extends StatelessWidget {
  final SentenceGame sentence;
  final bool showAnswer;

  FlashCard({
    required this.sentence,
    required this.showAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return PageFlipBuilder(
      showFront: !showAnswer,
      frontWidget: _myCard(
        child: Container(
          key: ValueKey('question'),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width(16)),
            child: Center(
              child: Text(
                sentence.sentence,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(24),
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      backWidget: _myCard(
        child: Container(
          key: ValueKey('answer'),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.width(16)),
            child: Center(
              child: Text(
                sentence.translation,
                style: TextStyle(fontSize: Dimensions.fontSize(24)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _myCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(30),
        horizontal: Dimensions.horizontal(30),
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.vertical(70)),
      decoration: BoxDecoration(
        border: Border.all(width: 0.3, color: Colors.grey.shade300),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: Offset(0, 1), // Offset from the top-left corner
          ),
        ],
      ),
      child: child,
    );
  }
}
