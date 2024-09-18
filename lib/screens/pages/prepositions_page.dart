import 'package:flutter/material.dart';
import 'package:menschen/screens/adds/add_preposition.dart';
import 'package:menschen/screens/shared/preposition_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';
import 'package:menschen/models/preposition_model.dart';

class PrepositionsPage extends StatefulWidget {
  const PrepositionsPage({super.key});

  @override
  State<PrepositionsPage> createState() => _PrepositionsPageState();
}

class _PrepositionsPageState extends State<PrepositionsPage> {
  SqlDb sqlDb = SqlDb();
  bool isTherePrepositions = true;
  List<Preposition> prepositionsList = [];

  @override
  void initState() {
    super.initState();
    _getprepositions();
  }

  Future<void> _getprepositions() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM prepositions");

    if (li.isNotEmpty) {
      List<Preposition> featchData = [];
      li.forEach((element) {
        Preposition preposition = Preposition.fromMap(element);
        featchData.add(preposition);
      });
      setState(() {
        prepositionsList.clear();
        prepositionsList.addAll(featchData);
        print(prepositionsList);
      });
    } else {
      setState(() {
        prepositionsList.clear();
        isTherePrepositions = false;
      });
    }
  }

  // void _search() async {
  //   List<Map<String, dynamic>> dataList =
  //       await sqlDb.readData("SELECT * FROM questions");
  //   showSearch(
  //       context: context, delegate: DataSearch(dataList, Option.preposition));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${prepositionsList.length} ${MyText.prepositions}"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       _search();
        //     },
        //   ),
        // ],
      ),
      body: isTherePrepositions && prepositionsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isTherePrepositions
              ? Center(
                  child: Text(
                  MyText.addPrepositions,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddPreposition()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: prepositionsList.length + 1,
        itemBuilder: (context, index) {
          if (index < prepositionsList.length) {
            return PrepositionCard(preposition: prepositionsList[index]);
          }
          return SizedBox(height: Dimensions.height(90));
        },
      ),
    );
  }
}
