import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';


final storage = new FlutterSecureStorage();
var currentUser;
const String apiURL = "https://back-end.diamiba.com";
String currentToken;

saveToken(String value) async {
  print("saveToken");
  try {
    await storage.write(key: "currentToken", value: value);
  } catch (e) {
  }
}
saveUserInfo(Map<String, dynamic> userInfo, Map<String, dynamic> specialInfo, String picture, String role) async {
  print("saveUserInfo");
  try {
    Map<String, dynamic> infos = {
      "role": role,
      "userInfo": userInfo,
      "specialInfo": specialInfo,
      "picture": picture,
    };
    String value = json.encode(infos);
    await storage.write(key: "currentUser", value: value);
  } catch (e) {
  }
}

saveSearchOptions(Map<String, dynamic> options) async {
  print("saveSearchOptions");
  try {
    String value = json.encode(options);
    await storage.write(key: "searchOptions", value: value);
  } catch (e) {
  }
}
readUserTokenInfo() async {
  print("readUserTokenInfo");
  try {
    String token = await storage.read(key: "currentToken");
    currentToken = token;
  } catch (e) {}

  try {
    String info = await storage.read(key: "currentUser"); 
    Map<String, dynamic> user = json.decode(info);
    Map<String, dynamic> userInfo = user['userInfo'];
    Map<String, dynamic> specialInfo = user['specialInfo'];
    String picture = user['picture'];
    currentUser = (user['role']=="student")? Student.fromJson(userInfo, specialInfo, picture) : Teacher.fromJson(userInfo, specialInfo, picture);
  } catch (e) {}

  try {
    String searchOptions = await storage.read(key: "searchOptions");
    Map<String, dynamic> options = json.decode(searchOptions);
    print(options.values);
    SearchOptions(options);
  } catch (e) {}
}

deleteAllStorage() async {
  try {
    await storage.deleteAll();
    await DefaultCacheManager().removeFile("$apiURL/api/exploreLatestTeachers");
    await DefaultCacheManager().removeFile("$apiURL/api/exploreMostRatedTeachers");
    await DefaultCacheManager().removeFile("$apiURL/api/getTeacherAvailableCities");
    return true;
  } catch (e) {
    return false;
  }
}

class User{
  String firstname, lastname, mail, phoneNumber, fullAdress, country, city, profilePicture;
  int id, phoneVerified;
  User({
    this.id, 
    this.firstname, 
    this.lastname, 
    this.fullAdress, 
    this.mail, 
    this.phoneNumber, 
    this.country, 
    this.city, 
    this.profilePicture,
    this.phoneVerified
  });
}


class Student extends User{
  String quarter, level, school;
  Student({int id, int phoneVerified, String firstname, String lastname, String fullAdress, String mail, String phoneNumber, String profilePicture, this.quarter, this.level, String country, String city, this.school})
  : super(id: id, firstname: firstname, lastname: lastname, fullAdress: fullAdress, mail: mail, phoneNumber: phoneNumber, country: country, city: city, profilePicture: profilePicture, phoneVerified: phoneVerified);

    factory Student.fromJson(Map<String, dynamic> userInfo, Map<String, dynamic> specialInfo, String picture) => new Student(
      id: userInfo["id"],
      firstname: userInfo["FirstName"],
      lastname: userInfo["LastName"],
      fullAdress: userInfo["FullAdress"],
      mail: userInfo["email"],
      phoneNumber: userInfo["PhoneNumber"],
      profilePicture: picture,
      country: userInfo["country"],
      city: userInfo["city"],
      phoneVerified : int.tryParse(userInfo["phone_verified"]),
      quarter: specialInfo["Quarter"],
      level: specialInfo["SchoolLevel"],
      school: specialInfo["CurrentSchool"],
    );

    Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "fullAdress": fullAdress,
        "mail": mail,
        "phoneNumber": phoneNumber,
        "country": country,
    };
}

class Teacher extends User{
  String job, description, education;
  int mark, numberOfVotes;
  bool isFavorite;
  List<String> levelTeached, quarterTeached, subjectTeached;
  Teacher({int id, String firstname, String lastname, this.job, this.description, this.mark, int phoneVerified=0, String profilePicture, this.numberOfVotes, String fullAdress, this.education, String mail, String phoneNumber, this.quarterTeached, this.levelTeached, String country, String city, this.subjectTeached, this.isFavorite})
  : super(id: id, firstname: firstname, lastname: lastname, fullAdress: fullAdress, mail: mail, phoneNumber: phoneNumber, country: country, city: city, profilePicture: profilePicture, phoneVerified: phoneVerified);

    factory Teacher.fromJson(Map<String, dynamic> userInfo, Map<String, dynamic> specialInfo, String picture) => new Teacher(
      id: userInfo["id"],
      firstname: userInfo["FirstName"],
      lastname: userInfo["LastName"],
      fullAdress: userInfo["FullAdress"],
      mail: userInfo["email"],
      phoneNumber: userInfo["PhoneNumber"],
      profilePicture: picture,
      country: userInfo["country"],
      city: userInfo["city"],
      phoneVerified : int.tryParse(userInfo["phone_verified"]),
      job: specialInfo["CurrentJob"],
      description: specialInfo["lilResume"],
      education: specialInfo["StudiesDomain"],
      //numberOfVotes: specialInfo["school"],
      //mark: specialInfo["school"],
      levelTeached: List.castFrom(specialInfo["TeachedLevel"]),
      quarterTeached: List.castFrom(specialInfo["TeachedQuarter"]),
      subjectTeached: List.castFrom(specialInfo["TeachedSubject"]),
    );

