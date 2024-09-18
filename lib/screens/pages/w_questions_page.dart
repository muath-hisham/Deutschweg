import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/display_w_question.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class WQuestionsPage extends StatefulWidget {
  const WQuestionsPage({super.key});

  @override
  State<WQuestionsPage> createState() => _WQuestionsPageState();
}

class _WQuestionsPageState extends State<WQuestionsPage> {
  SqlDb sqlDb = SqlDb();
  List<String> wQueList = [
    "Wo",
    "Was",
    "Wer",
    "Wie",
    "Wann",
    "Woher",
    "Warum",
    "Wie viel",
    "Wohin",
    "Welche",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${wQueList.length} ${MyText.wQuestions}"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: (wQueList.length / 2)
            .ceil(), // Adjusted the itemCount to divide by 2
        itemBuilder: (context, index) {
          // Calculate the index for the left and right buttons
          int leftIndex = index * 2;
          int rightIndex = leftIndex + 1;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Check if leftIndex is within the range of wQueList
              if (leftIndex < wQueList.length)
                MyWidgets.buttonDesign(
                  wQueList[leftIndex],
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WQuestionDisplay(
                          wQuestion: wQueList[leftIndex],
                        ),
                      ),
                    );
                  },
                ),
              // Check if rightIndex is within the range of wQueList
              if (rightIndex < wQueList.length)
                MyWidgets.buttonDesign(
                  wQueList[rightIndex],
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => WQuestionDisplay(
                          wQuestion: wQueList[rightIndex],
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
