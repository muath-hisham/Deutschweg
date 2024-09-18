import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menschen/export-and-import/export.dart';
import 'package:menschen/export-and-import/import.dart';
import 'package:menschen/screens/home_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ImpAndExp extends StatelessWidget {
  ImpAndExp({super.key});

  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.dataOperation),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyWidgets.settingsButtonDesgin(
              title: MyText.export,
              color: Colors.green,
              onPressed: () async {
                await exportData();
              },
            ),
            SizedBox(height: Dimensions.height(50)),
            MyWidgets.settingsButtonDesgin(
              title: MyText.import,
              color: Colors.blue,
              onPressed: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(MyText.import),
                      content: Text(MyText.previousDataWillBeErased),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: Text(MyText.no),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(MyText.yes),
                          onPressed: () async {
                            // Navigator.of(context).pop();
                            await pickData(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            SizedBox(height: Dimensions.height(50)),
            MyWidgets.settingsButtonDesgin(
              title: MyText.deleteData,
              color: Colors.redAccent,
              onPressed: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text(MyText.deleteTheDataBase),
                      content: Text(MyText.fail),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          child: Text(MyText.no),
                          isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text(MyText.yes),
                          onPressed: () async {
                            await sqlDb.deleteDataBase();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomePage(wordsList: [])));
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
