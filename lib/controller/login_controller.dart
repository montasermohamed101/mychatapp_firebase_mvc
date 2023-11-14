import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/home.dart';

class LoginController extends GetxController{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
   bool isShowen = true;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  login(BuildContext context)async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty )
      {
        isLoading = true;
        update();
        try {
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          isLoading = false;
          update();
          Get.offAll(HomeScreen());
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            print('Wrong password provided for that user.');
          }
        }
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email and Password Field can't be empty")));
    }

  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}