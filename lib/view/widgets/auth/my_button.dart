import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;

  MyButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 60),
      ),
        onPressed: onPressed, child: Text(title));
  }
}
