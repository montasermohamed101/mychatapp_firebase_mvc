import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mychatapp/model/message_model.dart';

class ChatController extends GetxController{

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController message = TextEditingController();


  //To get the name of the user
  Future<String> _getUserName(String userId)async{
    final DocumentSnapshot userDoc = await _firestore.collection("users").doc(userId).get();
    if(userDoc.exists){
      return userDoc["name"];
    }else{
      return firebaseAuth.currentUser!.email ?? "Unknown";

    }
  }


 Future<void> sendMessage({
  required String receiverId
})async{
   final User? user = firebaseAuth.currentUser;
   final String currentUserId = user!.uid;
    final String currentUserName = await _getUserName(currentUserId); // Retrieve the user's name
    final Timestamp timestamp = Timestamp.now();

    //Create a new Message

   MessageModel newMessage = MessageModel(
       senderId: firebaseAuth.currentUser!.uid,
       senderName: currentUserName,
       message: message.text,
       receiverId: receiverId,
       timestamp: timestamp);

   List<String> ids = [receiverId,currentUserId];
   ids.sort();
   String chatRoomId = ids.join("_");

   if(currentUserId != receiverId){
     await _firestore.collection("chat").doc(chatRoomId).collection("messages").add(newMessage.toMap());
   }

  }

  Stream<QuerySnapshot> getMessages({required String userId,required String otherUserId}){
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore.collection("chat").doc(chatRoomId).collection("messages").orderBy("timestamp",descending: false).snapshots();

  }

}