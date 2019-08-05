import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searched = false;
  String selectedDistrict;
  String selectedSubject;
  String selectedLevel;

  _HomePageState(){
    selectedDistrict = districtList[0];
    selectedSubject = subjectList[0];
    selectedLevel = levelList[0];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    double height = (MediaQuery.of(context).size.height-510);

    return CustomBody(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50,),
          searched?Container():Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              Container(
                height: 45,
                child: CustomText("Home-Teacher",whiteColor, 1, bold: true, padding: 0,),
              ),
              Container(
                height: 20,
                margin: const EdgeInsets.only(left: 6),
                child: TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  duration: Duration(seconds: 3),
                  text: ["Nos professeurs n'attendent que vous."],
                  textStyle: TextStyle(
                      fontSize: size4,
                      color: whiteColor
                  ),
                  textAlign: TextAlign.start,
                  alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                ),
              ),
              SizedBox(height: 50,),
            ],),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: searched?45.0:0),
            padding: const EdgeInsets.only(top: 10, bottom: 5, left: 30.0, right: 30.0),
            color: whiteColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                choiceElement(districtList, this.selectedDistrict, (String selection) {if (selection != this.selectedDistrict) setState((){this.selectedDistrict = selection;});}),
                choiceElement(subjectList, this.selectedSubject, (String selection) {if (selection != this.selectedSubject) setState((){this.selectedSubject = selection;});}),
                choiceElement(levelList, this.selectedLevel, (String selection) {if (selection != this.selectedLevel) setState((){this.selectedLevel = selection;});}, isLast: true),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: searched?45.0:0),
            color: mainColor,
            child: CustomButton("CHERCHER !", mainColor, 
              (){
                print('CHERCHER !');
                if(!searched)
                  setState(() {
                  searched = true; 
                  });
                /*Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> SearchPage())
                );*/
              },
              shadow: false,
            ),
          ),
          searched?SizedBox(height: 50,):SizedBox(height: height<60?60:height),
          searched?resultCard(teachers):Center(
            child: FlatButton.icon(
              icon: Icon(Icons.arrow_drop_down, color: whiteColor, size: 50,),
              label: CustomText("EXPLORER", whiteColor, 4, bold: true,),
              onPressed: (){
                print('Explorer');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> ExplorerPage())
                );
              }
            ),
          ),
        ],
      ),
      pageName: "ENSEIGNANTS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
    );
  }

  Widget choiceElement(List<String> liste, String value, Function fonction, {bool isLast = false}) {
    final List<DropdownMenuItem<String>> items = liste.map(
      (String val) =>
          DropdownMenuItem<String>(
            value: val, 
            child: CustomText(val, darkColor, 4, padding: 0,),
        )).toList();
    return Card(
      elevation: 0,
      child: DropdownButton<String>(
        style: TextStyle(fontSize: size4, color: darkColor),
        icon: Icon(
          Icons.arrow_drop_down,
          color: greyColor,
        ),
        iconSize: 30,
        isExpanded: true,
        isDense: true,
        value:value,
        items: items,
        onChanged: (String selection) {fonction(selection);},
        underline: !isLast?Divider(height: 0.2, color: greyColor,):Container(),
      ),
    );
  }

  Widget resultCard(List<Teacher> tearchersFound){
    List <Widget> liste = List();
    List <Widget> myTeachers = List();
    liste.add(CustomText("Résultats de la recherche.", darkColor, 2, bold: true, padding: 5,));
    if(tearchersFound != null && tearchersFound.isNotEmpty){
      liste.add(CustomText("${tearchersFound.length} enseignant${tearchersFound.length>1?"s ont été trouvés":" a été trouvé"} !", greyColor, 4, padding: 5,overflow: false));
      liste.add(SizedBox(height: 40,));
      for(Teacher teacher in tearchersFound)
        myTeachers.add(TeacherCard(teacher, "Home${teacher.id}"));
      
      liste.add(Wrap(
        spacing: 15,
        runSpacing: 10,
        children: myTeachers,
      ));
    }
    else
      liste.add(CustomText("Aucun enseignant n'a été trouvé !", greyColor, 4, padding: 5,overflow: false));
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