import 'package:flutter/material.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileStudent.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/vues/Favoris.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/TeacherDetails.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:cached_network_image/cached_network_image.dart';



class CustomCard extends StatelessWidget {
  Widget child;
  EdgeInsetsGeometry margin, padding;
  CustomCard(this.child, {this.margin = const EdgeInsets.all(0), this.padding = const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0)});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.margin,
      padding: this.padding,
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [BoxShadow(blurRadius: 3, color: greyColor.withOpacity(0.5), spreadRadius: 0)],
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: child,
    );
  }
}

class BigLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/logo.png"),
        ),
      ),
    );
  }
}
class CustomText extends StatelessWidget {
  String text;
  Color color = whiteColor;
  bool bold, underline, italic, overflow;
  int level = 1;
  double padding, lineSpacing;
  TextAlign textAlign;
  CustomText(this.text, this.color, this.level,{this.padding = 15, this.lineSpacing = 1, this.bold = false, this.underline = false, this.overflow = false, this.italic = false, this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    double size;
    switch (level) {
      case 1: size = size1;
        break;
      case 2: size = size2;
        break;
      case 3: size = size3;
        break;
      case 4: size = size4;
        break;
      case 5: size = size5;
        break;
      case 6: size = size6;
        break;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: this.padding, horizontal: 5.0),
      child: Text(
        text,
        style: TextStyle(color: color,
          fontSize: size,
          fontWeight: bold?FontWeight.bold:FontWeight.normal,
          fontStyle: italic?FontStyle.italic:FontStyle.normal,
          decoration: underline?TextDecoration.underline:TextDecoration.none,
          height: lineSpacing,
        ),
        textAlign: textAlign,
        overflow: overflow?TextOverflow.ellipsis:TextOverflow.visible,
        ),
    );
  }
}

class CustomButton extends StatelessWidget {
  String text;
  Color color = whiteColor;
  Function onPressed;
  bool shadow;
  EdgeInsetsGeometry margin;
  CustomButton(this.text, this.color, this.onPressed, {this.shadow = true, this.margin = const EdgeInsets.all(0)});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(0),
      height: 40,
      decoration: BoxDecoration(
        boxShadow:this.shadow?[BoxShadow(blurRadius: 2, color: darkColor.withOpacity(0.7), spreadRadius: 0)]:null,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[CustomText(text, whiteColor, 4, padding: 0, overflow: true,),],
        ),
        color: color,
        onPressed: this.onPressed,
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  String text, hintText, prefixe;
  TextInputType type;
  TextEditingController controller;
  Function validator, onFieldSubmited;
  bool obscure, multiline;
  FocusNode focus;
  TextCapitalization textCapitalization;
  TextInputAction textInputAction;
  CustomTextField(this.text, this.hintText,this.type, this.controller, {this.obscure = false, this.multiline = false, this.prefixe, this.validator, this.onFieldSubmited, this.focus, this.textCapitalization = TextCapitalization.none, this.textInputAction = TextInputAction.next});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;
  InputDecoration decoration;
  @override
  Widget build(BuildContext context) {
    decoration = InputDecoration(
      contentPadding: EdgeInsets.only(top: 16.5, bottom: 16.5),
      prefixIcon: this.widget.prefixe==null?null:
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.centerLeft,
          child: CustomText(this.widget.prefixe, darkColor, 5, padding: 0,),
        ),
      prefixStyle: TextStyle(fontSize: size5, color: darkColor),
      alignLabelWithHint: true,
      hintText: this.widget.hintText,
      hintStyle: TextStyle(fontSize: size5, color: greyColor),
      errorStyle: TextStyle(fontSize: size6, color: redColor),
      border: InputBorder.none,
      suffixIcon: !this.widget.obscure?null:
        GestureDetector(
          child: Icon(isHidden?Icons.visibility_off:Icons.visibility),
          onTap: (){
            setState(() {
            isHidden = ! isHidden; 
            });
          },
        ),
    ); 
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(this.widget.text, darkColor, 5, padding: 0,),
        Stack(
          children: <Widget>[
            Container(
              height: this.widget.multiline?185:48,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: lightGreyColor,
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
              ),
              padding: EdgeInsets.only(top:0.0, bottom:0.0, left: this.widget.multiline?15:30, right: this.widget.multiline?15:0),
              child: this.widget.multiline?TextFormField(
                textAlign: TextAlign.left,
                cursorColor: mainColor,
                controller: this.widget.controller,
                style: TextStyle(fontSize: size5, color: darkColor),
                keyboardType: this.widget.type,
                textCapitalization: this.widget.textCapitalization,
                textInputAction: this.widget.textInputAction,
                obscureText: (this.widget.obscure && isHidden),
                maxLines: 10,
                maxLength: 200,
                maxLengthEnforced: true,
                decoration: decoration,
                onFieldSubmitted: this.widget.onFieldSubmited,
                validator: this.widget.validator,
                focusNode: this.widget.focus,
              ):
              TextFormField(
                textAlign: TextAlign.left,
                cursorColor: mainColor,
                controller: this.widget.controller,
                style: TextStyle(fontSize: size5, color: darkColor),
                keyboardType: this.widget.type,
                textCapitalization: this.widget.textCapitalization,
                textInputAction: this.widget.textInputAction,
                obscureText: (this.widget.obscure && isHidden),
                decoration: decoration,
                onFieldSubmitted: this.widget.onFieldSubmited,
                validator: this.widget.validator,
                focusNode: this.widget.focus,
              ),
            )
          ],
        ),
      ],),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  String title, value, hintText;
  List<String> liste;
  Function fonction;
  CustomDropDown(this.title, this.hintText, this.value, this.liste, this.fonction);
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> items = this.widget.liste.map(
      (String val) =>
          DropdownMenuItem<String>(
            value: val, 
            child: CustomText(val, darkColor, 5, padding: 0,),
        )).toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(this.widget.title, darkColor, 5, padding: 0,),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: lightGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: const EdgeInsets.only(top:0.0, bottom:0.0, left: 30.0, right: 10),
          child: DropdownButton<String>(
            style: TextStyle(fontSize: size5, color: darkColor),
            icon: Icon(
              Icons.arrow_drop_down,
              color: greyColor,
            ),
            iconSize: 30,
            isExpanded: true,
            hint: CustomText(this.widget.hintText, greyColor, 5, padding: 0,),
            value:this.widget.value,
            items: items,
            onChanged: (String selection) {this.widget.fonction(selection);},
            underline: Container(height: 0),
          ),
        )
      ],),
    );
  }
}


