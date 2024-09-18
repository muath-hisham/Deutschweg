import 'package:flutter/material.dart';
import 'package:menschen/models/color_model.dart';
import 'package:menschen/screens/adds/add_color.dart';
import 'package:menschen/screens/shared/color_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/enum.dart';
import 'package:menschen/shared/search_controller.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';
import 'package:menschen/models/preposition_model.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereColors = true;
  List<MyColor> colorsList = [];

  @override
  void initState() {
    super.initState();
    _getColors();
  }

  Future<void> _getColors() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM colors");

    if (li.isNotEmpty) {
      List<MyColor> featchData = [];
      li.forEach((element) {
        MyColor color = MyColor.fromMap(element);
        featchData.add(color);
      });
      setState(() {
        colorsList.clear();
        colorsList.addAll(featchData);
        print(colorsList);
      });
    } else {
      setState(() {
        colorsList.clear();
        isThereColors = false;
      });
    }
  }

  void _search() async {
    List<Map<String, dynamic>> dataList =
        await sqlDb.readData("SELECT * FROM colors");
    showSearch(context: context, delegate: DataSearch(dataList, Option.color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${colorsList.length} ${MyText.colors}"),
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
      body: isThereColors && colorsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereColors
              ? Center(
                  child: Text(
                  MyText.addColor,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddColor()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: colorsList.length + 1,
        itemBuilder: (context, index) {
          if (index < colorsList.length) {
            return ColorCard(color: colorsList[index]);
          }
          return SizedBox(height: Dimensions.height(90));
        },
      ),
    );
  }
}
