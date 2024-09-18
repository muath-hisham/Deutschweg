import 'package:flutter/material.dart';
import 'package:menschen/models/preposition_example_model.dart';
import 'package:menschen/models/preposition_model.dart';
import 'package:menschen/screens/adds/add_preposition_example.dart';
import 'package:menschen/screens/shared/preposition_example_card.dart';
import 'package:menschen/screens/updates/update_preposition.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class PrepositionDisplay extends StatefulWidget {
  final Preposition preposition;
  const PrepositionDisplay({super.key, required this.preposition});

  @override
  State<PrepositionDisplay> createState() => _PrepositionDisplayState();
}

class _PrepositionDisplayState extends State<PrepositionDisplay> {
  SqlDb sqlDb = SqlDb();
  bool isThereExamples = true;
  List<PrepositionExample> examplesList = [];

  @override
  void initState() {
    super.initState();
    _getExamples();
  }

  Future<void> _getExamples() async {
    List<Map<String, dynamic>> li = await sqlDb.readData(
        "SELECT * FROM preposition_examples WHERE preposition_id = ${widget.preposition.id}");

    if (li.isNotEmpty) {
      List<PrepositionExample> featchData = [];
      li.forEach((element) {
        PrepositionExample example = PrepositionExample.fromMap(element);
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
        title: Text(widget.preposition.preposition),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                ),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PrepositionUpdate(preposition: widget.preposition),
                  ),
                ),
              ),
              Text(
                MyText.function,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height(10)),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.horizontal(20),
            ),
            child: Text(
              widget.preposition.function,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: Dimensions.fontSize(15),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.blueAccent,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddPrepositionExample(preposition: widget.preposition),
                )),
              ),
              Text(
                MyText.examples,
                style: TextStyle(
                  fontSize: Dimensions.fontSize(17),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.height(15)),
          isThereExamples && examplesList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : !isThereExamples
                  ? Center(
                      child: Text(
                      MyText.addExamples,
                      style: TextStyle(fontSize: Dimensions.fontSize(18)),
                    ))
                  : _examplesDisplay(),
        ],
      ),
    );
  }

  Widget _examplesDisplay() {
    return Expanded(
      child: ListView.builder(
        itemCount: examplesList.length,
        itemBuilder: (context, index) {
          return PrepositionExampleCard(
            prepositionExample: examplesList[index],
            preposition: widget.preposition,
          );
        },
      ),
    );
  }
}
