import 'dart:async';
import 'package:chatgpt_app/Suggestions.dart';
import 'package:file_picker/file_picker.dart';
import 'model/UserEtity.dart';
import 'model/ChatMessageEtity.dart';
import 'api_Services.dart';
import 'ChatConversationRepository.dart';
import 'model/ChatconversationEtity.dart';
import 'package:uuid/uuid.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatServices {
  static final ChatConversationRepository _Repository =
      ChatConversationRepository();
  static final StreamController<ChatConversation> _chatConversationController =
      StreamController<ChatConversation>.broadcast();
  static Stream<ChatConversation> get streamChatConversation =>
      _chatConversationController.stream;
  static List<ChatConversation> histories = [];
  static ChatConversation? currentChatConversation;
  static GoogleSignInAccount? currentUser;
  static final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  static Function()? navigateCallback;

  static Future<void> initHive() async {
    await _Repository.init();
    var allConversationEntityes = _Repository.getAllConversations();
    var allConversations = allConversationEntityes.map((conversationEntity) {
      var conversation = ChatConversation();
      conversation.id = conversationEntity.id;
      conversation.userId = conversationEntity.userId ?? '';
      conversation.Status = conversationEntity.status;
      conversation.suggestName = conversationEntity.suggestName;
      conversation.messages = [];

      conversation.messages =
          _Repository.getMessagesByConversationId(conversation.id)
              .map((messageEntity) {
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

  static var _uuidGen = Uuid();

  static String GenerateId() {
    return _uuidGen.v4();
  }

  static void historyDoselectConversition(String id) {
    currentChatConversation =
        histories.where((element) => element.id == id).first;
    _chatConversationController.add(currentChatConversation!);
    navigateCallback?.call();
  }

  static ChatConversation createConversataion(String userId) {
    var chatconversation = ChatConversation();
    chatconversation.id = GenerateId();
    chatconversation.userId = userId;
    chatconversation.messages = [];
    chatconversation.suggestName = getDefaultSuggestion();
    histories.add(chatconversation);
    _chatConversationController.add(chatconversation);

    var conversationEtity = ChatconversationEtity();
    conversationEtity.id = chatconversation.id;
    conversationEtity.status = chatconversation.Status;
    conversationEtity.title = chatconversation.title;
    conversationEtity.suggestName = chatconversation.suggestName;
    conversationEtity.userId = chatconversation.userId;
    _Repository.addOrUpdateConversation(conversationEtity);

    return chatconversation;
  }

  static getDefaultSuggestion() {
    if (ChatGptRequestSuggestions.suggestionMap.isNotEmpty) {
      return ChatGptRequestSuggestions.suggestionMap.keys.first;
    }
    return '';
  }

  static storeUserInformation(GoogleSignInAccount userAccount) {
    var existingUsers = _Repository.getUserByGoogle(userAccount.id);

    if (existingUsers.isEmpty) {
      var userEntity = UserEtity();
      userEntity.Sn_id = userAccount.id;
      userEntity.Sn_displayName = userAccount.displayName ?? '';
      userEntity.Sn_userName = userAccount.displayName;
      userEntity.Sn_photoUrl = userAccount.photoUrl;
      userEntity.Sn_Type = 'google';

      _Repository.addUser(userEntity);
      print("tai khoan da tao moi thanh cong!---------9999999999");
    } else {
      print("tai khoan da ton tai---------");
    }
  }

  static GoogleSignInAccount? getCurrentUserAccount() {
    return currentUser;
  }

  static List<ChatConversation> getHistoryByCurrentUserLogin() {
    var userId = currentUser?.id;
    return histories
        .where((conversation) => conversation.userId == userId)
        .toList();
  }

  static void closeConversation(String id) {
    var toRem = tryGetConversation(currentUser!.id, id);
    toRem.Status = 2;
  }

  static void deleteConversation(String id) {
    var toRem = tryGetConversation(currentUser!.id, id);
    histories.remove(toRem);
    _Repository.deleteConversation(id);
    histories.removeWhere((conversation) => conversation.id == id);
    _chatConversationController.add(currentChatConversation!);
  }

  static ChatConversation tryGetConversation(String userId, String id) {
    return histories.firstWhere((e) => e.userId == userId && e.id == id);
  }

  static Future<void> trySendChatMsg(
      String userId, String from, String to, String question) async {
    currentChatConversation ??= createConversataion(currentUser!.id);
    var msg = ChatMessage();
    msg.id = GenerateId();
    msg.from = currentUser!.id;
    msg.to = 'gpt';
    msg.msg = question;
    msg.timeSent = DateTime.now();
    currentChatConversation!.messages.add(msg);
    //
    var chatmesageEtity = ChatMessageEtity();
    chatmesageEtity.conversationId = currentChatConversation!.id;
    chatmesageEtity.id = msg.id;
    chatmesageEtity.from = msg.from;
    chatmesageEtity.to = msg.to;
    chatmesageEtity.msg = msg.msg;
    chatmesageEtity.timeSent = msg.timeSent;
    _Repository.addChatmessage(chatmesageEtity);

    //chat gpt
    var templateRequest =
        ChatGptRequestSuggestions.getSuggestionAndBuildApiRequest(
            currentChatConversation!.suggestName, question);
    Map<String, dynamic> apiResponse;
    if (currentChatConversation!.suggestName == 'Tạo ảnh') {
      apiResponse = await ApiServices.createImage(templateRequest);
      String imageUrl = apiResponse['data'][0]['url'];

      var msgGpt = ChatMessage();
      msgGpt.id = GenerateId();
      msgGpt.from = 'gpt';
      msgGpt.to = currentUser!.id;
      msgGpt.msg = imageUrl;
      msgGpt.timeSent = DateTime.now();
      currentChatConversation!.messages.add(msgGpt);

      var chatmesageGptEtity = ChatMessageEtity();
      chatmesageGptEtity.conversationId = currentChatConversation!.id;
      chatmesageGptEtity.id = msgGpt.id;
      chatmesageGptEtity.from = msgGpt.from;
      chatmesageGptEtity.to = msgGpt.to;
      chatmesageGptEtity.msg = msgGpt.msg;
      chatmesageGptEtity.timeSent = msgGpt.timeSent;
      _Repository.addChatmessage(chatmesageGptEtity);
    } else if (currentChatConversation!.suggestName == 'Chuyển sang âm thanh') {
      apiResponse = await ApiServices.audio(templateRequest);
      String audioUrl = apiResponse['voice'];

      var msgGpt = ChatMessage();
      msgGpt.id = GenerateId();
      msgGpt.from = 'gpt';
      msgGpt.to = currentUser!.id;
      msgGpt.msg = audioUrl;
      msgGpt.timeSent = DateTime.now();
      currentChatConversation!.messages.add(msgGpt);

      var chatmesageGptEtity = ChatMessageEtity();
      chatmesageGptEtity.conversationId = currentChatConversation!.id;
      chatmesageGptEtity.id = msgGpt.id;
      chatmesageGptEtity.from = msgGpt.from;
      chatmesageGptEtity.to = msgGpt.to;
      chatmesageGptEtity.msg = msgGpt.msg;
      chatmesageGptEtity.timeSent = msgGpt.timeSent;
      _Repository.addChatmessage(chatmesageGptEtity);
    } else {
      apiResponse = await ApiServices.sendChatRequest(templateRequest);
      String replyMessage = apiResponse['choices'][0]['message']['content'];

      var msgGpt = ChatMessage();
      msgGpt.id = GenerateId();
      msgGpt.from = 'gpt';
      msgGpt.to = currentUser!.id;
      msgGpt.msg = replyMessage;
      msgGpt.timeSent = DateTime.now();
      currentChatConversation!.messages.add(msgGpt);

      var chatmesageGptEtity = ChatMessageEtity();
      chatmesageGptEtity.conversationId = currentChatConversation!.id;
      chatmesageGptEtity.id = msgGpt.id;
      chatmesageGptEtity.from = msgGpt.from;
      chatmesageGptEtity.to = msgGpt.to;
      chatmesageGptEtity.msg = msgGpt.msg;
      chatmesageGptEtity.timeSent = msgGpt.timeSent;
      _Repository.addChatmessage(chatmesageGptEtity);
    }
  }

  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      GoogleSignInAccount? user = currentUser;
      if (user == null) {
        user = await googleSignIn.signIn();

        if (user != null) {
          currentUser = user;
          // todo: neu history theo user , length>0 thi lay cai lastest ra gan vao currentChatConverstaion
          // con history.where(user==userid).lenghth==0 thi tao moi
          currentChatConversation = createConversataion(currentUser?.id ?? '');
          navigateCallback?.call();
        }
      }

      return user;
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  static Future<void> signOutWithGoogle() async {
    try {
      googleSignIn.disconnect();
      await googleSignIn.signOut();
      navigateCallback?.call();
      print('Signed out');
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  static Future<void> uploadFile(PlatformFile file) async {
    try {
      var response = await ApiServices.uploadFile(file);
      if (response != null) {
        var msg = ChatMessage();
        msg.id = GenerateId();
        msg.from = 'gpt';
        msg.to = currentUser!.id;
        msg.msg = 'Selected file: ${file.name}';
        msg.timeSent = DateTime.now();
        currentChatConversation!.messages.add(msg);

        var chatMessageEntity = ChatMessageEtity();
        chatMessageEntity.conversationId = currentChatConversation!.id;
        chatMessageEntity.id = msg.id;
        chatMessageEntity.from = msg.from;
        chatMessageEntity.to = msg.to;
        chatMessageEntity.msg = msg.msg;
        chatMessageEntity.timeSent = msg.timeSent;
        _Repository.addChatmessage(chatMessageEntity);
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

class ChatConversation {
  String id = "";
  String userId = "";
  List<ChatMessage> messages = [];
  int Status = 0; //0: moi, 1: dang chat, 2: dong(close)
  String get title => messages.isEmpty ? id : messages.first.msg;
  String suggestName = "";
  List<User> user = [];
}

class ChatMessage {
  String id = "";
  String from = "";
  String to = "";
  String msg = "";
  DateTime timeSent = DateTime.now();
  bool liked = false;
  bool disliked = false;
}

class User {
  String id = '';
  String displayName = '';
  String? userName;
  var photoUrl;
  String Type = 'google';
}
