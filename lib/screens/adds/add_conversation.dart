import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/screens/pages/conversations_page.dart';
import 'package:menschen/screens/pages/grammar_page.dart';
import 'package:menschen/screens/pages/prepositions_page.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class AddConversation extends StatefulWidget {
  const AddConversation({super.key});

  @override
  State<AddConversation> createState() => _AddConversationState();
}

class _AddConversationState extends State<AddConversation> {
  final _formKey = GlobalKey<FormState>();
  final conversationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  Future addConversation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int i = await sqlDb.insertData(
          '''
        INSERT INTO conversations (conversation) VALUES (?)
      ''',
          [
            MyFunctions.clearTheText(conversationController.text),
          ],
        );
        // print(await sqlDb.readData("SELECT * FROM levels"));
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ConversationsPage()));
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
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.addConversation),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimensions.horizontal(50),
              vertical: Dimensions.vertical(50),
            ),
            child: _form(),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: conversationController,
            keyboardType: TextInputType.multiline,
            maxLines: 12,
            textDirection: TextDirection.ltr,
            textInputAction: TextInputAction.newline,
            validator: (value) {
              if (value!.isEmpty) {
                return MyText.enterTheConversation;
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: MyText.conversation,
            ),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.addConversation,
                style: TextStyle(color: Colors.white)),
            onPressed: () async {
              addConversation();
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
