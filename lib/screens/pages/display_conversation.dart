import 'package:flutter/material.dart';
import 'package:menschen/models/conversation_model.dart';
import 'package:menschen/screens/updates/update_conversation.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class ConversationDisplay extends StatefulWidget {
  final Conversation conversation;
  const ConversationDisplay({super.key, required this.conversation});

  @override
  State<ConversationDisplay> createState() => _ConversationDisplayState();
}

class _ConversationDisplayState extends State<ConversationDisplay> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyText.conversation),
        centerTitle: true,
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ConversationUpdate(conversation: widget.conversation)));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.vertical(30),
      ),
      child: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.horizontal(20),
        ),
        child: Text(
          widget.conversation.conversation,
          style: TextStyle(
            fontSize: Dimensions.fontSize(16),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
