import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_example_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/adds/add_preposition_example.dart';
import 'package:menschen/screens/shared/preposition_example_card.dart';
import 'package:menschen/screens/shared/question_card.dart';
import 'package:menschen/screens/updates/update_preposition.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class WQuestionDisplay extends StatefulWidget {
  final String wQuestion;
  const WQuestionDisplay({super.key, required this.wQuestion});

  @override
  State<WQuestionDisplay> createState() => _WQuestionDisplayState();
}

class _WQuestionDisplayState extends State<WQuestionDisplay> {
  SqlDb sqlDb = SqlDb();
  bool isThereExamples = true;
  List<Question> examplesList = [];

  @override
  void initState() {
    super.initState();
    _getExamples();
  }

  Future<void> _getExamples() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        'SELECT * FROM questions WHERE question LIKE "${widget.wQuestion} %"');

    if (li.isNotEmpty) {
      List<Question> featchData = [];
      li.forEach((element) {
        Question example = Question.fromMap(element);
        featchData.add(example);
      });
      setState(() {
        examplesList.clear();
        examplesList.addAll(featchData);
        print(examplesList);
      });
    } else {
      setState(() {
        examplesList.clear();
        isThereExamples = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wQuestion),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(30),
      ),
      child: isThereExamples && examplesList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereExamples
              ? Center(
                  child: Text(
                  MyText.noExamples,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _examplesDisplay(),
    );
  }

  Widget _examplesDisplay() {
    return Expanded(
      child: ListView.builder(
        itemCount: examplesList.length,
        itemBuilder: (context, index) {
          return QuestionCard(
            question: examplesList[index],
          );
        },
      ),
    );
  }
}
