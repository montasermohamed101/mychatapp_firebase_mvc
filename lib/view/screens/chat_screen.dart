import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mychatapp/controller/chat_controller.dart';
import 'package:mychatapp/view/widgets/chat_bubble.dart';

class ChatScreen extends StatelessWidget {
  final String receiverUserID;
  final String receiverUserName;
  final String image;

  ChatScreen({required this.receiverUserID, required this.receiverUserName,required this.image});

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChatController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("${receiverUserName}"),
          actions:[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(image),
              ),
            )
          ] ,

        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: controller.getMessages(
                userId: receiverUserID,
                // Current user ID
                otherUserId: controller.firebaseAuth.currentUser!
                    .uid, // Receiver user ID from the widget parameters
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var alignment =
                          (doc["senderId"] == _firebaseAuth.currentUser!.uid)
                              ? Alignment.centerRight
                              : Alignment.centerLeft;
                      return Container(
                        alignment: alignment,
                        child: Column(
                          children: [
                            Text(doc['senderName']),
                            (doc["senderId"] == _firebaseAuth.currentUser!.uid
                                ? ChatBubble(
                                    message: doc['message'],
                                    color: Colors.deepPurple)
                                : ChatBubble(
                                    message: doc['message'],
                                    color: Colors.blue))
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            )),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    var controller = Get.find<ChatController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //TextFormField
          Expanded(
            child: TextFormField(
              controller: controller.message,
              decoration: const InputDecoration(
                hintText: "Message",
                border: OutlineInputBorder(),
              ),
              obscureText: false,
            ),
          ),
          //Sending Message Button

          IconButton(
            onPressed: () async {
              if (controller.message.text.isNotEmpty) {
                await controller.sendMessage(receiverId: receiverUserID);
                controller.message.clear();
              }
            },
            icon: const Icon(Icons.send_outlined),
          )
        ],
      ),
    );
  }
}
