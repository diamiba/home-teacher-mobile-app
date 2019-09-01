import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/ShowPhoto.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class TeacherDetailsPage extends StatefulWidget {
  Teacher _teacher;
  String _heroTag;
  bool isFromFavorisPage;
  int favoriteId;
  TeacherDetailsPage(this._teacher, this._heroTag, {this.isFromFavorisPage = false, this.favoriteId});
  @override
  _TeacherDetailsPageState createState() => _TeacherDetailsPageState(this._teacher, this._heroTag, isFavorite: this.isFromFavorisPage, favoriteId: this.favoriteId);
}

class _TeacherDetailsPageState extends State<TeacherDetailsPage> {
  String _heroTag;
  Teacher _teacher;
  int mark=0, favoriteId;
  bool isFavorite = false, _isLoading = false, _dataDownloading = true;
  Widget image;
  var _scaffoldState = GlobalKey<ScaffoldState>();

  _TeacherDetailsPageState(this._teacher, this._heroTag,{ this.isFavorite = false, this.favoriteId}){
    loadData(this.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset("images/favorite.gif", fit: BoxFit.fitWidth,),
      ),
      child: CustomBody(Container(),
        children: <Widget>[
          SliverToBoxAdapter(
            child: Center(
              child: CustomCard(
                Column(
                  children: <Widget>[
                    Hero(
                      tag: this._heroTag,
                      transitionOnUserGestures: true,
                      child: GestureDetector(
                        child: Container(
                          constraints: BoxConstraints(minWidth: 150, maxWidth: 250),
                          child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: this._teacher.profilePicture,
                              imageBuilder: (context, imageProvider){
                                this.image = Image(image: imageProvider, fit: BoxFit.contain);
                                return Image(image: imageProvider);
                              },
                              placeholder: (context, url) => Container(
                                  width: 150,
                                  height: 150,
                                  padding: const EdgeInsets.all(50),
                                  //borderRadius: BorderRadius.all(Radius.circular(20)),
                                  child: CircularProgressIndicator(
                                    backgroundColor: mainLightColor,
                                  ),
                                ),
                              errorWidget: (context, url, error){
                                this.image = Image.asset("images/profil_picture.png", fit: BoxFit.contain);
                                print(error);
                                return Image.asset("images/profil_picture.png");
                              } 
                            ),
                          ),
                        ),
                        onTap: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context)=> ShowPhoto(image: this.image, heroTag: this._heroTag,))
                          );
                        }
                      ),
                    ),
                    CustomText("${this._teacher.firstname} ${this._teacher.lastname.toUpperCase()}", darkColor, 3, bold: true,padding: 5,textAlign: TextAlign.center,),
                    CustomText(this._teacher.job, mainColor, 4, italic: true,padding: 2,textAlign: TextAlign.center,),
                    setStars(this._teacher.mark, this._teacher.numberOfVotes),
                    CustomText(this._teacher.description, greyColor, 5, italic: true,textAlign: TextAlign.center,padding: 25, lineSpacing: 1.2,overflow: false,),
                    Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
                    infos(Icons.phone, "NUMERO DE TELEPHONE", this._teacher.phoneNumber, this.call, waitForData: true),
                    infos(Icons.mail, "ADRESSE MAIL", this._teacher.mail, sendMail, waitForData: true),
                    infos(Icons.place, "ADRESSE", this._teacher.fullAdress, null, waitForData: true),
                    infos(Icons.school, "FORMATION", this._teacher.education, null),
                    Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
                    listToWidget("CLASSES ENSEIGNEES", this._teacher.levelTeached),
                    SizedBox(height: 10,),
                    listToWidget("QUARTIERS ENSEIGNEES", this._teacher.quarterTeached),
                    Container(color: greyColor, height: 0.3,margin: EdgeInsets.symmetric(vertical: 10),),
                    CustomButton("NOTER", mainColor, ()=>_noter(),margin: EdgeInsets.symmetric(vertical: 10),),
                    isFavorite?CustomButton("RETIRER DES FAVORIS", redColor, ()=>_retirerFavoris(this._teacher),margin: EdgeInsets.symmetric(vertical: 10),)
                    :CustomButton("AJOUTER A MES FAVORIS", mainColor, ()=>_ajouterFavoris(this._teacher),margin: EdgeInsets.symmetric(vertical: 10),)
                  ],
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                ),
            ),
          ),
        ],
        isConnected: true,
        horizontalPadding: 0,
        bottomPadding: 0,
        haveBackground: false,
        scaffoldState: _scaffoldState,
      ),

    );
  }

  Widget setStars(int nbStars, int numberOfVotes){
    if(nbStars==null) nbStars = 0;
    if(numberOfVotes==null) numberOfVotes = 0;
    nbStars = (nbStars>=0 && nbStars<=maxMark)?nbStars:0;
    List <Widget> liste = List();
    for(int i=0; i<maxMark; i++)
      liste.add(Icon(i<nbStars?Icons.star:Icons.star_border, color: mainColor, size: 20.0,));
    liste.add(Text(" ($numberOfVotes)", style: TextStyle(color: mainColor, fontSize: size3),));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: liste,
    );
  }

  Widget infos(IconData icon, String title, String info, Function f, {bool waitForData = false}){
    if(!_dataDownloading && info==null){
      info = "----";
      f = null;
    }
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
          (waitForData&&_dataDownloading)?
          Padding(child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)), padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),):
          (f!=null)?
          FlatButton(
            child: CustomText(info, darkColor, 4, bold: true, padding: 0, textAlign: TextAlign.center,),
            onPressed: f,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: lightGreyColor)
            ),
            splashColor: mainHighlightColor,
          )
          :CustomText(info, darkColor, 4, bold: true, padding: 0, textAlign: TextAlign.center,),
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
                  child: CustomText(el, darkColor, 5, padding: 0, ),
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


  Future loadData(bool isFromFavorisPage) async {
    if(isFromFavorisPage){
      _dataDownloading = false;
      int note = 0;
      RequestType rate = await currentUserRate(this._teacher.id);
      if(rate.getisSuccess)
        note = rate.getdata;
      this.mark = note;
    }
    else{
      bool isFav = false;
      int note = 0;
      RequestType teacherDetail = await teacherDetails(this._teacher.id);
      RequestType rate = await currentUserRate(this._teacher.id);

      if(teacherDetail.getisSuccess){
        Teacher nouveau = Teacher.withDetail(teacherDetail.getdata);
        this._teacher = nouveau;
        isFav = this._teacher.isFavorite;
      }
      if(rate.getisSuccess)
        note = rate.getdata;
      this.isFavorite = isFav;
      this.mark = note;
      setState(() { _dataDownloading = false; });
    }
  }



  _retirerFavoris(Teacher teacher) async {
    bool reponse = await demandeConfirmation(context, "Voulez vous vraiment retirer ${teacher.firstname} de vos favoris?", icon: Icons.favorite_border);
    if(!reponse) return;
    
    RequestType delete = await deleteFavorite(this.favoriteId);
    if(delete.getisSuccess){
      this.favoriteId = null;
      setState(()=>isFavorite = false); 
    }
    else{
      showNotification(delete.geterrorMessage, _scaffoldState.currentState);
    }
  }

  _ajouterFavoris(Teacher teacher) async {
    setState(() => _isLoading = true); 
    RequestType add = await addFavorite(teacher.id);
    if(add.getisSuccess){
      this.favoriteId = add.getdata["id"];
      setState((){
        isFavorite = true;
        _isLoading = false;
      }); 
    }
    else{
      setState(() => _isLoading = false); 
      showNotification(add.geterrorMessage, _scaffoldState.currentState);
    }
  }

  _noter(){
    showDialog<int>(
      context: context,
      builder: (BuildContext context)=>SimpleDialog(
        children: <Widget>[
          NoteTeacherWidget(this.mark)
        ],
        backgroundColor: whiteColor.withOpacity(1),
        elevation: 2,
      )
    ).then(
      (note) async {
        if(note!=null && note!=this.mark){
          RequestType rating = await rateTeacher(note, this._teacher.id);
          if(rating.getisSuccess){
            //mise a jour du nombre total et de la moyenne des note du prof
            int newTotal, newMoyenne;
            if(this.mark==0){ //l'utilisateur n'avait donné aucune note
              newTotal = this._teacher.numberOfVotes + 1;
              newMoyenne = (((this._teacher.mark * this._teacher.numberOfVotes) + note)/newTotal).round();
            }
            else{ //l'utilisateur avait déja donné une note
              newTotal = this._teacher.numberOfVotes;
              newMoyenne = (((this._teacher.mark * this._teacher.numberOfVotes) + (note-this.mark))/newTotal).round();
            }
            this.mark = note;
            setState(() {
              this._teacher.numberOfVotes = newTotal; 
              this._teacher.mark = newMoyenne;
            });
          }
          else
            showNotification(rating.geterrorMessage, _scaffoldState.currentState);
        }
      }
    );
  }




  call() async {
    String url = 'tel:${this._teacher.phoneNumber}';
    if (await canLaunch(url)) {
      print("appel");
      await launch(url);
    } else {
      print("erreur appel");
    }
  }

  sendMail() async {
    String url = 'mailto:${this._teacher.mail}?subject=HomeTeacher';
    if (await canLaunch(url)) {
      print("sendMail");
      await launch(url);
    } else {
      print("erreur sendMail");
    }
  }
}