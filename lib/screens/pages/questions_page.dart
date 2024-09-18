import 'package:flutter/material.dart';
import 'package:menschen/models/question_model.dart';
import 'package:menschen/screens/adds/add_question.dart';
import 'package:menschen/screens/shared/question_card.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereQuestions = true;
  List<Question> questionsList = [];

  @override
  void initState() {
    super.initState();
    getLevels();
    _getquestions();
  }

  Future<void> _getquestions() async {
    List<Map<String, dynamic>> li = [];
    if (isAllChecked) {
      li = await sqlDb.readData("SELECT * FROM questions");
    } else {
      li = await sqlDb.readData(
          "SELECT * FROM questions WHERE lesson_id = $getLessonSelected");
    }

    if (li.isNotEmpty) {
      List<Question> featchData = [];
      li.forEach((element) {
        Question question = Question.fromMap(element);
        featchData.add(question);
      });
      setState(() {
        questionsList.clear();
        questionsList.addAll(featchData);
        print(questionsList);
      });
    } else {
      setState(() {
        questionsList.clear();
        isThereQuestions = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM questions");
    showSearch(
        context: context, delegate: DataSearch(dataList, Option.question));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${questionsList.length} ${MyText.questions}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _search();
            },
          ),
        ],
      ),
      body:
          isThereQuestions && (questionsList.isEmpty || getLessonsList.isEmpty)
              ? Center(child: CircularProgressIndicator())
              : getLessonsList.isEmpty && !isThereQuestions
                  ? Center(
                      child: Text(
                      MyText.addLessons,
                      style: TextStyle(fontSize: Dimensions.fontSize(18)),
                    ))
                  : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddQuestion()));
        },
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        controlsDesignToViewPages(() {
          setState(() {
            _getquestions();
          });
        }),
        questionsList.isEmpty && !isThereQuestions
            ? SizedBox(
                height: Dimensions.height(400),
                child: Center(
                    child: Text(
                  MyText.addQuestions,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                )),
              )
            : Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.vertical(20)),
                  child: ListView.builder(
                    itemCount: questionsList.length + 1,
                    itemBuilder: (context, index) {
                      if (index < questionsList.length) {
                        return QuestionCard(question: questionsList[index]);
                      }
                      return SizedBox(height: Dimensions.height(90));
                    },
                  ),
                ),
              ),
      ],
    );
  }
}
