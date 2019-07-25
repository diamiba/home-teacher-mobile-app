import 'package:flutter/material.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/PasswordChange.dart';
import 'package:home_teacher/vues/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Teacher',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}
