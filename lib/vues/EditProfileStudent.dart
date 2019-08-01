import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/Utile.dart';

class EditProfileStudentPage extends StatefulWidget {
  Student student;
  EditProfileStudentPage(this.student);
  @override
  _EditProfileStudentPageState createState() => _EditProfileStudentPageState(student);
}

class _EditProfileStudentPageState extends State<EditProfileStudentPage> {
  Student student;
  int mark, maxMark=5;
  String level, district;
  String selected;
  TextEditingController school;

  _EditProfileStudentPageState(this.student){
    level = this.student.level;
    district = this.student.district;
    school = TextEditingController(text: this.student.school);
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
                  child: CustomText("Modifier mes informations d'élève", darkColor, 3, bold: true),
                ),
                CustomDropDown("Dans quel quartier habitez-vous ?", "Exemple : Pissy", district, districtList, (String selection) {if (selection != district) setState((){this.district = selection;});}),
                CustomDropDown("Quelle est votre classe actuelle ?", "Exemple : 6 ème", level, levelList, (String selection) {if (selection != level) setState((){this.level = selection;});}),
                CustomTextField("Où étudiez-vous ?", "Exemple : Lycée Phillipe Zinda Kaboré", TextInputType.text, this.school),      
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


  Widget drawerItem(String texte, Widget destinationPage, {bool isSelected = false, isLogout = false}){
    return ListTile(
      title: Container(
        color: isSelected?mainHighlightColor:mainColor,
        child: Center(child: CustomText(texte, whiteColor, 4))
      ),
      contentPadding: const EdgeInsets.all(0),
      onTap: (){
        if(!isLogout){
          Navigator.of(context).pop();
          Navigator.push(context,
            MaterialPageRoute(builder: (context)=> destinationPage)
          );
        }
        else{
          while(Navigator.of(context).canPop())
            Navigator.of(context).pop();
        }
      }
    );
  }
}
