import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/adjective_mode.dart';
import 'package:menschen/models/lesson_model.dart';
import 'package:menschen/screens/pages/adjectives_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AdjectiveUpdate extends StatefulWidget {
  final Adjective adjective;
  const AdjectiveUpdate({super.key, required this.adjective});

  @override
  State<AdjectiveUpdate> createState() => _AdjectiveUpdateState();
}

class _AdjectiveUpdateState extends State<AdjectiveUpdate> {
  final _formKey = GlobalKey<FormState>();
  final adjectiveController = TextEditingController();
  final adjTranslationController = TextEditingController();
  final oppositeController = TextEditingController();
  final oppTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereLessons = true;
  Lesson? selectedLesson;
  bool isFinishLoad = false;

  @override
  void initState() {
    super.initState();
    adjectiveController.text = widget.adjective.adjective;
    adjTranslationController.text = widget.adjective.adjTranslation;
    oppositeController.text = widget.adjective.opposite!;
    oppTranslationController.text = widget.adjective.oppTranslation!;
    _getData();
  }

  Future _getData() async {
    await getLessonById(widget.adjective.lessonId).then((lesson) {
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
        UPDATE adjectives SET adjective = ?, adj_translation = ?, opposite =?, opp_translation = ?, lesson_id = ? WHERE adjective_id = ?''',
          [
            MyFunctions.clearTheText(adjectiveController.text),
            MyFunctions.clearTheText(adjTranslationController.text),
            MyFunctions.clearTheText(oppositeController.text),
            MyFunctions.clearTheText(oppTranslationController.text),
            selectedLesson!.id,
            widget.adjective.id
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AdjectivesPage()));
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
        title: Text(MyText.updateAdjective),
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
                  controller: adjectiveController,
                  label: MyText.adjective,
                  error: MyText.enterTheAdjective,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabic(
                  controller: adjTranslationController,
                  label: MyText.translation,
                  error: MyText.enterTheTranslation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: oppositeController,
                  label: MyText.opposite,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabicOptional(
                  controller: oppTranslationController,
                  label: MyText.translation,
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
