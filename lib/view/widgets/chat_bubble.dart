import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
final String message;
final Color color;
ChatBubble({required this.message,required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Text(message,style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),),
    );
  }
}
