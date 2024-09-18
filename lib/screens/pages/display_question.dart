import 'package:flutter/material.dart';
import 'package:menschen/models/answer_model.dart';
import 'package:menschen/models/formal_question_model.dart';
import 'package:menschen/models/informal_question_model.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/adds/add_answer.dart';
import 'package:menschen/screens/adds/add_formal_question.dart';
import 'package:menschen/screens/adds/add_informal_question.dart';
import 'package:menschen/screens/shared/answer_card.dart';
import 'package:menschen/screens/shared/formal_question_card.dart';
import 'package:menschen/screens/shared/informal_question_card.dart';
import 'package:menschen/screens/updates/update_question.dart';
import 'package:menschen/shared/MyTTSWidgets.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class QuestionDisplay extends StatefulWidget {
  final Question question;
  const QuestionDisplay({super.key, required this.question});

  @override
  State<QuestionDisplay> createState() => _QuestionDisplayState();
}

class _QuestionDisplayState extends State<QuestionDisplay> {
  SqlDb sqlDb = SqlDb();
  bool isThereFormal = true;
  bool isThereInformal = true;
  bool isThereAnswers = true;
  List<Answer> answersList = [];
  List<FormalQuestion> formalList = [];
  List<InformalQuestion> informalList = [];

  @override
  void initState() {
    super.initState();
    _getAnswers();
    _getFormalQu();
    _getInformalQu();
  }

  Future<void> _getFormalQu() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM formal_question WHERE question_id = ${widget.question.id}");

    if (li.isNotEmpty) {
      List<FormalQuestion> featchData = [];
      li.forEach((element) {
        FormalQuestion formalQu = FormalQuestion.fromMap(element);
        featchData.add(formalQu);
      });
      setState(() {
        formalList.clear();
        formalList.addAll(featchData);
        print(formalList);
      });
    } else {
      setState(() {
        formalList.clear();
        isThereFormal = false;
      });
    }
  }

  Future<void> _getInformalQu() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM informal_question WHERE question_id = ${widget.question.id}");

    if (li.isNotEmpty) {
      List<InformalQuestion> featchData = [];
      li.forEach((element) {
        InformalQuestion informalQu = InformalQuestion.fromMap(element);
        featchData.add(informalQu);
      });
      setState(() {
        informalList.clear();
        informalList.addAll(featchData);
        print(informalList);
      });
    } else {
      setState(() {
        informalList.clear();
        isThereInformal = false;
      });
    }
  }

  Future<void> _getAnswers() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM question_answers WHERE question_id = ${widget.question.id}");

    if (li.isNotEmpty) {
      List<Answer> featchData = [];
      li.forEach((element) {
        Answer answer = Answer.fromMap(element);
        featchData.add(answer);
      });
      setState(() {
        answersList.clear();
        answersList.addAll(featchData);
        print(answersList);
      });
    } else {
      setState(() {
        answersList.clear();
        isThereAnswers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.question),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionUpdate(
                question: widget.question,
              ),
            )),
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: Dimensions.vertical(30),
            horizontal: Dimensions.horizontal(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                TTSWidget(
                  audioText: widget.question.question,
                ),
                const SizedBox(width: Dimensions.horizontalSpace),
                Expanded(
                  child: Text(
                    "- ${widget.question.question}",
                    style: TextStyle(fontSize: Dimensions.fontSize(17)),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height(25)),
            Text(
              widget.question.quTranslation,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: Dimensions.fontSize(17)),
            ),
            SizedBox(height: Dimensions.height(25)),
            isThereAnswers && answersList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddAnswer(
                            question: widget.question,
                          ),
                        )),
                      ),
                      Text(
                        MyText.addAnswer,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            !isThereAnswers ? SizedBox() : _answerDisplay(),
            SizedBox(height: Dimensions.height(30)),
            isThereFormal && formalList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddFormalQuestion(
                            question: widget.question,
                          ),
                        )),
                      ),
                      Text(
                        MyText.addFormalQuestion,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            !isThereFormal ? SizedBox() : _formalDisplay(),
            SizedBox(height: Dimensions.height(30)),
            isThereInformal && informalList.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddInformalQuestion(
                            question: widget.question,
                          ),
                        )),
                      ),
                      Text(
                        MyText.addInformalQuestion,
                        style: TextStyle(
                          fontSize: Dimensions.fontSize(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
            !isThereInformal ? SizedBox() : _informalDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _answerDisplay() {
    return Column(
      children: answersList.map((answer) {
        return AnswerCard(
          answer: answer,
          question: widget.question,
        );
      }).toList(),
    );
  }

  Widget _formalDisplay() {
    return Column(
      children: formalList.map((formalQuestion) {
        return FormalQuestionCard(
          formalQuestion: formalQuestion,
          question: widget.question,
        );
      }).toList(),
    );
  }

  Widget _informalDisplay() {
    return Column(
      children: informalList.map((informalQuestion) {
        return InformalQuestionCard(
          informalQuestion: informalQuestion,
          question: widget.question,
        );
      }).toList(),
    );
  }
}
