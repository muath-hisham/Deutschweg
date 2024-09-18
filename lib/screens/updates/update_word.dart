import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/word_model.dart';
import 'package:menschen/screens/pages/words_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class WordUpdate extends StatefulWidget {
  final Word word;
  const WordUpdate({super.key, required this.word});

  @override
  State<WordUpdate> createState() => _WordUpdateState();
}

class _WordUpdateState extends State<WordUpdate> {
  final _formKey = GlobalKey<FormState>();
  final wordController = TextEditingController();
  final translationController = TextEditingController();
  final pluralController = TextEditingController();
  final feminineController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;
  Lesson? selectedLesson;
  bool isFinishLoad = false;

  String _selectedArticle = "";

  @override
  void initState() {
    super.initState();
    wordController.text = widget.word.word;
    translationController.text = widget.word.translation;
    if (widget.word.artical!.trim() != "" && widget.word.artical != null) {
      _selectedArticle = widget.word.artical!;
    }
    if (widget.word.plural!.trim() != "" && widget.word.plural != null) {
      pluralController.text = widget.word.plural!;
    }
    if (widget.word.feminine!.trim() != "" && widget.word.feminine != null) {
      feminineController.text = widget.word.feminine!;
    }
    _getData();
  }

  Future _getData() async {
    await getLessonById(widget.word.lessonId).then((lesson) {
      setState(() {
        selectedLesson = lesson;
      });
    });
    await getLevelsUndLessonsToUpdatePages(selectedLesson!.levelId);
    setState(() {
      isFinishLoad = true;
    });
  }

  Future _updateWord() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE words SET word = ?, artical = ?, translation = ?, plural = ?, feminine = ?, lesson_id = ? WHERE word_id = ?''',
          [
            MyFunctions.clearTheText(wordController.text),
            MyFunctions.clearTheText(_selectedArticle),
            MyFunctions.clearTheText(translationController.text),
            MyFunctions.clearTheText(pluralController.text),
            MyFunctions.clearTheText(feminineController.text),
            selectedLesson!.id,
            widget.word.id
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
        title: Text(MyText.updateWord),
        centerTitle: true,
      ),
      body: isThereLessons && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereLessons
              ? Text(MyText.addLessons)
              : selectedLesson == null || isFinishLoad == false
                  ? Center(child: CircularProgressIndicator())
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
                controlsDesignToUpdatePages(
                  () => setState(() {}),
                  selectedLesson!,
                ),
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
                  child: Text(
                    MyText.update,
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    _updateWord();
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
            setState(() {
              if (_selectedArticle == title) {
                _selectedArticle = "";
              } else {
                _selectedArticle = title;
              }
            });
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
