import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/constants.dart';
import 'package:videoapp/views/widgets/chat_bubble.dart';

import '../../../controllers/chat_service_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverUserName, required this.receierUserId});
  final String receiverUserName;
  final String receierUserId;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          widget.receierUserId, messageController.text);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '@${widget.receiverUserName}',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),

          //user input
          buildMessageInput(),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Widget buildMessageList() {
    return StreamBuilder(
      stream:
          chatService.getMessage(widget.receierUserId, authController.user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }
        return ListView(
          children: snapshot.data!.docs
              .map((documnet) => buildMessageItem(documnet))
              .toList(),
        );
      },
    );
  }

  Widget buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var aligment = (data['senderId'] == authController.user.uid)
        ? Alignment.centerLeft
        : Alignment.centerRight;
    return Container(
      alignment: aligment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == authController.user.uid)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    data['senderprofilePhoto'],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ChatBubble(message: data['message']),
              ],
              
            ),
            Text(
              data['senderName'],
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: TextField(
            controller: messageController,
            obscureText: false,
            style: const TextStyle(color: textColor),
            decoration: const InputDecoration(
              border: InputBorder.none, // Remove the default border
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.redAccent),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              labelStyle: TextStyle(color: Colors.redAccent),
              labelText: "Cùng nhau trò chuyện nào",
              hintStyle:
                  TextStyle(fontWeight: FontWeight.w300, color: Colors.grey),
            ),
          )),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
