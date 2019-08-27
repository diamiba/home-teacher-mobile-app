import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileStudent.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/Favoris.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/TeacherDetails.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Vues{
  static String login = "login";
  static String register = "register";
  static String teacherDetails = "teacherDetails";
  static String showPhoto = "showPhoto";
  static String passwordRecovery = "passwordRecovery";
  static String passwordChange = "passwordChange";
  static String home = "home";
  static String favoris = "favoris";
  static String explorer = "explorer";
  static String editTeacher = "editTeacher";
  static String editStudent = "editStudent";
  static String editCommon = "editCommon";
}


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
        text!=null?text:"",
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
        //boxShadow:this.shadow?[BoxShadow(blurRadius: 2, color: darkColor.withOpacity(0.7), spreadRadius: 0)]:null,
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[CustomText(text, whiteColor, 4, padding: 0, overflow: true,),],
        ),
        color: color,
        splashColor: Colors.black.withOpacity(0.2),
        elevation: this.shadow?2:0,
        highlightElevation: this.shadow?15:0,
        animationDuration: Duration(milliseconds: 500),
        onPressed: this.onPressed,
      ),
    );
  }
}


class DisableField extends StatelessWidget {
  String title, content;
  DisableField(this.title, this.content);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(this.title, greyColor, 5, padding: 0,),
        Container(
          height: 48,
          padding: const EdgeInsets.only(top:0.0, bottom:0.0, left: 30.0, right: 10),
          alignment: Alignment.centerLeft,
          child: CustomText(this.content!=null?this.content:"-", greyColor, 5, padding: 0,),
          decoration: BoxDecoration(
            color: lightGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
        ),
      ]
      )
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
            style: TextStyle(fontSize: size5, color: darkColor,),
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
  Widget image;

  @override
  Widget build(BuildContext context) {
    Widget filter = isConnected?
      Container(
        color: Color.fromRGBO(0, 0, 0, 0.3),
      )
      :Container(
        color: Color.fromRGBO(255, 255, 255, 0.5),
      );
    
    try {
      image = CachedNetworkImage(
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
    } catch (e) {
      if (image == null)
        image = Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/backgrown.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: filter,
        );
    }
    return image;
  }
}



class MyDrawer extends StatefulWidget {
  String pageName;
  bool isConnected;
  Function animateIcon;
  MyDrawer(this.pageName, this.isConnected, this.animateIcon);
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer>  with SingleTickerProviderStateMixin {
  bool  isLoading = false;
  AnimationController _menuAnimationController;

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    this.widget.animateIcon(true);
    _menuAnimationController.forward();
    this.widget.animateIcon(false);
  }

