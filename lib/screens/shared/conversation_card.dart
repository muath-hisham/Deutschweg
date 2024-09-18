import 'package:flutter/material.dart';
import 'package:menschen/models/conversation_model.dart';
import 'package:menschen/screens/pages/conversations_page.dart';
import 'package:menschen/screens/pages/display_conversation.dart';
import 'package:menschen/screens/updates/update_conversation.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/shared/widgets.dart';
import 'package:menschen/sqldb.dart';

class ConversationCard extends StatefulWidget {
  final Conversation conversation;

  const ConversationCard({super.key, required this.conversation});

  @override
  State<ConversationCard> createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return MyWidgets.card(
      onLongPress: () => _showList(context),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              ConversationDisplay(conversation: widget.conversation))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.vertical(12)),
        child: Text(
          _displayName(widget.conversation.conversation),
          style: TextStyle(fontSize: Dimensions.fontSize(15)),
        ),
      ),
    );
  }

  String _displayName(String allName) {
    String name =
        allName.length > 100 ? "${allName.substring(0, 100)} ..." : allName;
    return name;
  }

  void _showList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            MyWidgets.deleteButton(
              context,
              title: MyText.deleteThisConversation,
              accept: () async {
                sqlDb.deleteData(
                    "DELETE FROM conversation WHERE conversation_id = ${widget.conversation.id}");
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ConversationsPage()));
              },
            ),
            MyWidgets.editButton(
              context,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        ConversationUpdate(conversation: widget.conversation)));
              },
            ),
          ],
        );
      },
    );
  }
}
