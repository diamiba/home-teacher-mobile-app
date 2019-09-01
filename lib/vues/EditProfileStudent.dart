import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';

class EditProfileStudentPage extends StatefulWidget {
  EditProfileStudentPage();
  @override
  _EditProfileStudentPageState createState() => _EditProfileStudentPageState(currentUser);
}

class _EditProfileStudentPageState extends State<EditProfileStudentPage> {
  Student student;
  int mark, maxMark=5;
  String level, quarter;
  List<String> studentquarterList = List.from(SearchOptions.quarterList);
  TextEditingController school;
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyUpdate = GlobalKey<FormState>();
  String _erreurText = "";
  bool _isLoading = false;

  _EditProfileStudentPageState(this.student){
    studentquarterList.remove(SearchOptions.quarterList.first);
    level = (this.student.level != null)?this.student.level:SearchOptions.levelList.first;
    quarter = (this.student.quarter != null)?this.student.quarter:studentquarterList.first;
    school = TextEditingController(text: this.student.school);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomModalProgressHUD(_isLoading,
    CustomBody(
      Container(),
      children: <Widget>[
        SliverToBoxAdapter(
          child: Center(
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
                        CustomDropDown("Dans quel quartier habitez-vous ?", "Exemple : Pissy", quarter, studentquarterList, (String selection) {if (selection != quarter) setState((){this.quarter = selection;});}),
                        CustomDropDown("Quelle est votre classe actuelle ?", "Exemple : 6 ème", level, SearchOptions.levelList, (String selection) {if (selection != level) setState((){this.level = selection;});}),
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
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
              ),
          ),
        ),
      ],
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
    FocusScope.of(context).requestFocus(FocusNode());
    setState(()=>_erreurText = "");
    if (!_formKeyUpdate.currentState.validate()) return;

    if(quarter == student.quarter && level == student.level && school.text == student.school)
      setState((){
        _erreurText = "Vous n'avez fait aucune modification";
      });
    else{
      setState(() =>  _isLoading = true);
      Map<String,dynamic> body = {
        'SchoolLevel': level,
        'Quarter': quarter,
        'CurrentSchool': school.text,
      };
      RequestType reponse = await updateCurrentUserSpecialInfos(body, isStudent: true);
      if(reponse.getisSuccess){
        setState((){
          _isLoading = false;
          showNotification("Changements enregistrés", _scaffoldState.currentState);
        });
        this.student.quarter = quarter;
        this.student.level = level;
        this.student.school = school.text;
      }
      else{
        setState((){
          _isLoading = false;
          showNotification(reponse.geterrorMessage, _scaffoldState.currentState);
        });
      }
    }
  }
}
