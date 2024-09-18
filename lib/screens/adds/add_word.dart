import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/words_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddWord extends StatefulWidget {
  const AddWord({super.key});

  @override
  State<AddWord> createState() => _AddWordState();
}

class _AddWordState extends State<AddWord> {
  final _formKey = GlobalKey<FormState>();
  final wordController = TextEditingController();
  // final articalController = TextEditingController();
  final translationController = TextEditingController();
  final pluralController = TextEditingController();
  final feminineController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;

  String _selectedArticle = "";

  @override
  void initState() {
    super.initState();
    getLevels();
    if (getLessonsList.isEmpty) isThereLessons = false;
  }

  Future addWord() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO words (word, artical, translation, plural, feminine, lesson_id) VALUES 
        (?, ?, ?, ?, ?, ?)
      ''',
          [
            MyFunctions.clearTheText(wordController.text),
            MyFunctions.clearTheText(_selectedArticle),
            MyFunctions.clearTheText(translationController.text),
            MyFunctions.clearTheText(pluralController.text),
            MyFunctions.clearTheText(feminineController.text),
            int.parse(getLessonSelected),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WordsPage()));
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          desc: MyText.somethingWrong,
        ).show();
      }
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.bottomSlide,
        desc: MyText.pleaseEnterAllData,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.addWord),
        centerTitle: true,
      ),
      body: isThereLessons && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereLessons
              ? Center(
                  child: Text(
                  MyText.addLessons,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: Dimensions.horizontal(50),
            vertical: Dimensions.vertical(50),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                controlsDesignToAddPages(() {
                  setState(() {});
                }),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputForm(
                  controller: wordController,
                  label: MyText.word,
                  error: MyText.enterTheWord,
                ),
                SizedBox(height: Dimensions.height(25)),
                Row(
                  children: [
                    _articleDesign("die"),
                    SizedBox(width: Dimensions.width(10)),
                    _articleDesign("der"),
                    SizedBox(width: Dimensions.width(10)),
                    _articleDesign("das"),
                  ],
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabic(
                  controller: translationController,
                  label: MyText.translation,
                  error: MyText.enterTheTranslation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: pluralController,
                  label: MyText.plural,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: feminineController,
                  label: MyText.feminine,
                ),
                SizedBox(height: Dimensions.height(25)),
                MaterialButton(
                  color: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child:
                      Text(MyText.add, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    addWord();
                  },
                ),
                SizedBox(height: Dimensions.height(25)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _articleDesign(String title) {
    bool isSelected = _selectedArticle == title;
    Color color = isSelected ? mainColor : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;

    return Expanded(
      child: SizedBox(
        height: Dimensions.height(48),
        child: ElevatedButton(
          onPressed: () async {
            if (_selectedArticle == title) {
              setState(() {
                _selectedArticle = "";
              });
            } else {
              setState(() {
                _selectedArticle = title;
              });
            }
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
      ),
    );
  }
}
