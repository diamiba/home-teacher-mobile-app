import 'package:flutter/material.dart';

const Color mainColor = Color.fromRGBO(201, 110, 10, 1);
const Color darkColor = Color.fromRGBO(65, 65, 65, 1);
const Color greyColor = Color.fromRGBO(113, 113, 113, 1);
const Color lightGreyColor = Color.fromRGBO(228, 228, 228, 1);
const Color whiteColor = Colors.white;
const Color blueColor = Color.fromRGBO(59, 89, 152, 1);
const Color greenColor = Color.fromRGBO(0, 164, 27, 1);
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
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: child,
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  String text;
  Color color = whiteColor;
  int level = 1;
  double padding;
  CustomText(this.text, this.color, this.level,{this.padding = 15});
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
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: this.padding, horizontal: 5.0),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: size),
        ),
    );
  }
}

class CustomButton extends StatelessWidget {
  String text;
  Color color = whiteColor;
  CustomButton(this.text, this.color);
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
      onPressed: (){},
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