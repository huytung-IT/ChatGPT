import 'dart:async';
import 'package:flutter/material.dart';
import 'ChatServices.dart';
import 'ChatScreen.dart';
class SearchHistoryPage extends StatefulWidget {
  const SearchHistoryPage({super.key});

  @override
  _SearchHistoryPageState createState() => _SearchHistoryPageState();
}

class _SearchHistoryPageState extends State<SearchHistoryPage> {
  StreamSubscription<ChatConversation>? currentSub;
  bool hasSearched = false;
  int? selectedCardIndex;
  String? id;
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (currentSub != null) await currentSub!.cancel();
    currentSub = ChatServices.streamChatConversation.listen((event) {
      if (event.Status == 0) {
        setState(() {

          hasSearched = true;
        });
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (currentSub != null) currentSub!.cancel();
  }
  @override
  Widget build(BuildContext context) {
    var xxx= ChatServices.getHistoryByCurrentUserLogin();
    print('${xxx.length}----------------');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử tra cứu'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
        ),
        body: Column(
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: xxx.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: selectedCardIndex == index
                            ? Colors.blue[100]
                            : Colors.grey[100],
                        child: ListTile(
                            title: Text(xxx[index].title),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() {
                                  ChatServices.deleteConversation(xxx[index].id);
                                  //todo: khi delete cai cuoi cung thi history empty
                                  // quay ve man chatGPT thif chet vi currentConversation bi null nen heo man chatGpt
                                  // can create 1 cais mowi
                                  // lay history cua thang dang nhap hien tai, lenght==0 thi goi ham createConversation;
                                  if (ChatServices.currentChatConversation != null &&
                                      ChatServices.currentChatConversation!.id ==  xxx[index].id) {
                                    ChatServices.currentChatConversation =
                                        ChatServices.createConversataion(ChatServices.currentUser!.id);
                                    ChatServices.navigateCallback = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ChatScreen()),
                                      );
                                    };
                                   }else {
                                    if(ChatServices.histories.isEmpty) {
                                      ChatServices.currentChatConversation =
                                        ChatServices.createConversataion(ChatServices.currentUser!.id);
                                      ChatServices.navigateCallback = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ChatScreen()),
                                        );
                                      };
                                    }
                                  }
                                });
                              },
                            ),
                            onTap: () {
                              ChatServices.historyDoselectConversition(
                                  xxx[index].id);
                              ChatServices.navigateCallback = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChatScreen()),
                                );
                              };
                            }),
                      );
                    },
                  ),
                ),
              ],
            )),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  if (hasSearched) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng thực hiện tìm kiếm trước'),
                        backgroundColor: Colors.red,
                      ),
                    );

                    return;
                  }try {
                    hasSearched = true;
                    ChatServices.currentChatConversation = ChatServices.createConversataion(ChatServices.currentUser!.id);
                    ChatServices.navigateCallback = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    };
                    await Future.delayed(const Duration(milliseconds: 300));
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('errorsssssssss'),
                      backgroundColor: Colors.red,
                    ));
                  } finally {
                    setState(() {
                      hasSearched = false;
                    });
                  }
                },
                label: const Text('New Chat'),
                icon: const Icon(Icons.add),
                backgroundColor: const Color.fromRGBO(16, 163, 127, 1),
              ),
            ),
          ],
        ));
  }
}
