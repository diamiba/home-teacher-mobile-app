import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';

class EditProfileTeacherPage extends StatefulWidget {
  Teacher teacher;
  EditProfileTeacherPage(this.teacher);
  @override
  _EditProfileTeacherPageState createState() => _EditProfileTeacherPageState(teacher);
}

class _EditProfileTeacherPageState extends State<EditProfileTeacherPage> {
  Teacher teacher;
  int mark, maxMark=5;
  List<String> levelTeached, districtTeached, subjectTeached;
  String selected;
  TextEditingController education, job, description;

  _EditProfileTeacherPageState(this.teacher){
    levelTeached = List.from(this.teacher.levelTeached);
    districtTeached = List.from(this.teacher.districtTeached);
    subjectTeached = List.from(this.teacher.subjectTeached);
    education = TextEditingController(text: this.teacher.education);
    job = TextEditingController(text: this.teacher.job);
    description = TextEditingController(text: this.teacher.description);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: CustomCard(
            Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText("Modifier mes informations d'enseignant", darkColor, 3, bold: true),
                ),
                CustomDropDown("Dans quel(s) quartier(s) enseignez-vous ?", "Exemple : Pissy", selected, districtList, (String selection) {if (!this.districtTeached.contains(selection)) setState((){this.districtTeached.add(selection);});}),
                MyChips((this.districtTeached)),
                CustomDropDown("Quelle(s) discipline(s) enseignez-vous ?", "Exemple : Mathématiques", selected, subjectList, (String selection) {if (!this.subjectTeached.contains(selection)) setState((){this.subjectTeached.add(selection);});}),
                MyChips(this.subjectTeached),
                CustomDropDown("Quelle(s) classe(s) enseignez-vous ?", "Exemple : 6 ème, 5 ème", selected, levelList, (String selection) {if (!this.levelTeached.contains(selection)) setState((){this.levelTeached.add(selection);});}),
                MyChips(this.levelTeached),
                CustomTextField("Qu'avez-vous étudié ?", "Exemple : Baccalauréat", TextInputType.text, education),
                CustomTextField("Quel est votre métier actuel?", "Exemple : Développeur informatique", TextInputType.text, job),
                CustomTextField("Un petit résumé sur vous (Max : 200 mots)", "", TextInputType.text, description, multiline: true,),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0,),
                  child: CustomButton("ENREGISTER", mainColor, ()=>print("ENREGISTER")),
                ),
              ],
              ),
            ),
          ),
      ),
      pageName: "MON COMPTE",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
    );
  }
}























class MyChips extends StatefulWidget {
  List<String> allElements;
  MyChips(this.allElements);
  @override
  _MyChipsState createState() => _MyChipsState(this.allElements);
}

class _MyChipsState extends State<MyChips> {
  List<String> allElements;
  _MyChipsState(this.allElements);

  void _removeMaterial(String name) {
    allElements.remove(name);
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> chips = allElements.map<Widget>((String name) {
      return Padding(
        padding: const EdgeInsets.only(right:5.0),
        child: Chip(
          key: ValueKey<String>(name),
          backgroundColor: mainLightColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          label: CustomText(name, darkColor, 5, padding: 0),
          deleteIconColor: darkColor,
          onDeleted: () {
            setState(() {
              _removeMaterial(name);
            });
          },
        ),
      );
    }).toList();

    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 15),
        scrollDirection: Axis.horizontal,
        child: Row(children: chips),
      ),
    );
  }
}