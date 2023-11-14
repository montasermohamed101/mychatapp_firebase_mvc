import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapp/view/screens/home.dart';
import 'package:path/path.dart';

class RegisterController extends GetxController{

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowen = true;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  final  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? file;
  String? url;

  pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageCamera =
    await picker.pickImage(source: ImageSource.gallery);

    if (imageCamera != null) {
      file = File(imageCamera.path);
      //todo: here to get only the name of image
      // var imageName = basename(imageCamera.path);
      // Reference ref = _storage
      //     .ref().child('"profilePics').child(_auth.currentUser!.uid);
      //
      // await ref.putFile(file!);
      // // //todo: here to get the path(link image) of image
      // url = await ref.getDownloadURL();
    }
    update();
  }


  uploadImageToFireStore(File image,String imageName) async {
    Reference ref = _storage.ref().child('profilePics/${_auth.currentUser!.uid}$imageName');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image,metadata);
    String url = await ref.getDownloadURL();
    return url;
  }

  register(BuildContext context)async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty
        && nameController.text.isNotEmpty && file != null
    )
    {
      isLoading = true;
      update();
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        String imageName = basename(file!.path);

        String profileUrl = await uploadImageToFireStore(file!, imageName);
      await  _firestore.collection("users").doc(credential.user!.uid).set({
          "email":emailController.text,
          "name":nameController.text,
          "uid":credential.user!.uid,
        "profileImage":profileUrl
        });
        isLoading = false;
        update();
        Get.offAll(HomeScreen());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }else{
      if(file == null){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Pick Image")));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email and Password Field can't be empty")));

      }
    }

  }


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}