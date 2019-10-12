import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class EditProfileTeacherPage extends StatefulWidget {
  EditProfileTeacherPage();
  @override
  _EditProfileTeacherPageState createState() => _EditProfileTeacherPageState(currentUser);
}

class _EditProfileTeacherPageState extends State<EditProfileTeacherPage> {
  Teacher teacher;
  //int mark, maxMark=5;
  List<String> levelTeached, quarterTeached, subjectTeached;
  String selected;
  TextEditingController education, job, description;
  FocusNode jobFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyUpdate = GlobalKey<FormState>();
  String _erreurText = "";
  bool _isLoading = false;

  _EditProfileTeacherPageState(this.teacher){
    levelTeached = (this.teacher.levelTeached!=null && this.teacher.levelTeached.isNotEmpty)?List.from(this.teacher.levelTeached):List();
    quarterTeached = (this.teacher.quarterTeached!=null && this.teacher.quarterTeached.isNotEmpty)?List.from(this.teacher.quarterTeached):List();
    subjectTeached = (this.teacher.subjectTeached!=null && this.teacher.subjectTeached.isNotEmpty)?List.from(this.teacher.subjectTeached):List();
    education = TextEditingController(text: this.teacher.education);
    job = TextEditingController(text: this.teacher.job);
    description = TextEditingController(text: this.teacher.description);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomModalProgressHUD(_isLoading,
    CustomBody(
      children: [
         SliverToBoxAdapter(
          child: Center(
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
                        CustomDropDown("Dans quel(s) quartier(s) enseignez-vous ?", "Exemple : Pissy", selected, SearchOptions.quarterList, (String selection) {if (!this.quarterTeached.contains(selection)) setState((){this.quarterTeached.add(selection);});}),
                        MyChips((this.quarterTeached), updateButton),
                        CustomDropDown("Quelle(s) discipline(s) enseignez-vous ?", "Exemple : Mathématiques", selected, SearchOptions.subjectList, (String selection) {if (!this.subjectTeached.contains(selection)) setState((){this.subjectTeached.add(selection);});}),
                        MyChips(this.subjectTeached, updateButton),
                        CustomDropDown("Quelle(s) classe(s) enseignez-vous ?", "Exemple : 6 ème, 5 ème", selected, SearchOptions.levelList, (String selection) {if (!this.levelTeached.contains(selection)) setState((){this.levelTeached.add(selection);});}),
                        MyChips(this.levelTeached, updateButton),
                        CustomTextField("Qu'avez-vous étudié ?", "Exemple : Audit et controle de gestion", TextInputType.text, education,
                          validator: (String value) {
                            if (value.isEmpty) return "Veuillez saisir votre dernier diplôme";
                            return null;
                          },
                          onFieldSubmited: (String value) {
                            setState(()=>FocusScope.of(context).requestFocus(jobFocusNode));
                          },
                        ),
                        CustomTextField("Quel est votre métier actuel?", "Exemple : Développeur informatique", TextInputType.text, job,
                          focus: jobFocusNode,
                          validator: (String value) {
                            if (value.isEmpty) return "Veuillez saisir votre métier actuel";
                            return null;
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
                            return null;
                          },
                          onFieldSubmited: (pass) async {
                            if(_haveNewValues())
                              _update();
                          },
                        ),   
                      ],
                    )
                  ),
                  _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center,),
                  CustomButton("ENREGISTER", mainColor, 
                    _haveNewValues()
                      ? () async=> _update()
                      : null,
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

  bool _haveNewValues(){
    return !(compareList(levelTeached, teacher.levelTeached) && compareList(quarterTeached, teacher.quarterTeached) && 
          compareList(subjectTeached, teacher.subjectTeached) && job.text==teacher.job && 
          education.text==teacher.education && description.text==teacher.description);
  }

  //mettre à jour le boutton lorsqu'on enlève un élément dans les chips
  updateButton(){
    if(_haveNewValues()) setState(() {});
  }

  _update() async {
    print("update teacher infos");
    FocusScope.of(context).requestFocus(FocusNode());
    setState(()=>_erreurText = "");
    if (!_formKeyUpdate.currentState.validate()) return;

    if(quarterTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins un quartier\n où vous enseigner");
    else if(subjectTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins une matière enseignée");
    else if(levelTeached.isEmpty)
      setState(()=>_erreurText = "Vous devez choisir aumoins une classe enseignée");
    else if(!_haveNewValues())
      setState((){});
    else{
      setState(() => _isLoading = true);
      Map<String,dynamic> body = {
        'TeachedLevel': levelTeached,
        'TeachedQuarter': quarterTeached,
        'TeachedSubject': subjectTeached,
        'StudiesDomain': education.text,
        'CurrentJob': job.text,
        'LilResume': description.text,
      };
      RequestType reponse = await updateCurrentUserSpecialInfos(body, isStudent: false);
      if(reponse.getisSuccess){
        setState((){
          _isLoading = false;
          showNotification("Changements enregistrés", _scaffoldState.currentState);
        });
        this.teacher.levelTeached = levelTeached;
        this.teacher.quarterTeached = quarterTeached;
        this.teacher.subjectTeached = subjectTeached;
        this.teacher.education = education.text;
        this.teacher.job = job.text;
        this.teacher.description = description.text;
      }
      else{
        setState((){
          _isLoading = false;
          showNotification(reponse.geterrorMessage, _scaffoldState.currentState);
        });
      }
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
  Function update;
  MyChips(this.allElements, this.update);
  @override
  _MyChipsState createState() => _MyChipsState(this.allElements);
}

class _MyChipsState extends State<MyChips> {
  List<String> allElements;
  _MyChipsState(this.allElements);

  void _removeMaterial(String name) {
    allElements.remove(name);
    this.widget.update();
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
        reverse: true,
        padding: EdgeInsets.only(bottom: 15),
        scrollDirection: Axis.horizontal,
        child: Row(children: chips),
      ),
    );
  }
}