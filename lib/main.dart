import 'package:flutter/material.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/PasswordChange.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/TeacherDetails.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/EditProfileStudent.dart';
import 'package:home_teacher/vues/Favoris.dart';

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
      home: ExplorerPage(),
    );
  }
}
