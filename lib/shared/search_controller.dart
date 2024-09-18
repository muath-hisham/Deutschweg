import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menschen/models/color_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/models/verb_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/shared/color_card.dart';
import 'package:menschen/screens/shared/preposition_card.dart';
import 'package:menschen/screens/shared/question_card.dart';
import 'package:menschen/screens/shared/sentence_card.dart';
import 'package:menschen/screens/shared/verb_card.dart';
import 'package:menschen/screens/shared/word_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/models/preposition_model.dart';

class DataSearch extends SearchDelegate {
  final List<Map<String, dynamic>> dataList;
  final Option title;
  List<Map<String, dynamic>> suggestionList = [];

  DataSearch(this.dataList, this.title);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show some result based on the selection
    return Container(
      padding: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          switch (title) {
            case Option.word:
              Word word = Word.fromMap(suggestionList[index]);
              return WordCard(word: word);
            case Option.verb:
              Verb verb = Verb.fromMap(suggestionList[index]);
              return VerbCard(verb: verb);
            case Option.sentence:
              Sentence sentence = Sentence.fromMap(suggestionList[index]);
              return SentenceCard(sentence: sentence);
            case Option.question:
              Question question = Question.fromMap(suggestionList[index]);
              return QuestionCard(question: question);
            case Option.color:
              MyColor color = MyColor.fromMap(suggestionList[index]);
              return ColorCard(color: color);
            case Option.preposition:
              Preposition preposition =
                  Preposition.fromMap(suggestionList[index]);
              return PrepositionCard(preposition: preposition);
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show when someone searches for something
    suggestionList = query.isEmpty
        ? dataList
        : dataList
            .where((p) =>
                p[getOptionName(title)]
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()) ||
                p['translation']
                    .toLowerCase()
                    .trim()
                    .contains(query.toLowerCase().trim()))
            .toList();

    return Container(
      padding: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          switch (title) {
            case Option.word:
              Word word = Word.fromMap(suggestionList[index]);
              return WordCard(word: word);
            case Option.verb:
              Verb verb = Verb.fromMap(suggestionList[index]);
              return VerbCard(verb: verb);
            case Option.sentence:
              Sentence sentence = Sentence.fromMap(suggestionList[index]);
              return SentenceCard(sentence: sentence);
            case Option.question:
              Question question = Question.fromMap(suggestionList[index]);
              return QuestionCard(question: question);
            case Option.color:
              MyColor color = MyColor.fromMap(suggestionList[index]);
              return ColorCard(color: color);
            case Option.preposition:
              Preposition preposition =
                  Preposition.fromMap(suggestionList[index]);
              return PrepositionCard(preposition: preposition);
          }
        },
      ),
    );
  }
}
