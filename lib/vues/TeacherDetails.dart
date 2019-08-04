import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:home_teacher/vues/ShowPhoto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class TeacherDetailsPage extends StatefulWidget {
  Teacher _teacher;
  TeacherDetailsPage(this._teacher);
  @override
  _TeacherDetailsPageState createState() => _TeacherDetailsPageState();
}

class _TeacherDetailsPageState extends State<TeacherDetailsPage> {
  int mark, maxMark=5;
  bool isFavorite = false;
  Widget image;
  var _scaffoldState = GlobalKey<ScaffoldState>();

  _TeacherDetailsPageState(){
    isFavorite = isFavoriteTeacher();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      Center(
        child: CustomCard(
          Column(
            children: <Widget>[
              Hero(
                tag: this.widget._teacher.id,
                transitionOnUserGestures: true,
                child: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: this.widget._teacher.profilePicture,
                    imageBuilder: (context, imageProvider){
                      this.image = Image(image: imageProvider, fit: BoxFit.contain);
                      return ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image(image: imageProvider),
                      );
                    },
                    placeholder: (context, url) => ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: CircularProgressIndicator(
                          backgroundColor: mainLightColor,
                        ),
                      ),
                    errorWidget: (context, url, error){
                      this.image = Image.asset("images/profil_picture.png", fit: BoxFit.contain);
                      print(error);
                      return ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Image.asset("images/profil_picture.png", width: 150,),
                      );
                    } 
                  ),
                  onTap: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)=> ShowPhoto(image: this.image, id: this.widget._teacher.id,))
                    );
                  }
                ),
              ),
              CustomText("${this.widget._teacher.firstname} ${this.widget._teacher.lastname.toUpperCase()}", darkColor, 3, bold: true,padding: 5,),
              CustomText(this.widget._teacher.job, mainColor, 4, italic: true,padding: 2,),
              setStars(this.widget._teacher.mark, this.widget._teacher.numberOfVotes),
              CustomText(this.widget._teacher.description, greyColor, 5, italic: true,textAlign: TextAlign.center,padding: 25, lineSpacing: 1.2,),
              Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
              infos(Icons.phone, "NUMERO DE TELEPHONE", this.widget._teacher.phoneNumber, this.call),
              infos(Icons.mail, "ADRESSE MAIL", this.widget._teacher.mail, sendMail),
              infos(Icons.place, "ADRESSE", this.widget._teacher.adress, null),
              infos(Icons.school, "FORMATION", this.widget._teacher.education, null),
              Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
              listToWidget("CLASSES ENSEIGNEES", this.widget._teacher.levelTeached),
              listToWidget("QUARTIERS ENSEIGNEES", this.widget._teacher.districtTeached),
              Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
              CustomButton("NOTER", mainColor, ()=>_noter(),margin: EdgeInsets.symmetric(vertical: 10),),
              isFavorite?CustomButton("RETIRER DES FAVORIS", redColor, ()=>_retirerFavoris(this.widget._teacher),margin: EdgeInsets.symmetric(vertical: 10),)
              :CustomButton("AJOUTER A MES FAVORIS", mainColor, ()=>_ajouterFavoris(this.widget._teacher),margin: EdgeInsets.symmetric(vertical: 10),)
            ],
            ),
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          ),
      ),
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
      scaffoldState: _scaffoldState,
    );
  }

  Widget setStars(int nbStars, int numberOfVotes){
    List <Widget> liste = List();
    for(int i=0; i<maxMark; i++)
      liste.add(Icon(i<nbStars?Icons.star:Icons.star_border, color: mainColor, size: 20.0,));
    liste.add(Text(" ($numberOfVotes)", style: TextStyle(color: mainColor, fontSize: size3),));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: liste,
    );
  }

  Widget infos(IconData icon, String title, String info, Function f){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(flex: 1,),
              Icon(icon, color: greyColor, size: size6,),
              CustomText(title, greyColor, 6, padding: 2,),
              Spacer(flex: 1,),
            ],
          ),
          GestureDetector(
            child: CustomText(info, darkColor, 4, bold: true, padding: 0),
            onTap: f,
          ),
        ],
      ),
    );
  }

  Widget listToWidget(String title, List<String> liste){
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(title, greyColor, 6, padding: 10,),
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: liste.map<Widget>(
                (String el) => Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  constraints: BoxConstraints(minWidth: 70),
                  child: CustomText(el, darkColor, 5, padding: 0, bold: true,),
                  decoration: BoxDecoration(
                    color: mainLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                )
              ).toList(),
            )
          ],
        ),
      ),
    );
  }


  bool isFavoriteTeacher(){
    return true;
  }
  _retirerFavoris(Teacher teacher) async {
    bool reponse = await demandeConfirmation(context, "Voulez vous vraiment retirer ${teacher.firstname} de vos favoris?");
    if(!reponse) return;
    
    await Future.delayed(
      Duration(seconds: 1)
    );
    print("remove ${teacher.firstname} from favoris");
    setState(()=>isFavorite = false); 
  }
  _ajouterFavoris(Teacher teacher) async {
    await Future.delayed(
      Duration(seconds: 2)
    );
    print("add ${teacher.firstname} to favoris");
    setState(()=>isFavorite = true); 
  }

  _noter(){
    showNotification("Not implemented yet :p", _scaffoldState.currentState);
  }




  call() async {
    String url = 'tel:${this.widget._teacher.phoneNumber}';
    if (await canLaunch(url)) {
      print("appel");
      await launch(url);
    } else {
      print("erreur appel");
    }
  }

  sendMail() async {
    String url = 'mailto:${this.widget._teacher.mail}?subject=HomeTeacher';
    if (await canLaunch(url)) {
      print("sendMail");
      await launch(url);
    } else {
      print("erreur sendMail");
    }
  }
}