class Background extends StatelessWidget {
  bool isConnected;
  Background({this.isConnected = false});

  @override
  Widget build(BuildContext context) {
    Widget filter = isConnected?
      Container(
        color: Color.fromRGBO(0, 0, 0, 0.3),
      )
      :Container(
        color: Color.fromRGBO(255, 255, 255, 0.5),
      );

    return CachedNetworkImage(
      imageUrl: "https://back-end.diamiba.com/storage/background_mobile.png",
      imageBuilder: (context, imageProvider){
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
          child: filter,
        );
      },
      placeholder: (context, url) => Container(
        color: isConnected?darkColor:whiteColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
      errorWidget: (context, url, error){
        print(error);
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgrown.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: filter,
        );
      } 
    );
  }
}

class CustomBody extends StatefulWidget {
  Widget content;
  String pageName;
  bool isConnected, isSearch, haveBackground;
  double horizontalPadding, bottomPadding;
  var scaffoldState;
  CustomBody(this.content, {this.pageName, this.isConnected = false, this.horizontalPadding = 15, this.bottomPadding = 20, this.haveBackground = true, this.isSearch = false, this.scaffoldState});
  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this.widget.scaffoldState,
      backgroundColor: lightGreyColor,
      endDrawer: drawer(this.widget.isConnected),
      body: this.widget.haveBackground?
        Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Background(isConnected: this.widget.isConnected,),
            body()
          ],
        )
      :body()
    );
  }

  Widget drawer(bool isConnected){
    List<Widget> liste = List();
    liste.add(SizedBox(height: 20,),);
    liste.add(
      Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            child: Icon(Icons.cancel, color: whiteColor, size: 35,),
            onTap: ()=> Navigator.of(context).pop(),
            ),
        ),
      ),
    );
    liste.add(SizedBox(height: 20,),);
    liste.add(
      Container(
        width: 50,
        height: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo_white.png"),
          ),
        ),
      )
    );
    liste.add(SizedBox(height: 40,),);
    if(isConnected){
      liste.add(drawerItem("ENSEIGNANTS", HomePage()));
      liste.add(drawerItem("EXPLORER", ExplorerPage()));
      liste.add(drawerItem("FAVORIS", FavorisPage()));
      if(currentUser is Teacher)
        liste.add(drawerItem("MON COMPTE", EditProfileTeacherPage(currentUser)));
      else
        liste.add(drawerItem("MON COMPTE", EditProfileStudentPage(currentUser)));
      liste.add(drawerItem("MODIFIER MES INFORMATIONS", EditProfilePage(currentUser)));
      liste.add(drawerItem("DECONNEXION", null, isLogout: true));
    }
    else{
      liste.add(drawerItem("CONNEXION", LoginPage()));
      liste.add(drawerItem("INSCRIPTION", RegisterPage()));
      liste.add(drawerItem("MOT DE PASSE OUBLIÉ", PasswordRecoveryPage()));
    }
           
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: mainColor,
        child: ListView(
          children: liste
        ),
      ),
    );
  }



  Widget body(){
    return SafeArea(
      child: ListView(
        children: <Widget>[
          SizedBox(height: this.widget.haveBackground?30:0,),
          StickyHeaderBuilder(
            overlapHeaders: true,
            builder: (BuildContext context, double stuckAmount) {
              stuckAmount = this.widget.haveBackground?(1.0 - stuckAmount.clamp(0.0, 1.0)):1;
              double headerOpacity = (stuckAmount<1)?0:1;
              return new Container(
                height: 55.0,
                //color: mainColor.withOpacity((stuckAmount-0.32).clamp(0.0, 1.0)/0.68),
                padding: new EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(headerOpacity),
                  boxShadow: [BoxShadow(blurRadius: 3, color: mainHighlightColor.withOpacity(headerOpacity))]
                ),
                child: Row(
                  children: <Widget>[
                    this.widget.isConnected?Container(
                      width: 80,
                      height: 35,
                      margin: EdgeInsets.only(left: 25.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/logo_white.png"),
                        ),
                      ),
                    ):Container(),
                    Spacer(flex: 1,),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(0.0),
                      margin: EdgeInsets.only(right: 25.0),
                      height: 32,
                      width: 35,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      child: FlatButton(
                        highlightColor: mainHighlightColor,
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.menu, color: whiteColor, size: 30,),
                        onPressed: ()=>Scaffold.of(context).openEndDrawer(),
                      ),
                    ),
                  ],
                ),
              );
            },
            content: Padding(
              padding: EdgeInsets.only(top: 80.0, bottom: this.widget.bottomPadding, right: this.widget.horizontalPadding, left: this.widget.horizontalPadding),
              child: this.widget.content
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem(String texte, Widget destinationPage, {isLogout = false}){
    return Container(
      color: (texte==this.widget.pageName)?mainHighlightColor:mainColor,
      child: CustomButton(texte, (texte==this.widget.pageName)?mainHighlightColor:mainColor,
        (){
          if(!isLogout){
            Navigator.of(context).pop();
            if(texte!=this.widget.pageName)
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> destinationPage)
              );
          }
          else{
            while(Navigator.of(context).canPop())
              Navigator.of(context).pop();
            currentUser = null;
          }
        },
        shadow: false,
      ),
    );
  }
}



  
class TeacherCard extends StatelessWidget {
  Teacher _teacher;
  bool isFavoriteCard;
  Function retirerFavoris;
  String heroTag;
  TeacherCard(this._teacher, this.heroTag, {this.isFavoriteCard = false, this.retirerFavoris});
  int maxMark=5;

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    String description = this._teacher.description.length<140?this._teacher.description:this._teacher.description.substring(0,139)+"...";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,),
      width: phoneWidth<400?320:350,
      child: CustomCard(
        Column(
          children: <Widget>[
            this._teacher.isChecked?Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: greenColor,
                child: Icon(Icons.check, color: whiteColor, size: 35,),
              ),
            ):Container(height: 35,),
            Hero(
              tag: this.heroTag,
              transitionOnUserGestures: true,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor, width: 3),
                  shape: BoxShape.circle
                ),
                child: CachedNetworkImage(
                  imageUrl: this._teacher.profilePicture!=null?this._teacher.profilePicture:"https://back-end.diamiba.com/storage/default.png",
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    backgroundImage: imageProvider,
                    radius: 70,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                      child: CircularProgressIndicator(
                        backgroundColor: mainLightColor,
                      ),
                      radius: 70,
                    ),
                  errorWidget: (context, url, error){
                    //print(error);
                    return CircleAvatar(
                      backgroundImage: AssetImage("images/profil_picture.png"),
                      radius: 70,
                    );
                  } 
                ),
              ),
            ),
            CustomText("${this._teacher.firstname} ${this._teacher.lastname.toUpperCase()}", darkColor, 3, bold: true,padding: 5, textAlign: TextAlign.center,),
            CustomText(this._teacher.job, mainColor, 4, italic: true,padding: 2, textAlign: TextAlign.center),
            setStars(this._teacher.mark),
            CustomText(description, greyColor, 5, italic: true,textAlign: TextAlign.center,padding: 25, lineSpacing: 1.2),
            CustomButton("VOIR !", mainColor, 
              (){
                print("Voir professeur"); 
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> TeacherDetailsPage(this._teacher, this.heroTag))
                );
              },
              margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            ),
            this.isFavoriteCard? CustomButton("Retirer de mes favoris", redColor, 
              ()async{
                print("Retirer de mes favoris");
                this.retirerFavoris(_teacher);
              },
              margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            ):Container()
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: phoneWidth<400?10:25.0),
      ),
    );
  }
  Widget setStars(int nb){
    nb = (nb>=0 && nb<=maxMark)?nb:0;

    List <Widget> liste = List();
    for(int i=0; i<maxMark; i++)
      liste.add(Icon(i<nb?Icons.star:Icons.star_border, color: mainColor, size: 20.0,));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: liste,
    ) ;
  }
}





