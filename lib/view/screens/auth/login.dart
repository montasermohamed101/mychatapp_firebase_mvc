import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mychatapp/controller/login_controller.dart';
import 'package:mychatapp/view/screens/auth/resgiter.dart';
import 'package:mychatapp/view/widgets/auth/my_text_form_field.dart';

import '../../widgets/auth/my_button.dart';

class LoginScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LoginController(),
      builder: (controller) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Welcome To Chat App",style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),),
                  // Email TextFormField
                  MyTextFormField(
                      hintText: "Please Enter Your Email",
                      labelText: "Email",
                      icon: Icon(Icons.person_outline_outlined),
                      controller: controller.emailController
                  ),
                  MyTextFormField(
                      hintText: "Please Enter Your Password",
                      labelText: "Password",
                      icon: Icon(Icons.password_outlined),
                      controller: controller.passwordController,
                    suffixIcon: InkWell(
                      onTap: (){
                        controller.isShowen =! controller.isShowen;
                        controller.update();
                      },
                      child: Icon(
                        controller.isShowen ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    obscureText: controller.isShowen ,
                  ),
                  const SizedBox(height: 30),
                  MyButton(
                    title: "Login",
                    onPressed: (){
                      controller.login(context);
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      InkWell(
                        onTap: (){
                          Get.offAll(RegisterScreen());
                        },
                          child: Text("Register",style: TextStyle(
                             fontSize: 16,
                            color: Colors.blue,
                          ),))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }
}
