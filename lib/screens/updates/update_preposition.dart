import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/screens/pages/display_preposition.dart';
// import 'package:menschen/screens/pages/display_prepositions.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class PrepositionUpdate extends StatefulWidget {
  final Preposition preposition;
  const PrepositionUpdate({super.key, required this.preposition});

  @override
  State<PrepositionUpdate> createState() => _PrepositionUpdateState();
}

class _PrepositionUpdateState extends State<PrepositionUpdate> {
  final _formKey = GlobalKey<FormState>();
  final prepositionController = TextEditingController();
  final functionController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    prepositionController.text = widget.preposition.preposition;
    functionController.text = widget.preposition.function;
  }

  Future _updatePreposition(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int ins = await sqlDb.updateData(
          "UPDATE prepositions SET preposition = ?, function = ? WHERE preposition_id = ?",
          [
            MyFunctions.clearTheText(prepositionController.text),
            MyFunctions.clearTheText(functionController.text),
            widget.preposition.id
          ],
        );
        List<Map<String, dynamic>> li = await sqlDb.readData(
            "SELECT * FROM prepositions WHERE preposition_id = ${widget.preposition.id}");
        Preposition preposition = Preposition.fromMap(li.first);
        // pop and replasment
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                PrepositionDisplay(preposition: preposition)));
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
          title: Text(MyText.updatePreposition),
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
                border: OutlineInputBorder(), labelText: MyText.preposition),
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
                border: OutlineInputBorder(), labelText: MyText.function),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.update, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _updatePreposition(context);
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
