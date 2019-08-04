import 'dart:io';

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



class User{
  static int _count = 0;
  String firstname, lastname, mail, phoneNumber, adress, country, profilePicture;
  int id;
  User(this.firstname, this.lastname, {this.adress, this.mail, this.phoneNumber, this.country, this.profilePicture}){
    this.id = _count++;
  }
}
var currentUser;
class Student extends User{
  String district, level, school;
  Student(firstname, lastname, { adress, mail, phoneNumber, profilePicture="", this.district, this.level, country, this.school})
  : super(firstname, lastname, adress: adress, mail: mail, phoneNumber: phoneNumber, country: country, profilePicture: profilePicture);
}

List<Student> students = [
  Student("Kryss", "KERE", 
  country: "Burkina Faso",
  adress: "El Ghazalani 3, SETTAT.", 
  mail: "student@home-teacher.africa", 
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
  Teacher(firstname, lastname, this.job, this.description, this.mark, this.isChecked, {profilePicture="", this.numberOfVotes, adress, this.education, mail, phoneNumber, this.districtTeached, this.levelTeached, country, this.subjectTeached})
  : super(firstname, lastname, adress: adress, mail: mail, phoneNumber: phoneNumber, country: country, profilePicture: profilePicture);
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
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/46196161_2596330053740716_3145883108448927744_n.jpg?_nc_cat=104&_nc_eui2=AeHJdxGs4eGIJ0oimfpPV72Bknh6KowJpzMm4RFP-ad6fdJVDz5cORXVce108asyCO5BzoXordlDqXxoGIDnNB5SzXgXfASWMRAgeL4uzAEu0A&_nc_oc=AQncd1ezRUsE1fPb_QXMo40-jGw_MTlcLCKkNRbG8SmV8VdZ4-x3F8RR86Mr611n2M4&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=dedca98a9cdb0577ac4f6d32ff7192b2&oe=5DEB8167",
  subjectTeached: subjectList),
  Teacher("Josias Mansour", "DIAMITANI", "Auditeur junior", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 1, false, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "josias@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/18739928_784019038428140_3166742850023384587_n.jpg?_nc_cat=100&_nc_eui2=AeEpPmKO--PzkLFVg2KDLXILXdmknAGx1-plhb36bOYlsltI6tIgqWVaN-m_6OA-O37gCeGmmjV16_erjjrioZf1HtYlY0oywKv2WnPfBPeZzQ&_nc_oc=AQl33xTGDJzgEsd4pdYR9rLmmw2Pvbg4o-MwkplaDIsLiLb8hq54Ya1MdsEovKZQP48&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=7c30382a8d8ff56cfac29a4e921a4c3b&oe=5DDE3BC4",
  subjectTeached: subjectList),
  Teacher("Abdoul", "BIKIENGA", "Marketeur", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 5, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "abdoul@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/65393177_1251633361696661_6075777993823748096_n.jpg?_nc_cat=101&_nc_eui2=AeHe1Cu5AgY56GGCNB4-Mr7Mzwpe0vn1ByOCVhRxoOv8-MAtUG8I2G3_GbNqFi5HNqDgoC4x1AfQWkIc8yvdMbH4K9_Kds1IomgPpjb9fO2FTg&_nc_oc=AQlx5iiv28o0qvMOBci6uE98O8r_TWGEjkLWQcOm03s1RIwv_MUKqbUdnnJVzjAC66g&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=c0b1b19f1205800c9c6158840e61ff80&oe=5DD6FC96",
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
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/46196161_2596330053740716_3145883108448927744_n.jpg?_nc_cat=104&_nc_eui2=AeHJdxGs4eGIJ0oimfpPV72Bknh6KowJpzMm4RFP-ad6fdJVDz5cORXVce108asyCO5BzoXordlDqXxoGIDnNB5SzXgXfASWMRAgeL4uzAEu0A&_nc_oc=AQncd1ezRUsE1fPb_QXMo40-jGw_MTlcLCKkNRbG8SmV8VdZ4-x3F8RR86Mr611n2M4&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=dedca98a9cdb0577ac4f6d32ff7192b2&oe=5DEB8167",
  subjectTeached: subjectList),
  Teacher("Aubin", "BIRBA", "Ingénieur informatique", "Je suis extrêmement hyper super giga méga sympa, et les enfants m'adorent. En fait tout le monde m'adore, meme si ça n'a rien à avoir avec", 4, true, 
  numberOfVotes: 50, 
  adress: "El Ghazalani 3, SETTAT.", 
  education: "Baccalauréat.", 
  mail: "aubin@home-teacher.africa", 
  phoneNumber: "+22670116531", 
  levelTeached: levelList,
  districtTeached: districtList,
  country: "Burkina Faso",
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/38494113_2185407888354669_3479345245483696128_n.jpg?_nc_cat=101&_nc_eui2=AeHt184Dt8Len1jDDf1YIlLhtmD1HNcSphU36MzlMyjPUjqU_bYBQy7_YaOoVc3NfOnL7tso6FwfuANgIyUjQ8bx2i8FMBLNH9NqLBOvz4Ab5g&_nc_oc=AQnDf0Nmgv212_O9yR4ZaNecgXmWnJDeDytmg4I_C0t-wzf5vN4jmqgPRiYQWgWsGIY&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=49f574a1ddb4d034ef8b12a7ea36f4cf&oe=5DDC83CA",
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
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/46196161_2596330053740716_3145883108448927744_n.jpg?_nc_cat=104&_nc_eui2=AeHJdxGs4eGIJ0oimfpPV72Bknh6KowJpzMm4RFP-ad6fdJVDz5cORXVce108asyCO5BzoXordlDqXxoGIDnNB5SzXgXfASWMRAgeL4uzAEu0A&_nc_oc=AQncd1ezRUsE1fPb_QXMo40-jGw_MTlcLCKkNRbG8SmV8VdZ4-x3F8RR86Mr611n2M4&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=dedca98a9cdb0577ac4f6d32ff7192b2&oe=5DEB8167",
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
  profilePicture: "https://z-p3-scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/46196161_2596330053740716_3145883108448927744_n.jpg?_nc_cat=104&_nc_eui2=AeHJdxGs4eGIJ0oimfpPV72Bknh6KowJpzMm4RFP-ad6fdJVDz5cORXVce108asyCO5BzoXordlDqXxoGIDnNB5SzXgXfASWMRAgeL4uzAEu0A&_nc_oc=AQncd1ezRUsE1fPb_QXMo40-jGw_MTlcLCKkNRbG8SmV8VdZ4-x3F8RR86Mr611n2M4&_nc_ht=z-p3-scontent-lhr3-1.xx&oh=dedca98a9cdb0577ac4f6d32ff7192b2&oe=5DEB8167",
  subjectTeached: subjectList),
];



 Future<bool> checkConnection() async {
  bool reponse = false;
  try {
    final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      reponse = true;
    }
  } on SocketException catch (_) {
    print('not connected');
  }
  catch (_){
    print('bad connection');
  }
  return reponse;
}