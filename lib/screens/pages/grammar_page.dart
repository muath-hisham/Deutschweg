import 'package:flutter/material.dart';
import 'package:menschen/models/grammar_model.dart';
import 'package:menschen/screens/adds/add_grammar.dart';
import 'package:menschen/screens/shared/grammar_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereGrammar = true;
  List<Grammar> grammarList = [];

  @override
  void initState() {
    super.initState();
    _getgrammar();
  }

  Future<void> _getgrammar() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM grammar");

    if (li.isNotEmpty) {
      List<Grammar> featchData = [];
      li.forEach((element) {
        Grammar grammar = Grammar.fromMap(element);
        featchData.add(grammar);
      });
      setState(() {
        grammarList.clear();
        grammarList.addAll(featchData);
        // print(grammarList);
      });
    } else {
      setState(() {
        grammarList.clear();
        isThereGrammar = false;
      });
    }
  }

  // void _search() async {
  //   List<Map<String, dynamic>> dataList =
  //       await sqlDb.readData("SELECT * FROM questions");
  //   showSearch(
  //       context: context, delegate: DataSearch(dataList, Option.));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${grammarList.length} ${MyText.grammar}"),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () {
        //       // _search();
        //     },
        //   ),
        // ],
      ),
      body: isThereGrammar && grammarList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereGrammar
              ? Center(
                  child: Text(
                  MyText.addGrammar,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddGrammar()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: grammarList.length + 1,
        itemBuilder: (context, index) {
          if (index < grammarList.length) {
            return GrammarCard(grammar: grammarList[index]);
          }
          return SizedBox(height: Dimensions.height(90));
        },
      ),
    );
  }
}
