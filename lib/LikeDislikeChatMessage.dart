import 'package:chatgpt_app/ChatServices.dart';
import 'package:flutter/material.dart';

class LikeDislikeChatMessage extends StatefulWidget {
  final ChatMessage chatMessage;
  LikeDislikeChatMessage({Key? key, required this.chatMessage}) : super(key: key);

  @override
  _LikeDislikeChatMessageState createState() => _LikeDislikeChatMessageState();
}

class _LikeDislikeChatMessageState extends State<LikeDislikeChatMessage> {
  bool liked = false;
  bool disliked = false;

  void toggleLike() {
    setState(() {
      widget.chatMessage.liked = !widget.chatMessage.liked;
      widget.chatMessage.disliked = false;

    });
  }

  void toggleDislike() {
    setState(() {
      widget.chatMessage.disliked = !widget.chatMessage.disliked;
      widget.chatMessage.liked = false;


    });
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: toggleLike,
          icon: Icon(
            widget.chatMessage.liked ? Icons.thumb_up : Icons.thumb_up_outlined,
            color: widget.chatMessage.liked ? Colors.blue : Colors.grey,
          ),
        ),
        IconButton(
          onPressed: toggleDislike,
          icon: Icon(
            widget.chatMessage.disliked ? Icons.thumb_down : Icons.thumb_down_outlined,
            color: widget.chatMessage.disliked ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }
}
