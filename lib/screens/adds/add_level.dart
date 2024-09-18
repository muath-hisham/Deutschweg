import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/display_levels.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class AddLevel extends StatefulWidget {
  const AddLevel({super.key});

  @override
  State<AddLevel> createState() => _AddLevelState();
}

class _AddLevelState extends State<AddLevel> {
  final _formKey = GlobalKey<FormState>();
  final levelController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addLevel() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO levels (level) VALUES (?)
      ''',
          [
            MyFunctions.clearTheText(levelController.text),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LevelsDisplay()));
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
          title: Text(MyText.addLevels),
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
                      controller: levelController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return MyText.enterTheLevel;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: MyText.level,
                      ),
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(MyText.addLevels,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        addLevel();
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