class CustomModalProgressHUD extends StatelessWidget {
  bool _isLoading;
  Widget child;
  CustomModalProgressHUD(this._isLoading, this.child);
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      opacity: 0.3,
      color: whiteColor,
      progressIndicator: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
      child:this.child,
    );
  }
}


Future<bool> demandeConfirmation(BuildContext context, String question, {IconData icon}) async {
  bool x = false;
  bool reponse = await showModalBottomSheet<bool>(
    context: context,
    builder: (BuildContext context) => Container(
      color: whiteColor,
      child: ListView(
        shrinkWrap: true,
        primary: false,
        children: <Widget>[
          SizedBox(height: 40.0),
          icon!=null?Center(child:Icon(icon, color: mainColor, size: 40,)):Container(),
          SizedBox(height: 20.0),
          CustomText(question, darkColor, 4, textAlign: TextAlign.center, padding: 0,),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: CustomText("Oui", mainColor, 5, textAlign: TextAlign.center, padding: 0,),
                onPressed: (){
                  x=true;
                  Navigator.pop(context);
                  return true;
                }),
              FlatButton(
                child: CustomText("Non", mainColor, 5, textAlign: TextAlign.center, padding: 0,),
                onPressed: (){
                  x=false;
                  Navigator.pop(context);
                  return false;
                } 
              )
            ],
          )
        ],
      ),
    )
    );
  return x;
}