  @override
  void dispose() {
    //this.widget.animateIcon(false);
    _menuAnimationController.reverse();
    _menuAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> liste = List();
    liste.add(SizedBox(height: 20,),);
    liste.add(
      Align(
        alignment: Alignment.topLeft,
        child: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.all(0.0),
          margin: EdgeInsets.only(left: 20.0),
          height: 32,
          width: 35,
          child: FlatButton(
            padding: const EdgeInsets.all(0.0),
            child: AnimatedIcon(
              color: whiteColor,
              icon: AnimatedIcons.menu_close,
              progress: _menuAnimationController,
            ),
            onPressed: () async {
              await _menuAnimationController.reverse();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
    liste.add(SizedBox(height: 20,),);
    liste.add(
      Container(
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/logo_white.png"),
          ),
        ),
      )
    );
    liste.add(SizedBox(height: 40,),);
    if(this.widget.isConnected){
      liste.add(drawerItem("ENSEIGNANTS", Vues.home));
      liste.add(drawerItem("EXPLORER", Vues.explorer));
      liste.add(drawerItem("FAVORIS", Vues.favoris));
      if(currentUser is Teacher)
        liste.add(drawerItem("MON COMPTE", Vues.editTeacher));
      else
        liste.add(drawerItem("MON COMPTE", Vues.editStudent));
      liste.add(drawerItem("MODIFIER MES INFORMATIONS", Vues.editCommon));
      liste.add(drawerItem("DECONNEXION", null, isLogout: true));
    }
    else{
      liste.add(drawerItem("CONNEXION", Vues.login));
      liste.add(drawerItem("INSCRIPTION", Vues.register));
      liste.add(drawerItem("MOT DE PASSE OUBLIÉ", Vues.passwordRecovery));
    }
    liste.add(Visibility(child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)), visible: isLoading,));

           
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

  Widget drawerItem(String texte, String destinationPage, {isLogout = false}){
    return Container(
      color: (texte==this.widget.pageName)?mainHighlightColor:mainColor,
      child: CustomButton(texte, (texte==this.widget.pageName)?mainHighlightColor:mainColor,
        () async {
          if(!isLogout){
            Navigator.of(context).pop();
            if(texte!=this.widget.pageName)
              Navigator.pushNamed(context, destinationPage);
          }
          else{
            bool accord = await demandeConfirmation(context, "Voulez vous vraiment vous déconnecter?", icon: Icons.exit_to_app);
            if(!accord) return;
            setState(() => isLoading=true );
            var reponse = await logout();
            if(reponse.isSuccess || reponse.erreurType == ErreurType.unauthorized){
              for(int i=0; i<4; i++){
                bool success2 = await deleteAllStorage();
                if(success2) break;
              }
              while(Navigator.of(context).canPop())
                Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(Vues.login);

              currentUser = null;
              currentToken = null;
            }
            setState(() => isLoading = false );
          }
        },
        shadow: false,
      ),
    );
  }
}


class CustomBody extends StatefulWidget {
  Widget content;
  List<Widget> children;
  String pageName;
  bool isConnected, isSearch, haveBackground;
  double horizontalPadding, bottomPadding;
  var scaffoldState;
  ScrollController myScrollController;
  CustomBody(this.content, {this.children, this.pageName, this.isConnected = false, this.horizontalPadding = 15, this.bottomPadding = 20, this.haveBackground = true, this.isSearch = false, this.scaffoldState, this.myScrollController}){
    /*if(scaffoldState==null) scaffoldState = GlobalKey<ScaffoldState>();
    this.scaffoldState = scaffoldState;*/
    currentScaffoldState = this.scaffoldState;
  }
  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody>  with TickerProviderStateMixin {
  bool  isLoading = false;
  ScrollController _scrollController;
  AnimationController _menuAnimationController;
  AnimationController _colorAnimationController;
  Animation _colorTween;
  

  @override
  void initState() {
    if(this.widget.myScrollController != null)
      _scrollController = this.widget.myScrollController;
    else
      _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _menuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _colorAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: mainColor.withOpacity(0), end: mainColor).animate(_colorAnimationController);
    super.initState();
  }

  _scrollListener() {
    _colorAnimationController.animateTo(_scrollController.offset / 56);
  }


  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _menuAnimationController.dispose();
    _colorAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this.widget.scaffoldState,
      backgroundColor: lightGreyColor,
      endDrawer: MyDrawer(this.widget.pageName, this.widget.isConnected, this.animateIcon),//  drawer(this.widget.isConnected),
      body: this.widget.haveBackground?
      Stack(
        children: <Widget>[
          Background(isConnected: this.widget.isConnected,),
          body(),
        ],
      )
      :body(),
    );
  }

  Widget appBar(bool haveBackground){
    if(haveBackground)
      return AnimatedBuilder(
          animation: _colorAnimationController,
          builder: (context, child) {
          return SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[Container(),],
            title: Row(
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
                Builder(
                  builder: (context) {
                    return Container(
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
                        padding: const EdgeInsets.all(0.0),
                        child: AnimatedIcon(
                          color: whiteColor,
                          icon: AnimatedIcons.menu_close,
                          progress: _menuAnimationController,
                        ),
                        onPressed: () async {
                          await animateIcon(true);
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
            backgroundColor: _colorTween.value,
          );
        }
      );
    else
      return SliverAppBar(
        pinned: true,
        automaticallyImplyLeading: false,
        actions: <Widget>[Container(),],
        title: Row(
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
            Builder(
              builder: (context) {
                return Container(
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
                    padding: const EdgeInsets.all(0.0),
                    child: AnimatedIcon(
                      color: whiteColor,
                      icon: AnimatedIcons.menu_close,
                      progress: _menuAnimationController,
                    ),
                    onPressed: () async {
                      await animateIcon(true);
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                );
              }
            ),
          ],
        ),
        backgroundColor: mainColor,
      );
  }

  Widget body(){
    List<Widget> mySlivers = List<Widget>();
    mySlivers.add(appBar(this.widget.haveBackground));
    if(this.widget.children != null)
      mySlivers.addAll(this.widget.children);
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: mySlivers,
    );
  }

  /*Widget boddy(){
    return SafeArea(
      child: ListView(
        controller: this.widget.myScrollController,
        children: <Widget>[
          //SizedBox(height: this.widget.haveBackground?30:0,),
          StickyHeaderBuilder(
            overlapHeaders: true,
            builder: (BuildContext context, double stuckAmount) {
              stuckAmount = this.widget.haveBackground?(1.0 - stuckAmount.clamp(0.0, 1.0)):1;
              double headerOpacity = (stuckAmount<1)?0:1;
              return new Container(
                height: 55.0,
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
                        padding: const EdgeInsets.all(0.0),
                        child: AnimatedIcon(
                          color: whiteColor,
                          icon: AnimatedIcons.menu_close,
                          progress: _menuAnimationController,
                        ),
                        onPressed: () async {
                          await animateIcon(true);
                          Scaffold.of(context).openEndDrawer();
                        },
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
  }*/

  animateIcon(bool isOpen) async {
    if(isOpen) await _menuAnimationController.forward();
    else await _menuAnimationController.reverse();
  }
}



  
class TeacherCard extends StatelessWidget {
  Teacher _teacher;
  bool isFavoriteCard;
  int favoriteId;
  Function retirerFavoris;
  String heroTag;
  TeacherCard(this._teacher, this.heroTag, {this.isFavoriteCard = false, this.retirerFavoris, this.favoriteId});
  //int maxMark=5;

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    String description = this._teacher.description.length<140?this._teacher.description:this._teacher.description.substring(0,139)+"...";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,),
      width: phoneWidth<400?320:350,
      constraints: BoxConstraints(maxWidth: phoneWidth<400?320:350),
      child: CustomCard(
        Column(
          children: <Widget>[
            (this._teacher.phoneVerified!=null && this._teacher.phoneVerified==1)?Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: greenColor,
                child: Icon(Icons.check, color: whiteColor, size: 25,),
              ),
            ):Container(height: 25,),
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
                  MaterialPageRoute(builder: (context)=> TeacherDetailsPage(this._teacher, this.heroTag, isFromFavorisPage: this.isFavoriteCard, favoriteId: this.favoriteId,))
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
          SizedBox(height: 20.0),
          icon!=null?Center(child:Icon(icon, color: mainColor, size: 30,)):Container(),
          SizedBox(height: 10.0),
          CustomText(question, darkColor, 5, textAlign: TextAlign.center, padding: 0,),
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
  if(message==null || message=="") message = "Désolé, une erreur s'est produite !";
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: mainHighlightColor,
      content: CustomText(message, whiteColor, 5),
      action: SnackBarAction(label: "Ok", onPressed: (){}, textColor: whiteColor,),
    )
  );
}


