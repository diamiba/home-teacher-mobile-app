import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';


const Color mainColor = Color.fromRGBO(201, 110, 10, 1);
const Color mainHighlightColor = Color.fromRGBO(163, 88, 8, 1);
const Color darkColor = Color.fromRGBO(65, 65, 65, 1);
const Color greyColor = Color.fromRGBO(113, 113, 113, 1);
const Color lightGreyColor = Color.fromRGBO(228, 228, 228, 1);
const Color whiteColor = Colors.white;
const Color blueColor = Color.fromRGBO(59, 89, 152, 1);
const Color greenColor = Color.fromRGBO(0, 164, 27, 1);
const double size0 = 40.0;
const double size1 = 16.0;
const double size2 = 14.0;
const double size3 = 13.0;


class CustomCard extends StatelessWidget {
  Widget child;
  CustomCard(this.child);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
  bool bold, underline;
  int level = 1;
  double padding;
  TextAlign textAlign;
  CustomText(this.text, this.color, this.level,{this.padding = 15, this.bold = false, this.underline = false, this.textAlign = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    double size;
    switch (level) {
      case 0: size = size0;
        break;
      case 1: size = size1;
        break;
      case 2: size = size2;
        break;
      case 3: size = size3;
        break;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: this.padding, horizontal: 5.0),
      child: Text(
        text,
        style: TextStyle(color: color,
          fontSize: size,
          fontWeight: bold?FontWeight.bold:FontWeight.normal,
          decoration: underline?TextDecoration.underline:TextDecoration.none,
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
  CustomButton(this.text, this.color, this.onPressed);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[CustomText(text, whiteColor, 2),],
      ),
      color: color,
      onPressed: this.onPressed,
    );
  }
}


class CustomTextField extends StatelessWidget {
  String text, hintText;
  TextInputType type;
  TextEditingController controller;
  bool obscure;
  CustomTextField(this.text, this.hintText,this.type, this.controller, {this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(text, darkColor, 3, padding: 0,),
        Card(
          color: lightGreyColor,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(top:2.0, bottom:2.0, left: 30.0),
            child: TextFormField(
              textAlign: TextAlign.start,
              cursorColor: darkColor,
              controller: controller,
              style: TextStyle(fontSize: size3, color: darkColor),
              keyboardType: type,
              obscureText: obscure,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                hintText: hintText,
                hintStyle: TextStyle(fontSize: size3, color: greyColor),
                border: InputBorder.none,
              ),
              onFieldSubmitted: (texte){
              },
              onSaved: (texte){
              },
            ),
          ),
        )
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
            child: CustomText(val, darkColor, 3, padding: 0,),
        )).toList();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
        CustomText(this.widget.title, darkColor, 3, padding: 0,),
        Card(
          color: lightGreyColor,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.only(top:0.0, bottom:0.0, left: 30.0, right: 10),
            child: DropdownButton<String>(
              style: TextStyle(fontSize: size3, color: darkColor),
              icon: Icon(
                Icons.arrow_drop_down,
                color: greyColor,
              ),
              iconSize: 30,
              isExpanded: true,
              hint: CustomText(this.widget.hintText, greyColor, 3, padding: 0,),
              value:this.widget.value,
              items: items,
              onChanged: (String selection) {this.widget.fonction(selection);},
              underline: Container(height: 0),
            ),
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/backgrown.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: isConnected?
      Container(
        color: Color.fromRGBO(0, 0, 0, 0.25),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      )
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
  bool isConnected;
  double horizontalPadding;
  CustomBody(this.content, {this.isConnected = false, this.horizontalPadding = 15});
  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 30,),
        StickyHeaderBuilder(
          overlapHeaders: true,
          builder: (BuildContext context, double stuckAmount) {
            stuckAmount = 1.0 - stuckAmount.clamp(0.0, 1.0);
            double headerOpacity = (stuckAmount<1)?0:1;
            return new Container(
              height: 70.0,
              //color: mainColor.withOpacity((stuckAmount-0.32).clamp(0.0, 1.0)/0.68),
              padding: new EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(headerOpacity),
                boxShadow: [BoxShadow(blurRadius: 3, color: greyColor.withOpacity(headerOpacity))]
              ),
              child: Row(
                children: <Widget>[
                  this.widget.isConnected?Container(
                    width: 120,
                    height: 90,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/logo_white.png"),
                      ),
                    ),
                  ):Container(),
                  Spacer(flex: 1,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      margin: EdgeInsets.only(right: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(width: 0.5, color: (headerOpacity==0?darkColor:whiteColor)),
                      ),
                      elevation: 2,
                      color: mainColor,
                      child: IconButton(
                        highlightColor: mainHighlightColor,
                        padding: const EdgeInsets.all(0.0),
                        icon: Icon(Icons.menu, color: whiteColor, size: 30,),
                        onPressed: (){
                          print("menu");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          content: Padding(
            padding: EdgeInsets.only(top: 80.0, bottom: 20.0, right: this.widget.horizontalPadding, left: this.widget.horizontalPadding),
            child: this.widget.content
          ),
        ),
      ],
    );
  }
}