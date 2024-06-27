import 'dart:io';

import 'package:chatgpt_app/ChatServices.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_app/SearchHistoryPage.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Suggestions.dart';
import 'Login.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static final TextEditingController _textController = TextEditingController();
  bool _isSending = false;
  final FocusNode _fieldNode = FocusNode();
  bool _showSuggestions = false;
  final ScrollController _scrollController = ScrollController();
  List<PlatformFile> _selectedFiles = [];

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
    ChatServices.signInWithGoogle();
  }

  @override
  void dispose() {
    _fieldNode.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        await ChatServices.uploadFile(file);
      }
    } on PlatformException catch (e) {
      print('Unsupported operation: ${e.toString()}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat GPT'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(ChatServices.currentUser?.displayName ?? ''),
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                ChatServices.navigateCallback = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                };
                await ChatServices.signOutWithGoogle();
              },
            ),
          ],
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
                      padding: const EdgeInsets.only(right: 80),
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
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                ChatServices.currentChatConversation!
                                    .messages[index].msg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: UpperNipMessageClipper(MessageType.send,
                                sizeRatio: 3),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20, bottom: 20),
                              decoration: const BoxDecoration(
                                color: Colors.lightBlue,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 2,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Text(
                                ChatServices.currentChatConversation
                                        ?.messages[index].msg ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_showSuggestions && isKeyboardVisible())
                  Container(
                    child: Card(
                      color: Colors.grey[200],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var sggk
                              in ChatGptRequestSuggestions.suggestionMap.keys)
                            ListTile(
                              title: Text(
                                sggk,
                                style: TextStyle(
                                  fontWeight: (sggk ==
                                          ChatServices.currentChatConversation
                                              ?.suggestName)
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                if (sggk.isEmpty) {
                                  ChatServices.currentChatConversation
                                              ?.suggestName ==
                                          ChatGptRequestSuggestions
                                              .suggestionMap.keys.first
                                      ? FontWeight.bold
                                      : FontWeight.normal;
                                } else {
                                  ChatServices.currentChatConversation
                                      ?.suggestName = sggk;
                                  print(
                                      '$sggk---------------------------00000000000000');
                                }
                                // ignore: unnecessary_null_comparison
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      color: Colors.grey,
                      onPressed: _pickAndUploadFile,
                    ),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        focusNode: _fieldNode,
                        textCapitalization: TextCapitalization.sentences,
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
                              ChatServices.currentUser!.id,
                              'from',
                              'to',
                              _textController.text);
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
                            content: Text('erroryyyyyyy'),
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

  bool isKeyboardVisible() {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return keyboardHeight > 0;
  }
}

/*
 */
