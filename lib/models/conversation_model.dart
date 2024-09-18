class Conversation {
  late int id;
  late String conversation;

  Conversation.fromMap(Map<String, dynamic> map) {
    id = map['conversation_id'];
    conversation = map['conversation'].toString().trim();
  }

  Map<String, dynamic> toMap() {
    return {
      'conversation_id': id,
      'conversation': conversation,
    };
  }
}
