import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:menschen/models/conversation_model.dart';
import 'package:menschen/screens/pages/display_conversation.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/functions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ConversationUpdate extends StatefulWidget {
  final Conversation conversation;
  const ConversationUpdate({super.key, required this.conversation});

  @override
  State<ConversationUpdate> createState() => _ConversationUpdateState();
}

class _ConversationUpdateState extends State<ConversationUpdate> {
  final _formKey = GlobalKey<FormState>();
  final conversationController = TextEditingController();
  SqlDb sqlDb = SqlDb();

  @override
  void initState() {
    super.initState();
    conversationController.text = widget.conversation.conversation;
  }

  Future _updateConversation(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        int ins = await sqlDb.updateData(
          "UPDATE conversations SET conversation = ? WHERE conversation_id = ?",
          [
            MyFunctions.clearTheText(conversationController.text),
            widget.conversation.id
          ],
        );
        List<Map<String, dynamic>> li = await sqlDb.readData(
            "SELECT * FROM conversations WHERE conversation_id = ${widget.conversation.id}");
        Conversation conversation = Conversation.fromMap(li.first);
        // pop and replasment
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ConversationDisplay(conversation: conversation)));
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
          title: Text(MyText.updateConversation),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: Dimensions.horizontal(50)),
              child: _form(),
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
                border: OutlineInputBorder(), labelText: MyText.conversation),
          ),
          SizedBox(height: Dimensions.height(25)),
          MaterialButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(MyText.update, style: TextStyle(color: Colors.white)),
            onPressed: () async {
              _updateConversation(context);
            },
          ),
          SizedBox(height: Dimensions.height(25)),
        ],
      ),
    );
  }
}
