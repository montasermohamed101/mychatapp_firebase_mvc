import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mychatapp/controller/home_controller.dart';
import 'package:mychatapp/view/screens/auth/login.dart';

import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  GetBuilder(
      init: HomeController(),
      builder: (controller) =>Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
                onPressed: (){
                  controller.signOut();
                  Get.offAll(LoginScreen());
                }
                , icon: Icon(Icons.logout_outlined))
          ],
        ),

        body: _buildUserList(),
      ),
    );
  }


  Widget _buildUserList() {
    final Stream<QuerySnapshot> _usersStream =
    FirebaseFirestore.instance.collection('users').snapshots();
    return StreamBuilder(
      stream: _usersStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          // Check if there's no data yet, return an empty container
          return Center(child: CircularProgressIndicator(),);
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map((e) => _buildUserListItem(e))
                .toList(),
          );
        }
      },
    );
  }

  // Widget _buildUserList(){
  //  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
  //  return StreamBuilder(
  //       stream: _usersStream,
  //       builder: (context,snapshot){
  //         if(snapshot.hasError){
  //           return Text("Error");
  //         }else if (snapshot.connectionState == ConnectionState.waiting){
  //           return Center(child: CircularProgressIndicator(),);
  //         }else{
  //           return ListView(
  //             children: snapshot.data!.docs.map((e) => _buildUserListItem(e)).toList(),
  //           );
  //         }
  //       });
  // }

Widget  _buildUserListItem(DocumentSnapshot documentSnapshot) {
  Map<String,dynamic> data = documentSnapshot.data()! as Map<String,dynamic>;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if(_firebaseAuth.currentUser!.uid != data['uid']){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ListTile(
          title: Text("${data['name']}",style: TextStyle(fontSize: 25),),
          trailing: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(data['profileImage']),
            ),
          ),
          onTap: () {
            Get.to(ChatScreen(
              receiverUserID: data['uid'],
              receiverUserName: data['name'],
              image: data['profileImage'],
            ));
          },
        ),
      );

    }else{
      return Container();
    }
  }
}
