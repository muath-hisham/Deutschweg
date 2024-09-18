import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class AddPreposition extends StatefulWidget {
  const AddPreposition({super.key});

  @override
  State<AddPreposition> createState() => _AddPrepositionState();
}

class _AddPrepositionState extends State<AddPreposition> {
  final _formKey = GlobalKey<FormState>();
  final prepositionController = TextEditingController();
  final functionController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addPreposition() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO prepositions (preposition, function) VALUES (?, ?)
      ''',
          [
            MyFunctions.clearTheText(prepositionController.text),
            MyFunctions.clearTheText(functionController.text),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PrepositionsPage()));
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
          title: Text(MyText.addPrepositions),
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
                    TextFormField(
                      controller: prepositionController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return MyText.enterThePreposition;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: MyText.preposition,
                      ),
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    TextFormField(
                      controller: functionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 6,
                      textDirection: TextDirection.rtl,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return MyText.enterTheFunction;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: MyText.function,
                      ),
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(MyText.addPrepositions,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        addPreposition();
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
