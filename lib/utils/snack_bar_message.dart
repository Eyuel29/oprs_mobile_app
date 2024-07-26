import 'package:flutter/material.dart';

class SnackBarMessage{
  static void make(BuildContext context, String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}