class NoteTeacherWidget extends StatefulWidget {
  int note;
  NoteTeacherWidget(this.note);
  @override
  _NoteTeacherWidgetState createState() => _NoteTeacherWidgetState(this.note);
}

class _NoteTeacherWidgetState extends State<NoteTeacherWidget> {
  int note;
  _NoteTeacherWidgetState(note){
    if(note==null) this.note = 0;
    else this.note = note;
  }

  @override
  Widget build(BuildContext context) {
    List <Widget> liste = List();
    for(int i=1; i <= maxMark; i++)
      liste.add(
        IconButton(
          padding: const EdgeInsets.all(2),
          icon: Icon((i<=note) ? Icons.star : Icons.star_border, color: mainColor,),
          iconSize: 30,
          onPressed: ()=>setState(()=>note=i),
        )
      );

    return Container(
      padding: EdgeInsets.only(top:25, left: 10, right: 10, bottom: 0),
      child: Column(
        children: <Widget>[
          CustomText("$note/$maxMark", mainColor, 4),
          Row(children: liste,mainAxisAlignment: MainAxisAlignment.center,),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                child: CustomText("Annuler", greyColor, 5),
                onPressed: ()=>Navigator.of(context).pop(),
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

Widget errorWidget(RequestType reponse){
  IconData icon;
  switch (reponse.geterreurType) {
    case ErreurType.internet: icon = Icons.signal_wifi_off;
      break;
    case ErreurType.unauthorized: icon = Icons.lock_outline;
      break;
    case ErreurType.undefined: icon = Icons.sentiment_dissatisfied;
      break;
  }
  return Center(
      child: Column(
        children: <Widget>[
          Icon(icon, color: mainColor, size: 60,),
          CustomText(reponse.geterrorMessage, greyColor, 4, textAlign: TextAlign.center,)
        ],
      ),
    );
}

Widget notFoundWidget(String message1, String message2){
  return Column(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/coffre-fort.png")),
        ),
        width: 150,
        height: 150,
        margin: const EdgeInsets.only(top: 20, bottom: 30),
      ),
      CustomText(message1, darkColor, 2, bold: true, padding: 5, textAlign: TextAlign.center,),
      CustomText(message2, greyColor, 4, textAlign: TextAlign.center,),
    ],
  );
}