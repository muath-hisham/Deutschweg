import 'dart:math';

import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/pages/colors_page.dart';
import 'package:menschen/screens/pages/conversations_page.dart';
import 'package:menschen/screens/pages/countries_page.dart';
import 'package:menschen/screens/pages/grammar_page.dart';
import 'package:menschen/screens/pages/adjectives_page.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/screens/pages/questions_page.dart';
import 'package:menschen/screens/pages/sentences_page.dart';
import 'package:menschen/screens/pages/verbs_page.dart';
import 'package:menschen/screens/pages/w_questions_page.dart';
import 'package:menschen/screens/pages/words_page.dart';
import 'package:menschen/shared/BottomBar.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';

class HomePage extends StatefulWidget {
  final List<Word> wordsList;
  const HomePage({super.key, required this.wordsList});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Word randomWord;
  bool isTheAudioRun = false;

  @override
  void initState() {
    super.initState();
    _getRandomWord();
  }

  void _getRandomWord() {
    if (widget.wordsList.isNotEmpty) {
      // Generate a random index
      Random random = Random();
      int randomIndex = random.nextInt(widget.wordsList.length);

      // Retrieve the random item from the list
      Word randomWord = widget.wordsList[randomIndex];

      // set the new word
      setState(() {
        this.randomWord = randomWord;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await MyWidgets.showExitConfirmationDialog(context);
        return shouldExit;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomBar(active: "home"),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _randomWordDesgin(),
        _tabs(),
        _tabsContent(),
      ],
    );
  }

  Widget _randomWordDesgin() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(20)),
      color: mainColor,
      child: widget.wordsList.isEmpty
          ? Container(
              height: Dimensions.height(140),
              width: double.infinity,
              child: Center(
                  child: Text(
                MyText.addWord,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(20),
                  color: Colors.white,
                ),
              )),
            )
          : Row(
              children: [
                TTSWidget(audioText: randomWord.word, color: headTextColor),
                const SizedBox(width: Dimensions.horizontalSpace),
                Expanded(
                  child: InkWell(
                    onTap: () => _getRandomWord(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.height(50)),
                        Wrap(
                          children: [
                            randomWord.artical == "null" ||
                                    randomWord.artical!.trim() == ""
                                ? SizedBox()
                                : Text(
                                    randomWord.artical!,
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSize(13),
                                      color: headTextColor,
                                    ),
                                  ),
                            const SizedBox(width: Dimensions.horizontalSpace),
                            Text(
                              randomWord.word,
                              style: TextStyle(
                                fontSize: Dimensions.fontSize(17),
                                color: headTextColor,
                              ),
                            ),
                            const SizedBox(width: Dimensions.horizontalSpace),
                            randomWord.plural == "null" ||
                                    randomWord.plural!.trim() == ""
                                ? SizedBox()
                                : Text(
                                    "[pl: ${randomWord.plural}]",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSize(13),
                                      color: headTextColor,
                                    ),
                                  ),
                            const SizedBox(width: Dimensions.horizontalSpace),
                            randomWord.feminine == "null" ||
                                    randomWord.feminine!.trim() == ""
                                ? SizedBox()
                                : Text(
                                    "[feminin: ${randomWord.feminine}]",
                                    style: TextStyle(
                                      fontSize: Dimensions.fontSize(13),
                                      color: headTextColor,
                                    ),
                                  ),
                          ],
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            children: [
                              Text(
                                randomWord.translation,
                                style: TextStyle(
                                  fontSize: Dimensions.fontSize(17),
                                  color: headTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.height(15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _tabs() {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.height(20),
        left: Dimensions.horizontal(30),
        right: Dimensions.horizontal(30),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.horizontal(3),
        vertical: Dimensions.vertical(3),
      ),
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Color(0xffc2c2c2), width: 0.5)),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Creates border
          color: tabControllerColor,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        tabs: [
          Tab(text: MyText.divider),
          Tab(text: MyText.notDivider),
        ],
      ),
    );
  }

  Widget _tabsContent() {
    return Expanded(
      child: TabBarView(
        children: [
          _divider(),
          _notDivider(),
        ],
      ),
    );
  }

  Widget _divider() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.vertical(20)),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(20)),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            MyWidgets.buttonDesign(MyText.words, () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => WordsPage()));
            }),
            MyWidgets.buttonDesign(MyText.verbs, () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => VerbsPage()));
            }),
            MyWidgets.buttonDesign(MyText.sentences, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SentencesPage()));
            }),
            MyWidgets.buttonDesign(MyText.questions, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => QuestionsPage()));
            }),
            MyWidgets.buttonDesign(MyText.adjective, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdjectivesPage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _notDivider() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: Dimensions.vertical(20)),
        padding: EdgeInsets.symmetric(horizontal: Dimensions.horizontal(20)),
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            MyWidgets.buttonDesign(MyText.prepositions, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PrepositionsPage()));
            }),
            MyWidgets.buttonDesign(MyText.wQuestions, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => WQuestionsPage()));
            }),
            MyWidgets.buttonDesign(MyText.grammar, () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => GrammarPage()));
            }),
            MyWidgets.buttonDesign(MyText.colors, () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ColorsPage()));
            }),
            MyWidgets.buttonDesign(MyText.countries, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CountriesPage()));
            }),
            MyWidgets.buttonDesign(MyText.conversations, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ConversationsPage()));
            }),
          ],
        ),
      ),
    );
  }
}
