import 'dart:async';
import 'package:chatgpt_app/Suggestions.dart';

import 'model/ChatMessageEtity.dart';
import 'api_Services.dart';
import 'ChatConversationRepository.dart';
import 'model/ChatconversationEtity.dart';
import 'package:uuid/uuid.dart';

class ChatServices{
  static final ChatConversationRepository _Repository = ChatConversationRepository();
  static final StreamController<ChatConversation> _chatConversationController =
  StreamController<ChatConversation>.broadcast();
  static Stream<ChatConversation> get streamChatConversation =>
      _chatConversationController.stream;
  static List<ChatConversation> histories=[];
  static ChatConversation? currentChatConversation;

  static Future<void> initHive() async {
    await _Repository.init();
    var allConversationEntities = _Repository.getAllConversations();
    var allConversations = allConversationEntities.map((conversationEntity) {
      var conversation = ChatConversation();
      conversation.id = conversationEntity.id;
      conversation.Status = conversationEntity.status;
      conversation.suggestName= conversationEntity.suggestName;

      conversation.messages=[];
      conversation.messages = _Repository.getMessagesByConversationId(conversation.id).map((messageEntity) {
        var message = ChatMessage();
        message.id = messageEntity.id;
        message.from = messageEntity.from;
        message.to = messageEntity.to;
        message.msg = messageEntity.msg;
        message.timeSent = messageEntity.timeSent;
        return message;
      }).toList();
      return conversation;
    }).toList();

    histories = [];
    histories = allConversations;

  }

  static var _uuidGen=Uuid();

  static String GenerateId(){
      return _uuidGen.v4();
  }
  static void historyDoselectConversition(String id){
  currentChatConversation= histories.where((element) =>element.id==id).first;
  _chatConversationController.add(currentChatConversation!);
}

  static  ChatConversation createConversataion(){
    var chatconversation= ChatConversation();
    chatconversation.id= GenerateId();
    chatconversation.messages=[];
    histories.add(chatconversation);
    _chatConversationController.add(chatconversation);

    var conversationEtity= ChatconversationEtity();
    conversationEtity.id=chatconversation.id;
    conversationEtity.status=chatconversation.Status;
    conversationEtity.title= chatconversation.title;
    conversationEtity.suggestName= chatconversation.suggestName;
    _Repository.addOrUpdateConversation(conversationEtity);

    return chatconversation;
  }

  static Future<void> updateConversation( ChatConversation chatconversation) async
  {
    var conversationEtity= ChatconversationEtity();
    conversationEtity.id=chatconversation.id;
    conversationEtity.status=chatconversation.Status;
    conversationEtity.title= chatconversation.title;
    conversationEtity.suggestName= chatconversation.suggestName;
   await _Repository.addOrUpdateConversation(conversationEtity);
  }
  static  void closeConversation(String id){
    var toRem= tryGetConversation(id);
    toRem.Status=2;
  }
  static  void deleteConversation(String id){
    var toRem= tryGetConversation(id);
    histories.remove(toRem);
    _Repository.deleteConversation(id);
    histories.removeWhere((conversation) => conversation.id == id);
    if (currentChatConversation != null && currentChatConversation!.id == id) {
      // Trả về trang mới
      currentChatConversation = createConversataion();
    }

    _chatConversationController.add(currentChatConversation!);
  }
  static  ChatConversation tryGetConversation(String id){
      return  histories.firstWhere((e)=>e.id==id);
  }
  static Future<void> trySendChatMsg(String from, String to,String question)
  async {
    currentChatConversation ??= createConversataion();
    var msg = ChatMessage();
    msg.id = GenerateId();
     msg.from= from;
     msg.to='gpt';
     msg.msg= question;
     msg.timeSent=DateTime.now();
     currentChatConversation!.messages.add(msg);
     //
    var chatmesageEtity = ChatMessageEtity();
    chatmesageEtity.conversationId = currentChatConversation!.id;
    chatmesageEtity.id= msg.id;
    chatmesageEtity.from = msg.from ;
    chatmesageEtity.to = msg.to ;
    chatmesageEtity.msg= msg.msg;
    chatmesageEtity.timeSent= msg.timeSent;
    _Repository.addChatmessage(chatmesageEtity);
     //chat gpt
    var templateRequest= ChatGptRequestSuggestions.getSuggestionAndBuildApiRequest(currentChatConversation!.suggestName, question);
    Map<String, dynamic> apiResponse = await ApiServices.sendChatRequest(
        templateRequest);
     String replyMessage= apiResponse['choices'][0]['message']['content'];
    var msgGpt = ChatMessage();
    msgGpt.id= GenerateId();
    msgGpt.from= 'gpt';
    msgGpt.to=from;
    msgGpt.msg= replyMessage;
    msgGpt.timeSent=DateTime.now();
    currentChatConversation!.messages.add(msgGpt);

    var chatmesageGptEtity = ChatMessageEtity();
    chatmesageGptEtity.conversationId = currentChatConversation!.id;
    chatmesageGptEtity.id= msgGpt.id;
    chatmesageGptEtity.from = msgGpt.from ;
    chatmesageGptEtity.to = msgGpt.to ;
    chatmesageGptEtity.msg= msgGpt.msg;
    chatmesageGptEtity.timeSent= msgGpt.timeSent;
    _Repository.addChatmessage(chatmesageGptEtity);
      }
    }
class ChatConversation{
  String id="";
  List<ChatMessage> messages=[];
  int Status = 0;//0: moi, 1: dang chat, 2: dong(close)
  String get title=> messages.isEmpty?id: messages.first.msg;
  String suggestName="";
}
class ChatMessage{
  String id= "";
  String from="";
  String to="";
  String msg="";
  DateTime timeSent= DateTime.now();
  bool liked = false;
  bool disliked = false;
}







