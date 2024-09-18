import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/screens/pages/display_grammar.dart';
import 'package:menschen/screens/pages/grammar_page.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddGrammar extends StatefulWidget {
  const AddGrammar({super.key});

  @override
  State<AddGrammar> createState() => _AddGrammarState();
}

class _AddGrammarState extends State<AddGrammar> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final grammarController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addGrammar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO grammar (name, grammar) VALUES (?, ?)
      ''',
          [
            MyFunctions.clearTheText(nameController.text),
            MyFunctions.clearTheText(grammarController.text),
          ],
        );
        List li =
            await sqlDb.readData("SELECT * FROM grammar WHERE grammar_id = $i");
        Grammar grammar = Grammar.fromMap(li.first);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => GrammarDisplay(grammar: grammar)));
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
          title: Text(MyText.addGrammar),
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
                      controller: nameController,
                      label: MyText.name,
                      error: MyText.enterTheName,
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    TextFormField(
                      controller: grammarController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      textDirection: TextDirection.rtl,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: MyText.grammar,
                      ),
                    ),
                    SizedBox(height: Dimensions.height(25)),
                    MaterialButton(
                      color: Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(MyText.addGrammar,
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        addGrammar();
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
