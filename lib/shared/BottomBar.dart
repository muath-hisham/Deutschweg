import 'package:flutter/material.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/exams/exams_page.dart';
import 'package:menschen/screens/home_page.dart';
import 'package:menschen/screens/lessons/lessons_page.dart';
import 'package:menschen/screens/books/books_page.dart';
import 'package:menschen/screens/settings/settings_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class BottomBar extends StatefulWidget {
  final String active;

  const BottomBar({Key? key, this.active = "null"});

  @override
  State<BottomBar> createState() => _BottomBarState(active);
}

class _BottomBarState extends State<BottomBar> {
  String active;
  bool home = false;
  bool exams = false;
  bool books = false;
  bool lessons = false;
  bool settings = false;

  @override
  _BottomBarState(this.active);

  void whoIsActive() {
    // Determine the active state based on the provided value
    if (active == "home") {
      home = true;
    } else if (active == "exams") {
      exams = true;
    } else if (active == "books") {
      books = true;
    } else if (active == "settings") {
      settings = true;
    } else if (active == "lessons") {
      lessons = true;
    }
  }

  @override
  void initState() {
    super.initState();
    whoIsActive();
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      // color: Colors.transparent,
      elevation: 9.0,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: Dimensions.height(70),
        // color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildIconButton(
              onTap: () {
                if (!home) _navigateToHomePage(context);
              },
              icon: home ? Icons.home : Icons.home_outlined,
              isActive: home,
              title: MyText.home,
            ),
            _buildIconButton(
              onTap: () {
                if (!exams) _navigateToExamsPage(context);
              },
              icon: exams ? Icons.quiz : Icons.quiz_outlined,
              isActive: exams,
              title: MyText.exams,
            ),
            _buildIconButton(
              onTap: () {
                if (!books) _navigateToBooksPage(context);
              },
              icon: books ? Icons.menu_book : Icons.menu_book_outlined,
              isActive: books,
              title: MyText.books,
            ),
            _buildIconButton(
              onTap: () {
                if (!lessons) _navigateToLessons(context);
              },
              icon: lessons ? Icons.book : Icons.book_outlined,
              isActive: lessons,
              title: MyText.lessons,
            ),
            _buildIconButton(
              onTap: () {
                if (!settings) _navigateToSettings(context);
              },
              icon: settings ? Icons.settings : Icons.settings_outlined,
              isActive: settings,
              title: MyText.settings,
            ),
          ],
        ),
      ),
    );
  }

  // Private function to build IconButton with specified parameters
  Widget _buildIconButton({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required bool isActive,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: Dimensions.fontSize(25),
              color: isActive ? mainColor : Colors.black,
            ),
            SizedBox(height: Dimensions.height(5)),
            Text(
              title,
              style: TextStyle(
                fontSize: Dimensions.fontSize(10),
                color: isActive ? mainColor : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to the Home page
  void _navigateToHomePage(BuildContext context) async {
    SqlDb db = SqlDb();
    List<Word> wordsList = [];
    List<Map<String, dynamic>> dataList =
        await db.readData("SELECT * FROM words");
    for (Map<String, dynamic> map in dataList) {
      Word word = Word.fromMap(map);
      wordsList.add(word);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePage(wordsList: wordsList)));
  }

  // Navigate to the exams page
  void _navigateToExamsPage(BuildContext context) async {
    SqlDb db = SqlDb();
    List<Word> wordsList = [];
    List<Map<String, dynamic>> dataList =
        await db.readData("SELECT * FROM words");
    for (Map<String, dynamic> map in dataList) {
      Word word = Word.fromMap(map);
      wordsList.add(word);
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ExamsPage(publicWordsList: wordsList)));
  }

  // Navigate to the Notifications page
  void _navigateToBooksPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => BooksPage()));
  }

  // Navigate to the Lessons page
  void _navigateToLessons(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LessonsPage()));
  }

  // Navigate to the Settings page
  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SettingsPage()));
  }
}
