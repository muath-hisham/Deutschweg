import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/adjectives_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';
import 'package:menschen/shared/functions.dart';

class AddAdjective extends StatefulWidget {
  const AddAdjective({super.key});

  @override
  State<AddAdjective> createState() => _AddAdjectiveState();
}

class _AddAdjectiveState extends State<AddAdjective> {
  final _formKey = GlobalKey<FormState>();
  final adjectiveController = TextEditingController();
  final adjTranslationController = TextEditingController();
  final oppositeController = TextEditingController();
  final oppTranslationController = TextEditingController();
  SqlDb sqlDb = SqlDb();
  bool isThereadjectives = true;

  @override
  void initState() {
    super.initState();
    getLevels();
    if (getLessonsList.isEmpty) isThereadjectives = false;
  }

  Future<void> addAdjective() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO adjectives (adjective, adj_translation, opposite, opp_translation, lesson_id) VALUES 
        (?, ?, ?, ?, ?)
        ''',
          [
            MyFunctions.clearTheText(adjectiveController.text),
            MyFunctions.clearTheText(adjTranslationController.text),
            MyFunctions.clearTheText(oppositeController.text),
            MyFunctions.clearTheText(oppTranslationController.text),
            int.parse(getLessonSelected),
          ],
        );
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
      await AwesomeDialog(
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
        title: Text(MyText.addAdjective),
        centerTitle: true,
      ),
      body: isThereadjectives && getLessonsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereadjectives
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
                  child:
                      Text(MyText.add, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    addAdjective();
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
