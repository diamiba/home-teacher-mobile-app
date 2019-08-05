import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class ExplorerPage extends StatefulWidget {
  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  bool isMostRecent = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomText("Explorer",whiteColor, 1, bold: true, padding: 0,),
          ),
          SizedBox(
            height: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
          ),
          SizedBox(height: 50,),
          Container(
            width: MediaQuery.of(context).size.width,
            color: lightGreyColor,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        color: (this.isMostRecent?whiteColor:mainColor),
                        child: CustomText("Les plus aimés", (this.isMostRecent?greyColor:whiteColor), 4, bold: true, padding: 0,),
                      ),
                      onTap: (){
                        print("les plus aimés");
                        if(this.isMostRecent)
                          setState(() {
                          this.isMostRecent = !this.isMostRecent; 
                          });
                      },
                    ),
                    GestureDetector(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        color: (this.isMostRecent?mainColor:whiteColor),
                        child: CustomText("Derniers ajouts", (this.isMostRecent?whiteColor:greyColor), 4, bold: true, padding: 0,),
                      ),
                      onTap: (){
                        print("Derniers ajouts");
                        if(!this.isMostRecent)
                          setState(() {
                          this.isMostRecent = !this.isMostRecent; 
                          });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  explorerCard(teachers, 0), 
                  explorerCard(teachers, 1),                
                ],)
                               
              ],
            )
          ),
        ],
      ),
      pageName: "EXPLORER",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
    );
  }




  Widget explorerCard(List<Teacher> tearchersFound, int n){
    List <Widget> liste = List();

    for(Teacher teacher in tearchersFound)
      liste.add(TeacherCard(teacher, "Explorer$n${teacher.id}"));
    return animateContent(
      Wrap(
        spacing: 15,
        runSpacing: 10,
        children: liste,
      ),
      n
    );
  }


  Widget animateContent(Widget child, int index){
    double phoneWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      margin:  (index==1)?EdgeInsets.only(left:5):EdgeInsets.only(right:5),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOutCirc,
      //height: (MediaQuery.of(context).size.height)-((index==0)? (isMostRecent ? 200 : 290):(!isMostRecent ? 200 : 290)),
      width: (index==1)? (isMostRecent ? (phoneWidth-30) : 0):(!isMostRecent ? (phoneWidth-30) : 0),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        reverse: (index==1)?false:true,
        scrollDirection: Axis.horizontal,
        child: Container(child: child, width: phoneWidth-30, alignment: Alignment.topCenter,)
      ),
    );
  }
}