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
        _initNewChatScreen();
      }
      if (mounted) setState(() {});
    });
  }
  void _initNewChatScreen() {
    var newChatScreen = ChatScreen(conversationId: ChatServices.currentChatConversation!.id);
    // print( ChatServices.currentChatConversation!.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newChatScreen),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (currentSub != null) currentSub!.cancel();
  }
  @override
  Widget build(BuildContext context) {
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
                    itemCount: ChatServices.histories.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: selectedCardIndex == index
                            ? Colors.blue[100]
                            : Colors.grey[100],
                        child: ListTile(
                            title: Text(ChatServices.histories[index].title),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                setState(() {
                                  ChatServices.deleteConversation(
                                      ChatServices.histories[index].id);
                                });
                              },
                            ),
                            onTap: () {
                              ChatServices.historyDoselectConversition(
                                  ChatServices.histories[index].id);
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
                    ChatServices.createConversataion();
                    setState(() {
                      _initNewChatScreen();
                    });
                    Navigator.pop(context);
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
