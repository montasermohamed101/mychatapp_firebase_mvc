import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Icon icon;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool? obscureText;

  MyTextFormField({
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.suffixIcon,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
            labelText: labelText,
            prefixIcon: icon,
            suffixIcon: suffixIcon),
        obscureText: obscureText!,
      ),
    );
  }
}
