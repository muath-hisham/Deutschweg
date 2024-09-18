import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/screens/pages/display_preposition.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/screens/pages/sentences_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddPrepositionExample extends StatefulWidget {
  final Preposition preposition;
  const AddPrepositionExample({super.key, required this.preposition});

  @override
  State<AddPrepositionExample> createState() => _AddPrepositionExampleState();
}

class _AddPrepositionExampleState extends State<AddPrepositionExample> {
  final _formKey = GlobalKey<FormState>();
  final exampleController = TextEditingController();
  final translationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addExample() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO preposition_examples (example, translation, preposition_id) VALUES 
        (?, ?, ?)
      ''',
          [
            MyFunctions.clearTheText(exampleController.text),
            MyFunctions.clearTheText(translationController.text),
            widget.preposition.id,
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                PrepositionDisplay(preposition: widget.preposition)));
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
      )..show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.addExample),
        centerTitle: true,
      ),
      body: _body(),
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
                MyWidgets.inputForm(
                  controller: exampleController,
                  label: MyText.example,
                  error: MyText.enterTheExample,
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
                  child:
                      Text(MyText.add, style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    addExample();
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