showNotification(String message, ScaffoldState scaffold){
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: mainHighlightColor,
      content: CustomText(message, whiteColor, 5),
      action: SnackBarAction(label: "Ok", onPressed: (){}, textColor: whiteColor,),
    )
  );
}


class NoteTeacherWidget extends StatefulWidget {
  @override
  _NoteTeacherWidgetState createState() => _NoteTeacherWidgetState();
}

class _NoteTeacherWidgetState extends State<NoteTeacherWidget> {
  int note=0, maxNote=5;
  @override
  Widget build(BuildContext context) {
    List <Widget> liste = List();
    for(int i=1; i<=maxNote; i++)
      liste.add(
        IconButton(
          padding: const EdgeInsets.all(2),
          icon: Icon(i<=note?Icons.star:Icons.star_border, color: mainColor,),
          iconSize: 30,
          onPressed: ()=>setState(()=>note=i),
        )
      );

    return Container(
      padding: EdgeInsets.only(top:25, left: 10, right: 10, bottom: 0),
      child: Column(
        children: <Widget>[
          CustomText("$note/$maxNote", mainColor, 4),
          Row(children: liste,mainAxisAlignment: MainAxisAlignment.center,),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: CustomText("Annuler", greyColor, 5),
                onPressed: ()=>Navigator.of(context).pop(0),
                splashColor: mainColor,
              ),
              FlatButton(
                splashColor: mainColor,
                child: CustomText("Noter", greyColor, 5),
                onPressed: ()=>Navigator.of(context).pop(note),
              ),
            ],
          )
        ],
      ),
    );
  }
}