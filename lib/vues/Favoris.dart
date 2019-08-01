import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FavorisPage extends StatefulWidget {
  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      favorisCard(teachers),
      pageName: "FAVORIS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
    );
  }




  Widget favorisCard(List<Teacher> tearchersFound){
    List <Widget> liste = List();
    liste.add(
      Center(child: CustomText("Mes favoris", darkColor, 2, bold: true, padding: 0,),)
    );

    liste.add(SizedBox(height: 40,));

    for(Teacher teacher in tearchersFound)
      liste.add(TeacherCard(teacher, isFavoriteCard: true,));
    return Container(
      width: MediaQuery.of(context).size.width,
      color: lightGreyColor,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
      child: Column(
        children: liste
      )
    );
  }
}