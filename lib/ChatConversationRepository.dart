import 'package:hive/hive.dart';
import 'model/ChatMessageEtity.dart';
import 'model/ChatconversationEtity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatConversationRepository{
  Box<ChatconversationEtity>? _conversationBox;
  Box<ChatMessageEtity>?_chatmessageBox;
  Future<void> init() async{
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatconversationEtityAdapter());
      Hive.registerAdapter(ChatMessageEtityAdapter());
    }
      _conversationBox = await Hive.openBox<ChatconversationEtity>('ChatConversation');
    _chatmessageBox = await Hive.openBox<ChatMessageEtity>('ChatMessage');
  }
  Future<void> addOrUpdateConversation(ChatconversationEtity conversation) async{
    await _conversationBox!.put(conversation.id,conversation);
  }
  Future<void> deleteConversation(String id) async{
    await _conversationBox!.delete(id);
  }
  List<ChatconversationEtity> getAllConversations() {
    return _conversationBox!.values.toList();
  }
  Future<void> addChatmessage(ChatMessageEtity message) async{
    await _chatmessageBox!.put(message.id,message);
  }
  Future<void> deleteChatmessage(String id) async{
    await _chatmessageBox!.delete(id);
  }
  List<ChatMessageEtity> getAllMessage() {
    return _chatmessageBox!.values.toList();
  }
  List<ChatMessageEtity>getMessagesByConversationId(String id){
    var temb = _chatmessageBox!.values.where((element) => element.conversationId==id).toList();
    temb.sort((a, b) => a.timeSent.compareTo(b.timeSent));
    return temb;
  }
}
