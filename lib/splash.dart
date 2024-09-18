import 'dart:math';

import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/settings/notifications/notification.dart';
import 'package:menschen/screens/home_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  SqlDb db = SqlDb();

  List<Word> wordsList = [];

  Future<void> _getWords() async {
    List<Map<String, dynamic>> dataList =
        await db.readData("SELECT * FROM words");
    for (Map<String, dynamic> map in dataList) {
      Word word = Word.fromMap(map);
      wordsList.add(word);
    }
  }

  Future<Word> _getRandomWord() async {
    Random random = Random();
    int index = random.nextInt(wordsList.length);
    return wordsList[index];
  }

  Future<void> _transitionToApp(BuildContext context) async {
    // await db.deleteDataBase();
    await _getWords();
    if (wordsList.isNotEmpty) {
      Word word = await _getRandomWord();
      Notifications.scheduleHourlyNotification(word);
    }
    await Future.delayed(Duration(seconds: 1)); // Simulate a delay of 1 second
    MyFunctions.speak("");

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(wordsList: wordsList)));
  }

  @override
  Widget build(BuildContext context) {
    _transitionToApp(context);

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Image.asset(
              "assets/icon.png",
              width: Dimensions.getScreenWidth / 1.3, // 0.76 the screen
            ),
            const Spacer(flex: 2),
            Text(
              MyText.writtenByAuthor,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.fontSize(18),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: Dimensions.height(40)),
            Center(child: CircularProgressIndicator(color: mainColor)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
