import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/display_lessons.dart';
import 'package:menschen/shared/controlling.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class AddLesson extends StatefulWidget {
  const AddLesson({super.key});

  @override
  State<AddLesson> createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  final _formKey = GlobalKey<FormState>();
  final lessonController = TextEditingController();
  late String _levelSelected;
  List<Map> levels = [];
  bool isThereLevels = true;
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    _getLevels();
  }

  Future<void> _getLevels() async {
    List<Map> li = await sqlDb.readData("SELECT * FROM levels");
    if (li.isEmpty) {
      setState(() {
        isThereLevels = false;
      });
      return;
    }
    setState(() {
      levels = li;
      _levelSelected = levels[0]['level_id'].toString();
    });
  }

  Future addLesson() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO lessons (level_id, lesson) VALUES (?, ?)
      ''',
          [
            int.parse(_levelSelected),
            MyFunctions.clearTheText(lessonController.text),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM lessons"));
        emptyLessonList();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LessonsDisplay()));
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
          title: const Text(MyText.addLessons),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
              child: isThereLevels && levels.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : !isThereLevels
                      ? Center(
                          child: Text(
                          MyText.addLevels,
                          style: TextStyle(fontSize: Dimensions.fontSize(18)),
                        ))
                      : _form(),
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
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    MyText.level,
                    style: TextStyle(
                      fontSize: Dimensions.fontSize(15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.horizontal(10)),
                  margin: EdgeInsets.all(Dimensions.horizontal(10)),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black, width: 0.6), // Add border
                    borderRadius: BorderRadius.circular(5), // Set border radius
                  ),
                  child: DropdownButton<String>(
                    value: _levelSelected,
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _levelSelected = newValue!;
                      });
                    },
                    items: levels.map((map) {
                      return DropdownMenuItem<String>(
                        value: map['level_id']!.toString(),
                        child: Text(map['level']!), // Display the name
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height(25)),
          TextFormField(
            controller: lessonController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return MyText.enterTheLesson;
              }
              return null;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: MyText.lesson),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child:
                Text(MyText.addLessons, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              addLesson();
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
