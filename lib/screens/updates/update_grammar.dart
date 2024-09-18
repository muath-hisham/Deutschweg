import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/screens/pages/display_grammar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class GrammarUpdate extends StatefulWidget {
  final Grammar grammar;
  const GrammarUpdate({super.key, required this.grammar});

  @override
  State<GrammarUpdate> createState() => _GrammarUpdateState();
}

class _GrammarUpdateState extends State<GrammarUpdate> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final grammarController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.grammar.name;
    grammarController.text = widget.grammar.grammar;
  }

  Future _updateGrammar(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int ins = await sqlDb.updateData(
          "UPDATE grammar SET name = ?, grammar = ? WHERE grammar_id = ?",
          [
            MyFunctions.clearTheText(nameController.text),
            MyFunctions.clearTheText(grammarController.text),
            widget.grammar.id
          ],
        );
        List<Map<String, dynamic>> li = await sqlDb.readData(
            "SELECT * FROM grammar WHERE grammar_id = ${widget.grammar.id}");
        Grammar grammar = Grammar.fromMap(li.first);
        // pop and replasment
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
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
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(MyText.updateGrammar),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
              child: _form(),
            ),
          ),
        ));
  }

  Widget _form() {
    return Form(
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
                border: OutlineInputBorder(), labelText: MyText.grammar),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.update, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _updateGrammar(context);
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
