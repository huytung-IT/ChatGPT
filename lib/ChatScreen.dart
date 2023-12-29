import 'package:chatgpt_app/ChatServices.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_app/SearchHistoryPage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Suggestions.dart';

class ChatScreen extends StatefulWidget {
  final String conversationId;

  const ChatScreen({Key? key, required this.conversationId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static final TextEditingController _textController = TextEditingController();
  bool _isSending = false;
  final FocusNode _fieldNode = FocusNode();
  bool _showSuggestions = false;
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _fieldNode.addListener(() {
      setState(() {
        _showSuggestions = _fieldNode.hasFocus;
      });
    });
    ChatServices.streamChatConversation.listen((event) {
      if (mounted) {
        setState(() {});
      }

    });
  }

  @override
  void dispose() {
    _fieldNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat GPT'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
        ),
        backgroundColor: Colors.white,
        drawer: const Drawer(
          child: SearchHistoryPage(),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                    left: 15, top: 20, right: 20, bottom: 80),
                itemCount: ChatServices.currentChatConversation == null
                    ? 0
                    : ChatServices.currentChatConversation?.messages.length,
                itemBuilder: (context, index) {
                  var msg =
                      ChatServices.currentChatConversation!.messages[index];
                  if (msg.from == 'gpt') {
                    return Padding(
                      padding: const EdgeInsets.only( right: 80),
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: UpperNipMessageClipper(MessageType.receive,
                                sizeRatio: 3),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white70,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    offset: Offset(0,2),
                                  ),
                                ],
                              ),
                              child: Text(
                                ChatServices.currentChatConversation!
                                    .messages[index].msg,
                                // style: const TextStyle(fontSize: 16,),
                              ),
                            ),
                          ),

                          // const Positioned(
                          //   left: 0,
                          //   top: 0,
                          //   child: CircleAvatar(
                          //     backgroundImage: NetworkImage(
                          //         'https://th.bing.com/th/id/OIP.JE-inloKPHCLxjm4wtMJigAAAA?pid=ImgDet&rs=1'),
                          //     radius: 12,
                          //   ),
                          // ),
                          // Positioned(
                          //   right: 0,
                          //   bottom: 0,
                          //   height: 30, // tăng giá trị chiều cao
                          //   width: 96,
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       // Xử lý khi nhấp vào LikeDislikeChatMessage
                          //     },
                          //     child: LikeDislikeChatMessage(
                          //       chatMessage: ChatServices.currentChatConversation!.messages[index],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper:  UpperNipMessageClipper(MessageType.send,
                                sizeRatio: 3),
                            child: Container(
                              padding: const EdgeInsets.only(left: 20, top:20, right: 20, bottom: 20 ),
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    offset: Offset(0,0),
                                  ),
                                ],
                              ),
                              child: Text(
                                ChatServices.currentChatConversation
                                        ?.messages[index].msg ??
                                    "",
                                style: const TextStyle(fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                          // Positioned(
                          //    right: 75,
                          //    bottom: 0,
                          //    height: 8,
                          //    width: 96,
                          //    child: LikeDislikeChatMessage(
                          //        chatMessage: ChatServices
                          //            .currentChatConversation!
                          //            .messages[index])
                          // ),
                          // const Positioned(
                          //   bottom:0,
                          //   right:0,
                          //
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.white,
                          //     radius: 12,
                          //     child: Icon(
                          //       Icons.face_rounded,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            if (_isSending) ...[
              LoadingAnimationWidget.waveDots(color: Colors.black, size: 50)
            ],
              // Expanded(
                // child: Stack(
                //   children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      if (_showSuggestions)
                  Container(
                    child: Card(
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var sggk in ChatGptRequestSuggestions.suggestionMap.keys)
                            ListTile(
                              title: Text(
                                sggk,
                                style: TextStyle(
                                  fontWeight:
                                  (sggk == ChatServices.currentChatConversation?.suggestName)
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                if(sggk == null) {
                                  ChatServices.currentChatConversation?.suggestName == ChatGptRequestSuggestions.suggestionMap.keys.first
                                    ? FontWeight.bold
                                    : FontWeight.normal;
                                }else {
                                  // print("aaaaaa${ ChatGptRequestSuggestions.suggestionMap.keys.first}");
                                  ChatServices.currentChatConversation?.suggestName = sggk;
                                }

                                ChatServices.updateConversation(ChatServices.currentChatConversation!);
                                if(mounted){setState(() {

                                });}
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                focusNode: _fieldNode,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: const TextStyle(color: Colors.black),
                                controller: _textController,
                                minLines: 2,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white70,
                                  filled: true,
                                  hintText: 'Send a message...',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              color: Colors.grey,
                              onPressed: () async {
                                if (_isSending) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Bạn không thể gửi nhiều tin cùng một lúc'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                if (_textController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Vui lòng nhập tin nhắn'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  _isSending = true;
                                  await ChatServices.trySendChatMsg(
                                      "from", "to", _textController.text);
                                  _textController.clear();
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                  setState(() {
                                    _showSuggestions = false;
                                  });
                                } catch (error) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('error'),
                                    backgroundColor: Colors.red,
                                  ));
                                } finally {
                                  setState(() {
                                    _isSending = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                //   ],
                // )
              // ),
          ],
        ),
      ),
    );
  }
}

/*
 */
