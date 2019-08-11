import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';
import 'package:home_teacher/Utile.dart';

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
  List<String> studentDistrictList = List.from(districtList);
  TextEditingController school;
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyUpdate = GlobalKey<FormState>();
  String _erreurText = "";
  bool _isLoading = false;

  _EditProfileStudentPageState(this.student){
    studentDistrictList.remove(districtList.first);
    level = (this.student.level != null)?this.student.level:levelList.first;
    district = (this.student.district != null)?this.student.district:studentDistrictList.first;
    school = TextEditingController(text: this.student.school);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomModalProgressHUD(_isLoading,
    CustomBody(
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
                Form(
                  key: _formKeyUpdate,
                  child:Column(
                    children: <Widget>[
                      CustomDropDown("Dans quel quartier habitez-vous ?", "Exemple : Pissy", district, studentDistrictList, (String selection) {if (selection != district) setState((){this.district = selection;});}),
                      CustomDropDown("Quelle est votre classe actuelle ?", "Exemple : 6 ème", level, levelList, (String selection) {if (selection != level) setState((){this.level = selection;});}),
                      CustomTextField("Où étudiez-vous ?", "Exemple : Lycée Phillipe Zinda Kaboré", TextInputType.text, this.school,
                      textInputAction: TextInputAction.done,
                      validator: (String value) {
                        if (value.isEmpty) return "Veuillez saisir votre école";
                      },
                      onFieldSubmited: (pass) async {
                         _update();
                      },
                      ),      
                    ],
                  )
                ),
                _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center),
                CustomButton("ENREGISTER", mainColor, 
                  ()async=>_update(),
                  margin: const EdgeInsets.only(top: 25.0,),
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
      scaffoldState: _scaffoldState,
    ));
  }


  _update() async {
    print("update student infos");
    setState(()=>_erreurText = "");
    if (!_formKeyUpdate.currentState.validate()) return;

    if(district == student.district && level == student.level && school.text == student.school)
      setState((){
        _erreurText = "Vous n'avez fait aucune modification";
      } 
      );
    else{
      setState((){
        _isLoading = true;
      } 
      );
      print("school: ${school.text}");
      await Future.delayed(
        Duration(seconds: 2)
      );
      setState((){
        _isLoading = false;
        showNotification("Changements enregistrés", _scaffoldState.currentState);
        //_erreurText = "email inexistant";
      } 
      );
    }
  }
}
