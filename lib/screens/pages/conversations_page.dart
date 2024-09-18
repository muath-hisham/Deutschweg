import 'package:flutter/material.dart';
import 'package:menschen/models/conversation_model.dart';
import 'package:menschen/screens/adds/add_conversation.dart';
import 'package:menschen/screens/shared/conversation_card.dart';
import 'package:menschen/shared/dimensions.dart';
import 'package:menschen/shared/text.dart';
import 'package:menschen/sqldb.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  SqlDb sqlDb = SqlDb();
  bool isThereConversations = true;
  List<Conversation> conversationsList = [];

  @override
  void initState() {
    super.initState();
    _getConversations();
  }

  Future<void> _getConversations() async {
    List<Map<String, dynamic>> li =
        await sqlDb.readData("SELECT * FROM conversations");

    if (li.isNotEmpty) {
      List<Conversation> featchData = [];
      li.forEach((element) {
        Conversation conversation = Conversation.fromMap(element);
        featchData.add(conversation);
      });
      setState(() {
        conversationsList.clear();
        conversationsList.addAll(featchData);
        print(conversationsList);
      });
    } else {
      setState(() {
        conversationsList.clear();
        isThereConversations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${conversationsList.length} ${MyText.conversations}"),
        centerTitle: true,
      ),
      body: isThereConversations && conversationsList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : !isThereConversations
              ? Center(
                  child: Text(
                  MyText.addConversation,
                  style: TextStyle(fontSize: Dimensions.fontSize(18)),
                ))
              : _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddConversation()));
        },
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.vertical(20)),
      child: ListView.builder(
        itemCount: conversationsList.length + 1,
        itemBuilder: (context, index) {
          if (index < conversationsList.length) {
            return ConversationCard(conversation: conversationsList[index]);
          }
          return SizedBox(height: Dimensions.height(90));
        },
      ),
    );
  }
}
