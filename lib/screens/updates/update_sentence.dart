import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/screens/pages/sentences_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class SentenceUpdate extends StatefulWidget {
  final Sentence sentence;
  const SentenceUpdate({super.key, required this.sentence});

  @override
  State<SentenceUpdate> createState() => _SentenceUpdateState();
}

class _SentenceUpdateState extends State<SentenceUpdate> {
  final _formKey = GlobalKey<FormState>();
  final sentenceController = TextEditingController();
  final translationController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;
  Lesson? selectedLesson;
  bool isFinishLoad = false;

  @override
  void initState() {
    super.initState();
    sentenceController.text = widget.sentence.sentence;
    translationController.text = widget.sentence.translation;
    _getData();
  }

  Future _getData() async {
    await getLessonById(widget.sentence.lessonId).then((lesson) {
      setState(() {
        selectedLesson = lesson;
      });
    });
    await getLevelsUndLessonsToUpdatePages(selectedLesson!.levelId);
    setState(() {
      isFinishLoad = true;
    });
  }

  Future _updateSentence() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE sentences SET sentence = ?, translation = ?, lesson_id = ? WHERE sentence_id = ?''',
          [
            MyFunctions.clearTheText(sentenceController.text),
            MyFunctions.clearTheText(translationController.text),
            selectedLesson!.id,
            widget.sentence.id
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SentencesPage()));
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
        title: Text(MyText.updateSentence),
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
                  controller: sentenceController,
                  label: MyText.sentence,
                  error: MyText.enterTheSentence,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabic(
                  controller: translationController,
                  label: MyText.translation,
                  error: MyText.enterTheTranslation,
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
                    _updateSentence();
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
}