    factory Teacher.fromMap(Map<String, dynamic> userInfo){
      int mark = double.tryParse(userInfo["rating"].toString()).round();
      return Teacher(
        id: userInfo["TeacherId"],
        firstname: userInfo["FirstName"],
        lastname: userInfo["LastName"],
        //fullAdress: userInfo["FullAdress"],
        //mail: userInfo["email"],
        //phoneNumber: userInfo["PhoneNumber"],
        profilePicture: "$apiURL${userInfo["pp"]}",
        //country: userInfo["country"],
        phoneVerified : int.tryParse("${userInfo["phoneVerified"]!=null?userInfo["phoneVerified"]:userInfo["phone_verified"]}"),
        job: userInfo["CurrentJob"],
        description: userInfo["lilResume"],
        education: userInfo["StudiesDomain"],
        numberOfVotes: userInfo["numberOfRates"],
        mark: mark,
        levelTeached: List.from(userInfo["TeachedLevel"]),
        quarterTeached: List.from(userInfo["TeachedQuarter"]),
        subjectTeached: List.from(userInfo["TeachedSubject"]),
      );
    } 

    factory Teacher.withDetail(Map<String, dynamic> userInfo){
      int mark = double.tryParse(userInfo["rating"].toString()).round();
      bool fav = userInfo["isFavorite"].toString()=="true";
      return Teacher(
        id: userInfo["TeacherId"],
        firstname: userInfo["FirstName"],
        lastname: userInfo["LastName"],
        fullAdress: userInfo["FullAdress"],
        mail: userInfo["email"],
        phoneNumber: userInfo["PhoneNumber"],
        profilePicture: "$apiURL${userInfo["pp"]}",
        phoneVerified : int.tryParse("${userInfo["phoneVerified"]!=null?userInfo["phoneVerified"]:userInfo["phone_verified"]}"),
        job: userInfo["CurrentJob"],
        description: userInfo["lilResume"],
        education: userInfo["StudiesDomain"],
        numberOfVotes: int.tryParse(userInfo["numberOfRates"].toString()),
        mark: mark,
        levelTeached: List.from(userInfo["TeachedLevel"]),
        quarterTeached: List.from(userInfo["TeachedQuarter"]),
        subjectTeached: List.from(userInfo["TeachedSubject"]),
        isFavorite: fav,
      );
    }
}




List<Teacher> teachersFromList(List data) {
  return new List<Teacher>.from(data.map((x) => Teacher.fromMap(x)));
}

class SearchOptions{// isEmpty est true lorsque aumoins une des liste est null ou vide
  static bool isLoaded = false, isEmpty = true;
  static List<String> quarterList;
  static List<String> levelList;
  static List<String> subjectList;
  SearchOptions(Map<String, dynamic> data){
    quarterList = List.castFrom<dynamic, String>(data["quarters"]);
    levelList = List.castFrom<dynamic, String>(data["levels"]);
    subjectList = List.castFrom<dynamic, String>(data["subjects"]);
    print("quarter $quarterList");
    print("level $levelList");
    print("subject $subjectList");
    if(quarterList != null && quarterList.isNotEmpty && levelList != null && levelList.isNotEmpty && subjectList != null && subjectList.isNotEmpty)
      isEmpty = false;
    isLoaded = true;
  }
}


class Country{
  int id;
  String name, countryCode, phonePrefix;
  Country({this.id, this.name, this.countryCode, this.phonePrefix});
  factory Country.fromJson(Map<String, dynamic> data) => Country(
    id: data["id"],
    name: data["name"],
    countryCode: data["countryCode"],
    phonePrefix: data["phonePrefix"],
  );
}

class AllCountries{
  static bool isLoaded = false;
  static List<Country> countriesList;
  static List<String> countriesNames;
  AllCountries(List<dynamic> data){
    if (data != null){
      countriesList = List<Country>.from(
        data.map(
          (element) => Country.fromJson(element)
        ).toList()
      );
      isLoaded = true;
    }
    else
      countriesList = [
        Country.fromJson({"id":1,"name":"Burkina Faso","currencyCode":"FCFA","countryCode":"BF","phonePrefix":"+226"}),
        Country.fromJson({"id":2,"name":"Maroc","currencyCode":"MAD","countryCode":"MA","phonePrefix":"+212"}),
        Country.fromJson({"id":3,"name":"Senegal","currencyCode":"FCFA","countryCode":"SN","phonePrefix":"+221"})
      ];

    List<String> names = List();
    countriesList.forEach(
      (ele)=>names.add(ele.name)
    );
    countriesNames = names;
  }

  static String getCountryPhonePrefix(String name){
    return countriesList.firstWhere(
      (ele)=>(ele.name==name)
    ).phonePrefix;
  }

  static String getCountryCode(String name){
    return countriesList.firstWhere(
      (ele)=>(ele.name==name)
    ).countryCode;
  }
}

class AllCities{
  static bool isLoaded = false;
  static List<String> citiesList;
  AllCities(List<dynamic> data){
    if(data != null){
      citiesList = List.castFrom(data);
      if(citiesList != null && citiesList.length>0)
        isLoaded = true;
    }
    if(!isLoaded)
      citiesList = [currentUser.city != null ? currentUser.city : ""];
  }

}