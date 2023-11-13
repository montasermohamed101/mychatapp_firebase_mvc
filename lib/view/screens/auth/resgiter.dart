import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mychatapp/controller/login_controller.dart';
import 'package:mychatapp/view/screens/auth/login.dart';
import 'package:mychatapp/view/widgets/auth/my_text_form_field.dart';

import '../../../controller/register_controller.dart';
import '../../widgets/auth/my_button.dart';

class RegisterScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RegisterController(),
      builder: (controller) => Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.loginFormKey,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      controller.file != null ?
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.orange,
                        backgroundImage: Image
                            .file(controller.file!)
                            .image,
                      ) : const CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.orange,
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/128/9187/9187604.png"),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: IconButton(
                            onPressed: () {
                              controller.pickProfileImage();
                            },
                            icon: Icon(Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  const Text("Create Your Account Now",style: TextStyle(
                    fontSize: 26,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),),
                  // Email TextFormField
                  MyTextFormField(
                      hintText: "Please Enter Your Email",
                      labelText: "Email",
                      icon: const Icon(Icons.person_outline_outlined),
                      controller: controller.emailController
                  ),
                  MyTextFormField(
                      hintText: "Please Enter Your Name",
                      labelText: "Name",
                      icon: const Icon(Icons.person_outline_outlined),
                      controller: controller.nameController,
                  ),
                  MyTextFormField(
                    hintText: "Please Enter Your Password",
                    labelText: "Password",
                    icon: const Icon(Icons.password_outlined),
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
                    title: "Register",
                    onPressed: (){
                      controller.register(context);
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("have an account? "),
                      InkWell(
                          onTap: (){
                            Get.offAll(LoginScreen());
                          },
                          child: const Text("Login",style: TextStyle(
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
