import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

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
  FocusNode jobFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyUpdate = GlobalKey<FormState>();
  String _erreurText = "";
  bool _isLoading = false;

  _EditProfileTeacherPageState(this.teacher){
    levelTeached = this.teacher.levelTeached!=null?List.from(this.teacher.levelTeached):List();
    districtTeached = this.teacher.districtTeached!=null?List.from(this.teacher.districtTeached):List();
    subjectTeached = this.teacher.subjectTeached!=null?List.from(this.teacher.subjectTeached):List();
    education = TextEditingController(text: this.teacher.education);
    job = TextEditingController(text: this.teacher.job);
    description = TextEditingController(text: this.teacher.description);
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
                  child: CustomText("Modifier mes informations d'enseignant", darkColor, 3, bold: true),
                ),
                Form(
                  key: _formKeyUpdate,
                  child:Column(
                    children: <Widget>[
                      CustomDropDown("Dans quel(s) quartier(s) enseignez-vous ?", "Exemple : Pissy", selected, districtList, (String selection) {if (!this.districtTeached.contains(selection)) setState((){this.districtTeached.add(selection);});}),
                      MyChips((this.districtTeached)),
                      CustomDropDown("Quelle(s) discipline(s) enseignez-vous ?", "Exemple : Mathématiques", selected, subjectList, (String selection) {if (!this.subjectTeached.contains(selection)) setState((){this.subjectTeached.add(selection);});}),
                      MyChips(this.subjectTeached),
                      CustomDropDown("Quelle(s) classe(s) enseignez-vous ?", "Exemple : 6 ème, 5 ème", selected, levelList, (String selection) {if (!this.levelTeached.contains(selection)) setState((){this.levelTeached.add(selection);});}),
                      MyChips(this.levelTeached),
                      CustomTextField("Qu'avez-vous étudié ?", "Exemple : Baccalauréat", TextInputType.text, education,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre dernier diplôme";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(jobFocusNode));
                        },
                      ),
                      CustomTextField("Quel est votre métier actuel?", "Exemple : Développeur informatique", TextInputType.text, job,
                        focus: jobFocusNode,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre métier actuel";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(descriptionFocusNode));
                        },
                      ),
                      CustomTextField("Un petit résumé sur vous (Max : 200 caractères)", "", TextInputType.text, description, multiline: true,
                        textInputAction: TextInputAction.done,
                        textCapitalization: TextCapitalization.sentences,
                        focus: descriptionFocusNode,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir un résumé sur vous";
                        },
                        onFieldSubmited: (pass) async {
                          _update();
                        },
                      ),   
                    ],
                  )
                ),
                _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center,),
                CustomButton("ENREGISTER", mainColor, 
                  () async=> _update(),
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
    print("update teacher infos");
    setState(()=>_erreurText = "");
    if (!_formKeyUpdate.currentState.validate()) return;

    if(districtTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins un quartier\n où vous enseigner");
    else if(subjectTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins une matière enseignée");
    else if(levelTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins une classe enseignée");
    else if(compareList(levelTeached, teacher.levelTeached) && compareList(districtTeached, teacher.districtTeached) && 
          compareList(subjectTeached, teacher.subjectTeached) && job.text==teacher.job && 
          education.text==teacher.education && description.text==teacher.description)
      setState(()=>_erreurText = "Vous n'avez fait aucune modification");
    else{
      setState((){
        _isLoading = true;
        _erreurText = "";
      } 
      );
      //print("school: ${school.text}");
      await Future.delayed(Duration(seconds: 2));
      setState((){
        _isLoading = false;
        showNotification("Changements enregistrés", _scaffoldState.currentState);
        //_erreurText = "email inexistant";
      } 
      );
    }
  }

  bool compareList(List<String>l1, List<String>l2){
    if(l1==null || l2==null) return false;
    if(l1.length != l2.length) return false;
    for(String e in l1)
      if(!l2.contains(e)) return false;
    return true;
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