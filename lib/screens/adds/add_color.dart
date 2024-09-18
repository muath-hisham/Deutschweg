import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/colors_page.dart';
import 'package:menschen/screens/pages/grammar_page.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddColor extends StatefulWidget {
  const AddColor({super.key});

  @override
  State<AddColor> createState() => _AddColorState();
}

class _AddColorState extends State<AddColor> {
  final _formKey = GlobalKey<FormState>();
  final colorController = TextEditingController();
  final translationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addColor() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO colors (color, translation) VALUES (?, ?)
      ''',
          [
            MyFunctions.clearTheText(colorController.text),
            MyFunctions.clearTheText(translationController.text),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ColorsPage()));
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
          title: Text(MyText.addColor),
          centerTitle: true,
        ),
        body: Center(
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
                      controller: colorController,
                      label: MyText.color,
                      error: MyText.enterTheColor,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(MyText.addColor,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        addColor();
                      },
                    ),
                    SizedBox(height: Dimensions.height(25)),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
