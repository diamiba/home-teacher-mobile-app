
import 'package:flutter/material.dart';


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
const int maxMark = 5;


String formateNumber(int x){
  if(x==null) return "-";
  try {
    num temp = x;
    if(temp<1000)
      return "$temp";
    else if(temp < 1000000)
      return "${(temp/1000).toStringAsFixed(1)} K";
    else
      return "${(temp/1000000).toStringAsFixed(1)} M";
  } catch (e) {
    return "-";
  }
}
