import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screen/welcome_screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  MyApp({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return GetMaterialApp(
        title: 'Physics Flashcard',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LoginScreen());
  }
}