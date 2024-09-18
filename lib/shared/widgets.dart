import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/sentence_mode.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:clipboard/clipboard.dart';
import 'package:menschen/shared/shared.dart';
import 'package:menschen/shared/text.dart';

class MyWidgets {
  static Widget inputForm({
    required TextEditingController controller,
    required String label,
    required String error,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return error;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  static Widget inputFormToArabic({
    required TextEditingController controller,
    required String label,
    required String error,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      textAlign: TextAlign.right,
      validator: (value) {
        if (value!.isEmpty) {
          return error;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
    );
  }

  static Widget inputFormToArabicOptional({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "$label  (Optional)",
      ),
    );
  }

  static Widget inputFormOptional({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "$label (Optional)",
      ),
    );
  }

  static Widget deleteButton(context,
      {required String title, required Function() accept}) {
    return ListTile(
      leading: Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
      title: Text(MyText.delete),
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title),
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
                  onPressed: accept,
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Widget editButton(context, {required Function() onTap}) {
    return ListTile(
      leading: const Icon(
        Icons.edit,
        color: Colors.blueAccent,
      ),
      title: Text(MyText.edit),
      onTap: onTap,
    );
  }

  static Widget copyTextButton(context, String text, String title) {
    return ListTile(
      leading: const Icon(
        Icons.copy,
        color: Colors.grey,
      ),
      title: Text(title),
      onTap: () async {
        await FlutterClipboard.copy(text);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(MyText.copiedSuccessfully)));
      },
    );
  }

  static Widget card({
    required Widget child,
    void Function()? onLongPress,
    void Function()? onTap,
  }) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          right: Dimensions.horizontal(15),
          left: Dimensions.horizontal(10),
          top: Dimensions.vertical(5),
          bottom: Dimensions.vertical(5),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(10),
          vertical: Dimensions.vertical(4),
        ),
        decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 10, // Blur radius
              offset: Offset(0, 1), // Offset from the top-left corner
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  static Widget buttonDesign(String text, Function() onTap) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.vertical(10),
          horizontal: Dimensions.horizontal(10)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: Dimensions.width(140),
          height: Dimensions.height(100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: mainColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.fontSize(15),
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  static Widget settingsButtonDesgin({
    required String title,
    required Color color,
    required Function() onPressed,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      child: Container(
        height: Dimensions.height(50),
        width: Dimensions.width(150),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.white, fontSize: Dimensions.fontSize(16)),
        ),
      ),
    );
  }

  static Future<bool> showExitConfirmationDialog(BuildContext context) async {
    bool exitConfirmed = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(MyText.confirmCheckout),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(MyText.confirmExitMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                MyText.no,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
                exitConfirmed = false;
              },
            ),
            TextButton(
              child: Text(
                MyText.yes,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق الحوار
                exitConfirmed = true;
              },
            ),
          ],
        );
      },
    );
    return exitConfirmed;
  }

  static Widget questionsButton(Function() onPressed,
      {bool isNext = false, bool caseImplemented = true}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: caseImplemented ? onPressed : null,
        child: Text(isNext ? MyText.next : MyText.check),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            caseImplemented ? mainColor : Colors.white,
          ),
          minimumSize: MaterialStateProperty.all(
            Size(double.infinity, Dimensions.height(50)),
          ),
          textStyle: MaterialStateProperty.all(
            TextStyle(fontSize: Dimensions.fontSize(18)),
          ),
          side: caseImplemented
              ? null
              : MaterialStateProperty.all(
                  BorderSide(
                    color: Colors.blueGrey,
                    width: 0.7,
                  ),
                ),
        ),
      ),
    );
  }
}
