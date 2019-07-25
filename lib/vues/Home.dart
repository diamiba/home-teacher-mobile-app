import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> districtList = ["Toute la ville", "Pissy", "Goughin"];
  String selectedDistrict;
  List<String> subjectList = ["Mathématiques", "Physique", "Informatique"];
  String selectedSubject;
  List<String> levelList = ["6ème", "5ème", "4ème"];
  String selectedLevel;

  _HomePageState(){
    selectedDistrict = districtList[0];
    selectedSubject = subjectList[0];
    selectedLevel = levelList[0];
  }

  @override
  Widget build(BuildContext context) {
  double height = (MediaQuery.of(context).size.height-530);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(isConnected: true,),
          CustomBody(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText("Home-Teacher",whiteColor, 0, bold: true, padding: 5,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText("Nos professeurs n'attendent que vous.",whiteColor, 1, padding: 0,),
                ),
                SizedBox(height: 60,),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 30.0, right: 30.0),
                  color: whiteColor,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      choiceElement(this.districtList, this.selectedDistrict, (String selection) {if (selection != this.selectedDistrict) setState((){this.selectedDistrict = selection;});}),
                      choiceElement(this.subjectList, this.selectedSubject, (String selection) {if (selection != this.selectedSubject) setState((){this.selectedSubject = selection;});}),
                      choiceElement(this.levelList, this.selectedLevel, (String selection) {if (selection != this.selectedLevel) setState((){this.selectedLevel = selection;});}, isLast: true),
                    ],
                  ),
                ),
                Container(
                  color: mainColor,
                  child: CustomButton("CHERCHER !", mainColor, ()=>print("CHERCHER !")),
                ),
                SizedBox(height: height<60?60:height),
                Center(
                  child: FlatButton.icon(
                    icon: Icon(Icons.arrow_drop_down, color: whiteColor, size: 50,),
                    label: CustomText("EXPLORER", whiteColor, 1, bold: true,),
                    onPressed: ()=>print('Explorer'),
                  ),
                ),
              ],
            ),
            isConnected: true,
            horizontalPadding: 0,
          )
        ],
      ),
    );
  }

  Widget choiceElement(List<String> liste, String value, Function fonction, {bool isLast = false}) {
    final List<DropdownMenuItem<String>> items = liste.map(
      (String val) =>
          DropdownMenuItem<String>(
            value: val, 
            child: CustomText(val, darkColor, 1, padding: 0,),
        )).toList();
    return Card(
      elevation: 0,
      child: DropdownButton<String>(
        style: TextStyle(fontSize: size1, color: darkColor),
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
}