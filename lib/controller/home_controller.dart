import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  //signout method
  Future<void> signOut()async{
    return await _firebaseAuth.signOut();
  }



}