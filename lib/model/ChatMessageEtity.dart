import 'package:hive/hive.dart';

// chat_message.dart
part 'ChatMessageEtity.g.dart';

@HiveType(typeId: 1)
class ChatMessageEtity {
  @HiveField(0)
  String id = "";

  @HiveField(1)
  String from = "";

  @HiveField(2)
  String to = "";

  @HiveField(3)
  String msg = "";

  @HiveField(4)
  DateTime timeSent = DateTime.now();

  @HiveField(5)
  String conversationId= "";

}