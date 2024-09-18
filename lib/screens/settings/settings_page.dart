import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/display_lessons.dart';
import 'package:menschen/screens/pages/display_levels.dart';
import 'package:menschen/screens/pages/imp_and_exp.dart';
import 'package:menschen/shared/BottomBar.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.settings),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomBar(active: "settings"),
      body: WillPopScope(
        onWillPop: () async {
          bool shouldExit = await MyWidgets.showExitConfirmationDialog(context);
          return shouldExit;
        },
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyWidgets.settingsButtonDesgin(
            title: MyText.level,
            color: Colors.green,
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LevelsDisplay()));
            },
          ),
          SizedBox(height: Dimensions.height(50)),
          MyWidgets.settingsButtonDesgin(
            title: MyText.lessons,
            color: Colors.blue,
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LessonsDisplay()));
            },
          ),
          SizedBox(height: Dimensions.height(50)),
          MyWidgets.settingsButtonDesgin(
            title: MyText.importAndExport,
            color: Colors.redAccent,
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ImpAndExp()));
            },
          )
        ],
      ),
    );
  }
}
