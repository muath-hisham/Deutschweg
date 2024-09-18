import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/color_model.dart';
import 'package:menschen/screens/pages/colors_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ColorUpdate extends StatefulWidget {
  final MyColor color;
  const ColorUpdate({super.key, required this.color});

  @override
  State<ColorUpdate> createState() => _ColorUpdateState();
}

class _ColorUpdateState extends State<ColorUpdate> {
  final _formKey = GlobalKey<FormState>();
  final colorController = TextEditingController();
  final translationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    colorController.text = widget.color.color;
    translationController.text = widget.color.translation;
  }

  Future _updateColor(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int ins = await sqlDb.updateData(
          "UPDATE colors SET color = ?, translation = ? WHERE color_id = ?",
          [
            MyFunctions.clearTheText(colorController.text),
            MyFunctions.clearTheText(translationController.text),
            widget.color.id
          ],
        );
        // pop and replasment
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ColorsPage()));
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
          title: Text(MyText.updateColor),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.update, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _updateColor(context);
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
