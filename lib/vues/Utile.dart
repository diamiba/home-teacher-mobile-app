import 'package:flutter/material.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileStudent.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/vues/Favoris.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/TeacherDetails.dart';
import 'package:sticky_headers/sticky_headers.dart';


const Color mainColor = Color.fromRGBO(201, 110, 10, 1);
const Color mainHighlightColor = Color.fromRGBO(163, 88, 8, 1);
const Color mainLightColor = Color.fromRGBO(255, 246, 236, 1);
const Color darkColor = Color.fromRGBO(65, 65, 65, 1);
const Color greyColor = Color.fromRGBO(113, 113, 113, 1);
const Color lightGreyColor = Color.fromRGBO(244, 244, 244, 1);
const Color whiteColor = Colors.white;
const Color blueColor = Color.fromRGBO(59, 89, 152, 1);
const Color greenColor = Color.fromRGBO(0, 164, 27, 1);
const Color redColor = Color.fromRGBO(194, 41, 36, 1);
const double size1 = 40.0;
const double size2 = 25.0;
const double size3 = 20.0;
const double size4 = 16.0;
const double size5 = 13.0;
const double size6 = 10.0;


const  List<String> districtList = ["Toute la ville", "Pissy", "Goughin", "Karpala", "Ouaga 2000"];
const  List<String> subjectList = ["Mathématiques", "Physique", "Informatique", "Econnomie", "Comptabbilité"];
const List<String> levelList = ["6 ème", "5 ème", "4 ème", "1 ère", "Tle"];
const List<String> countryList = ["Burkina Faso", "Maroc", "Sénégal"];

String getIndicatif(String country){
  String indicatif;
  switch (country) {
    case "Burkina Faso": indicatif = "+226";
      break;
    case "Maroc": indicatif = "+212";
      break;
    case "Sénégal": indicatif = "+224";
      break;
  }
  return indicatif;
}



/*Widget CustomCard(Widget child) {
  return Card(
    margin: const EdgeInsets.all(0),
    elevation: 0,
    color: whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      side: BorderSide(width: 0.2),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 25.0),
      child: child,
    ),
  );
}*/

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
        //border: Border.all(width: 0.5, color: darkColor),
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
  bool bold, underline, italic;
  int level = 1;
  double padding, lineSpacing;
  TextAlign textAlign;
  CustomText(this.text, this.color, this.level,{this.padding = 15, this.lineSpacing = 1, this.bold = false, this.underline = false, this.italic = false, this.textAlign = TextAlign.start});
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
          children: <Widget>[CustomText(text, whiteColor, 4, padding: 0,),],
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
  bool obscure, multiline;
  CustomTextField(this.text, this.hintText,this.type, this.controller, {this.obscure = false, this.multiline = false, this.prefixe});
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(this.widget.text, darkColor, 5, padding: 0,),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: lightGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: EdgeInsets.only(top:0.0, bottom:0.0, left: this.widget.multiline?15:30, right: this.widget.multiline?15:0),
          child: TextField(
            textAlign: TextAlign.left,
            cursorColor: mainColor,
            controller: this.widget.controller,
            style: TextStyle(fontSize: size5, color: darkColor),
            keyboardType: this.widget.type,
            obscureText: (this.widget.obscure && isHidden),
            maxLines: this.widget.multiline?10:1,
            decoration: InputDecoration(
              //prefixText: prefixe,
              contentPadding: (this.widget.prefixe!=null || this.widget.obscure)?EdgeInsets.only(top: 16.5):null,
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
            ),
            /*onFieldSubmitted: (texte){
            },
            onSaved: (texte){
            },*/
          ),
        )
      ],),
    );
  }
}
/*class CustomTextField extends StatelessWidget {
  String text, hintText, prefixe;
  TextInputType type;
  TextEditingController controller;
  bool obscure, multiline, isHidden = true;
  CustomTextField(this.text, this.hintText,this.type, this.controller, {this.obscure = false, this.multiline = false, this.prefixe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(text, darkColor, 5, padding: 0,),
        Container(
          height: 48,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: lightGreyColor,
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          padding: EdgeInsets.only(top:0.0, bottom:0.0, left: multiline?15:30, right: multiline?15:0),
          child: TextField(
            textAlign: TextAlign.left,
            cursorColor: mainColor,
            controller: controller,
            style: TextStyle(fontSize: size5, color: darkColor),
            keyboardType: type,
            obscureText: (obscure && isHidden),
            maxLines: multiline?10:1,
            decoration: InputDecoration(
              //prefixText: prefixe,
              contentPadding: prefixe==null?null: EdgeInsets.only(top: 16.0),
              prefixIcon: prefixe==null?null:
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: CustomText(prefixe, darkColor, 5, padding: 0,),
                ),
              prefixStyle: TextStyle(fontSize: size5, color: darkColor),
              alignLabelWithHint: true,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: size5, color: greyColor),
              border: InputBorder.none,
              suffixIcon: !obscure?null:
                GestureDetector(
                  child: Icon(isHidden?Icons.visibility:Icons.visibility_off),
                  onTap: (){
                    isHidden = ! isHidden;
                  },
                ),
            ),
            /*onFieldSubmitted: (texte){
            },
            onSaved: (texte){
            },*/
          ),
        )
      ],),
    );
  }
}*/



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
  bool isConnected, isSearch;
  Background({this.isConnected = false, this.isSearch = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/backgrown.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: isConnected?
      (isSearch?
      Container(
        color: mainColor.withOpacity(0.15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ):Container(
        color: Color.fromRGBO(0, 0, 0, 0.3),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ))
      :Container(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

class CustomBody extends StatefulWidget {
  Widget content;
  String pageName;
  bool isConnected, isSearch, haveBackground;
  double horizontalPadding, bottomPadding;
  CustomBody(this.content, {this.pageName, this.isConnected = false, this.horizontalPadding = 15, this.bottomPadding = 20, this.haveBackground = true, this.isSearch = false});
  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGreyColor,
      endDrawer: drawer(this.widget.isConnected),
      body: this.widget.haveBackground?
        Stack(
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
      liste.add(drawerItem("MON COMPTE", EditProfileTeacherPage(teachers[0])));
      liste.add(drawerItem("MON COMPTE", EditProfileStudentPage(students[0])));
      liste.add(drawerItem("MODIFIER MES INFORMATIONS", EditProfilePage(teachers[0])));
      liste.add(drawerItem("DECONNEXION", null, isLogout: true));
    }
    else{
      //liste.add(drawerItem("AIDE", HomePage()));
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
    return ListView(
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
                      //boxShadow: [BoxShadow(blurRadius: 3, color: greyColor.withOpacity(headerOpacity))],
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      //border: Border.all(width: 0.5, color: (headerOpacity==0?darkColor:whiteColor)),
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
    );
  }

  Widget drawerItem(String texte, Widget destinationPage, {isLogout = false}){
    /*return ListTile(
      title: Container(
        color: (texte==this.widget.pageName)?mainHighlightColor:mainColor,
        child: Center(child: CustomText(texte, whiteColor, 4))
      ),
      contentPadding: const EdgeInsets.all(0),
      onTap: (){
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
        }
      }
    );*/
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
          }
        },
        shadow: false,
      ),
    );
  }
}



  
class TeacherCard extends StatefulWidget {
  Teacher _teacher;
  bool isFavoriteCard;
  TeacherCard(this._teacher, {this.isFavoriteCard = false});
  _TeacherCardState createState() => _TeacherCardState(this._teacher);
}

