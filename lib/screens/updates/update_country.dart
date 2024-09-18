import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/country_model.dart';
import 'package:menschen/screens/pages/countries_page.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class CountryUpdate extends StatefulWidget {
  final Country country;
  const CountryUpdate({super.key, required this.country});

  @override
  State<CountryUpdate> createState() => _CountryUpdateState();
}

class _CountryUpdateState extends State<CountryUpdate> {
  final _formKey = GlobalKey<FormState>();
  final countryController = TextEditingController();
  // final articalController = TextEditingController();
  final translationController = TextEditingController();
  final nationalityController = TextEditingController();
  final languageController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  String _selectedArticle = "";

  @override
  void initState() {
    super.initState();
    countryController.text = widget.country.country;
    translationController.text = widget.country.translation;
    if (widget.country.article!.trim() != "" &&
        widget.country.article != null) {
      _selectedArticle = widget.country.article!;
    }
    if (widget.country.nationality!.trim() != "" &&
        widget.country.nationality != null) {
      nationalityController.text = widget.country.nationality!;
    }
    if (widget.country.language!.trim() != "" &&
        widget.country.language != null) {
      languageController.text = widget.country.language!;
    }
  }

  Future _updateCountry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.updateData(
          '''
        UPDATE countries SET country = ?, article = ?, translation = ?, nationality = ?, language = ? WHERE country_id = ?''',
          [
            MyFunctions.clearTheText(countryController.text),
            MyFunctions.clearTheText(_selectedArticle),
            MyFunctions.clearTheText(translationController.text),
            MyFunctions.clearTheText(nationalityController.text),
            MyFunctions.clearTheText(languageController.text),
            widget.country.id
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CountriesPage()));
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
        title: Text(MyText.updateCountry),
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
                  controller: countryController,
                  label: MyText.country,
                  error: MyText.enterTheCountry,
                ),
                SizedBox(height: Dimensions.height(25)),
                Row(
                  children: [
                    _articleDesign("die"),
                    SizedBox(width: Dimensions.width(10)),
                    _articleDesign("der"),
                    SizedBox(width: Dimensions.width(10)),
                    _articleDesign("das"),
                  ],
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormToArabic(
                  controller: translationController,
                  label: MyText.translation,
                  error: MyText.enterTheTranslation,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: nationalityController,
                  label: MyText.nationality,
                ),
                SizedBox(height: Dimensions.height(25)),
                MyWidgets.inputFormOptional(
                  controller: languageController,
                  label: MyText.language,
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
                    _updateCountry();
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

  Widget _articleDesign(String title) {
    bool isSelected = _selectedArticle == title;
    Color color = isSelected ? mainColor : Colors.white;
    Color textColor = isSelected ? Colors.white : Colors.black;

    return Expanded(
      child: SizedBox(
        height: Dimensions.height(48),
        child: ElevatedButton(
          onPressed: () async {
            if (_selectedArticle == title) {
              setState(() {
                _selectedArticle = "";
              });
            } else {
              setState(() {
                _selectedArticle = title;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            backgroundColor: color,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