class _TeacherCardState extends State<TeacherCard> {
  int maxMark=5;
  Teacher _teacher;
  _TeacherCardState(this._teacher);
  @override
  Widget build(BuildContext context) {
    this._teacher.mark = (this._teacher.mark>=0 && this._teacher.mark<=maxMark)?this._teacher.mark:0;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,),
      width: 350,
      child: CustomCard(
        Column(
          children: <Widget>[
            this._teacher.isChecked?Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: greenColor,
                child: Icon(Icons.check, color: whiteColor, size: 35,),
              ),
            ):Container(),
            Hero(
              tag: this._teacher.id,
              transitionOnUserGestures: true,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: mainColor, width: 3),
                  shape: BoxShape.circle
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage("images/profil_picture.png"),
                  radius: 70,
                ),
              ),
            ),
            CustomText("${this._teacher.firstname} ${this._teacher.lastname.toUpperCase()}", darkColor, 3, bold: true,padding: 5, textAlign: TextAlign.center),
            CustomText(this._teacher.job, mainColor, 4, italic: true,padding: 2, textAlign: TextAlign.center),
            setStars(this._teacher.mark),
            CustomText(this._teacher.description, greyColor, 5, italic: true,textAlign: TextAlign.center,padding: 25, lineSpacing: 1.2,),
            CustomButton("VOIR !", mainColor, 
              (){
                print("Voir professeur"); 
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> TeacherDetailsPage(this._teacher))
                );
              },
              margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            ),
            this.widget.isFavoriteCard? CustomButton("Retirer de mes favoris", redColor, (){
                print("Retirer de mes favoris");
              },
              margin: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
            ):Container()
          ],
        ),
        
      ),
    );
  }
  Widget setStars(int nb){
    List <Widget> liste = List();
    for(int i=0; i<maxMark; i++)
      liste.add(Icon(i<nb?Icons.star:Icons.star_border, color: mainColor, size: 20.0,));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: liste,
    ) ;
  }
}

class User{
  static int _count = 0;
  String firstname, lastname, mail, phoneNumber, adress, country;
  int id;
  User(this.firstname, this.lastname, {this.adress, this.mail, this.phoneNumber, this.country}){
    this.id = _count++;
  }
}

class Student extends User{
  String district, level, school;
  Student(firstname, lastname, { adress, mail, phoneNumber, this.district, this.level, country, this.school})
  : super(firstname, lastname, adress: adress, mail: mail, phoneNumber: phoneNumber, country: country);
}

List<Student> students = [
  Student("Kryss", "KERE", 
  country: "Burkina Faso",
  adress: "El Ghazalani 3, SETTAT.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  level: "4 ème",
  district: "Karpala",
  school: "St JB de la Salle",
)];

class Teacher extends User{
  String job, description, education;
  int mark, numberOfVotes;
  bool isChecked;
  List<String> levelTeached, districtTeached, subjectTeached;
  Teacher(firstname, lastname, this.job, this.description, this.mark, this.isChecked, {this.numberOfVotes, adress, this.education, mail, phoneNumber, this.districtTeached, this.levelTeached, country, this.subjectTeached})
  : super(firstname, lastname, adress: adress, mail: mail, phoneNumber: phoneNumber, country: country);
}

List<Teacher> teachers = [
  Teacher("Kryss", "KERE", "Auto-entrepreneur", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 4, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Josias Mansour", "DIAMITANI", "Auditeur junior", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 1, false, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Abdoul", "BIKIENGA", "Marketeur", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 5, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Kryss", "KERE", "Auto-entrepreneur", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 4, false, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Aubin", "BIRBA", "Ingénieur informatique", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 4, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Kryss", "KERE", "Mécatronicien", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 3, false, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
  Teacher("Kryss", "KERE", "Auto-entrepreneur", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 2, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "kere@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  subjectTeached: subjectList),
];



