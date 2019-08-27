import 'dart:convert';

import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:home_teacher/Modele.dart';
import 'dart:io';

import 'package:path/path.dart';
GlobalKey<ScaffoldState> currentScaffoldState;

class Routes{
  static String url = apiURL;
  static String login = "$url/api/login";
  static String loginFB = "$url/api/fbLogin";
  static String register = "$url/api/register";
  static String registerFB = "$url/api/fbRegister";
  static String modifyPassword = "$url/api/modifyPassword";
  static String updateUserDetails = "$url/api/updateUserDetails";
  static String changeUserPicture = "$url/api/changeUserPicture";
  static String currentUser = "$url/api/currentUser";
  static String currentUserPicture = "$url/api/currentUserPicture";
  static String studentSpecs = "$url/api/studentSpecs";
  static String teacherSpecs = "$url/api/teacherSpecs";
  static String searchOptions = "$url/api/getSearchOptions";
  static String countries = "$url/api/getCountriesAndCities";
  static String cities = "$url/api/getTeacherAvailableCities";
  static String exploreLatestTeachers = "$url/api/exploreLatestTeachers";
  static String exploreMostRatedTeachers = "$url/api/exploreMostRatedTeachers";
  static String teacherDetails = "$url/api/teacherDetails/";
  static String currentUserRate = "$url/api/currentUserRate/";
  static String allFavorites = "$url/api/allFavorites";
  static String addFavorite = "$url/api/addFavorite/";
  static String deleteFavorite = "$url/api/deleteFavorite/";
  static String rateTeacher = "$url/api/rateTeacher";
  static String searchTeacher = "$url/api/searchTeacher";
  static String logout = "$url/api/logout";
}


class ReponseType{
  String errorMessage;
  bool isSuccess;
  var data;
  ReponseType(this.isSuccess, {this.errorMessage, this.data});
}

enum ErreurType {
  internet,
  unauthorized,
  undefined
}

class RequestType{
  static int numberOfUnauthorized = 0;
  bool isSuccess;
  ErreurType erreurType;
  String errorMessage;
  var data;
  RequestType({this.isSuccess, this.erreurType, this.errorMessage, this.data});
  factory RequestType.echec(ErreurType erreurType){
    String message;
    switch (erreurType) {
      case ErreurType.internet: message = "Veuillez vérifier votre connexion internet et recommencer";
        break;
      case ErreurType.unauthorized: message = "Désolé vous n'êtes pas autorisé à accéder à ce contenu";
        break;
      case ErreurType.undefined: message = "Désolé, une erreur inattendue s'est produite";
        break;
    }
    return RequestType(isSuccess: false, erreurType: erreurType, errorMessage: message);
  }

  factory RequestType.echecWithCustomMessage(String message) => RequestType(isSuccess: false, erreurType: ErreurType.undefined, errorMessage: message);
  
  factory RequestType.success(var data) => RequestType(isSuccess: true, data: data);


  static Future<RequestType> makeRequest({Function requete, String nom, int duration = 15}) async{
    try {
      var body;
      final response = await requete().timeout(Duration(seconds: duration));
      print('$nom    code: ${response.statusCode}');
      print('header: ${response.headers}');
      if(nom == "changeUserPicture" ){
        print('body: ${response.data}');
        body = response.data;
      }
      else{
        print('body: ${response.body}');
        body = json.decode(response.body);
      }
      if(response.statusCode == 200 && body['success']){
        return RequestType.success(body);
      }
      else if(response.statusCode == 401){
        RequestType.numberOfUnauthorized++;
        if(RequestType.numberOfUnauthorized >= 3){
          try {
            logout();
            for(int i=0; i<4; i++){
              bool success2 = await deleteAllStorage();
              if(success2) break;
            }
          } catch (e) {
            print(e);
          }
          while(Navigator.of(currentScaffoldState.currentContext).canPop())
            Navigator.of(currentScaffoldState.currentContext).pop();
        Navigator.pushReplacement(currentScaffoldState.currentContext, MaterialPageRoute(builder: (context)=> LoginPage(isExpired: true,)));
          
          currentUser = null;
          currentToken = null;
        }
        return RequestType.echec(ErreurType.unauthorized);
      }
      else if(body['success'] != null && body['success']==false){
        String message = (body['message']!=null)
                            ? body['message'].toString()
                            :(body['error']!=null)
                                  ?body['error'].toString()
                                  :'';
        if(message == '') return RequestType.echec(ErreurType.undefined);
        else return RequestType.echecWithCustomMessage(message);
      }
      return RequestType.echec(ErreurType.undefined);
    }  on SocketException catch (_) {
      print(_);
      return RequestType.echec(ErreurType.internet);
    } on TimeoutException catch (_) {
      print(_);
      return RequestType.echec(ErreurType.internet);
    }
    catch (e) {
      print(e);
      return RequestType.echec(ErreurType.undefined);
    }
  }

  bool get getisSuccess => this.isSuccess;
  String get geterrorMessage => this.errorMessage;
  ErreurType get geterreurType => this.erreurType;
  get getdata => this.data;
  set setdata(var newData){
    this.data = newData;
  }
}













Future<RequestType> loginWithToken(String token) async {
  print("loginWithToken");
  var client = new http.Client();
  try {
    var currentUserReponse = await getCurrentUser(token, client: client);
    var options = await searchOptions(token, client: client);
    SearchOptions(options);
    client.close();
    return currentUserReponse;
  }  catch (e) {
    client.close();
    print(e.toString());
    return RequestType.echecWithCustomMessage("Désolé, une erreur s'est produite lors de l'identification !\nVeuillez réessayer");
  }
}


Future<RequestType> login(String email, String password) async{
  var client = new http.Client();
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await client.post(
          Routes.login,
          body: {'email': email, 'password' : password}
        );
      },
      nom: "login",
    );
    if(reponse.getisSuccess){
      String token = reponse.getdata["data"]["token"];
      currentToken = token;
      saveToken(token);
      var currentUserReponse = await getCurrentUser(token, client: client);
      var options = await searchOptions(token, client: client);
      SearchOptions(options);
      client.close();
      return currentUserReponse;
    }
    client.close();
    return reponse;
  } catch (e) {
    client.close();
    print(e);
    return RequestType.echecWithCustomMessage("Désolé, une erreur s'est produite lors de l'identification !\nVeuillez réessayer");
  }
}

Future<RequestType> getCurrentUser(String token, {var client}) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await client.get(
        Routes.currentUser,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    },
    nom: "getCurrentUser",
  );
  if(reponse.getisSuccess){
    bool isStudent = reponse.getdata["data"]["UserRole"]=="student";
    var specialInfo = await currentUserSpecialInfos(token, client: client, isStudent: isStudent);
    var userPicture = await currentUserPicture(token, client: client);
    saveUserInfo(reponse.getdata["data"], specialInfo, userPicture, reponse.getdata["data"]["UserRole"]);
    reponse.setdata = isStudent? Student.fromJson(reponse.getdata["data"], specialInfo, userPicture) : Teacher.fromJson(reponse.getdata["data"], specialInfo, userPicture);
  }
  return reponse;
}

updateUserInfoInStorage() async {
  print("updateUserInfoInStorage");
  var client = new http.Client();
  try {
    await storage.delete(key: "currentUser");
    await getCurrentUser(currentToken, client: client);
    client.close();
  } catch (e) {
    client.close();
  }
}

Future currentUserSpecialInfos(String token, {var client, bool isStudent}) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await client.get(
        isStudent?Routes.studentSpecs:Routes.teacherSpecs,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    },
    nom: "currentUserSpecialInfos",
  );
  if(reponse.getisSuccess){
    return reponse.getdata[isStudent?"preferences":"specs"];
  }
  return null;
}

Future<RequestType> updateCurrentUserSpecialInfos(Map<String,dynamic> body, {bool isStudent}) async{
  print(body);

  if(!isStudent){
    Map<String,dynamic> boddy = {
      'TeachedLevel': json.encode(List<String>.from(body["TeachedLevel"])),
      'TeacherQuarter': json.encode(List<String>.from(body["TeacherQuarter"])),
      'TeachedSubject': json.encode(List<String>.from(body["TeachedSubject"])),
      'StudiesDomain': body["StudiesDomain"],
      'CurrentJob': body["CurrentJob"],
      'LilResume': body["LilResume"],
    };
    /*body["TeachedLevel"] = json.encode(body["TeachedLevel"]);
    body["TeacherQuarter"] = json.encode(body["TeacherQuarter"]);
    body["TeachedSubject"] = json.encode(body["TeachedSubject"]);*/
    body = boddy;
  }
  print(body);
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await http.post(
        isStudent?Routes.studentSpecs:Routes.teacherSpecs,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $currentToken",
        },
        body: body
      );
    },
    nom: "updateCurrentUserSpecialInfos",
    duration: 60
  );
  if(reponse.getisSuccess){
    reponse.setdata = reponse.getdata["data"];
    updateUserInfoInStorage();
  }
  return reponse;
}


Future<RequestType> modifyPassword(String oldPassword, String newPassword) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await http.post(
        Routes.modifyPassword,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $currentToken",
        },
        body: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }
      );
    },
    nom: "updatePassword",
  );
  if(reponse.getisSuccess){
    reponse.setdata = reponse.getdata["data"];
  }
  return reponse;
}


Future<RequestType> updateUserDetails(String firstName, String lastName, String phoneNumber, String fullAdress, String city) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await http.post(
        Routes.updateUserDetails,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $currentToken",
        },
        body: {
          'FirstName': firstName,
          'LastName': lastName,
          'PhoneNumber': phoneNumber,
          'FullAdress': fullAdress,
          'CityName': city,
        }
      );
    },
    nom: "updateUserDetails",
  );
  if(reponse.getisSuccess){
    reponse.setdata = reponse.getdata["data"];
    updateUserInfoInStorage();
  }
  return reponse;
}

//////////// TO TEST
Future<RequestType> changeUserPicture(File _image) async{
  print("changeUserPicture");
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        Dio dio = new Dio();
        FormData formData = new FormData.from({"img": UploadFileInfo(_image, basename(_image.path))});
        Map<String, String> headers = {
          'Authorization': 'Bearer $currentToken',
          "Content-Type": "multipart/form-data",
          "X-Requested-With": "XMLHttpRequest"
        };
        return await dio.post(Routes.changeUserPicture,
          data: formData,
          options: Options(
            method: 'POST',
            headers: headers,
            responseType: ResponseType.json
            ));
      },
      nom: "changeUserPicture",
      duration: 60,
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["message"];
      updateUserInfoInStorage();
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future currentUserPicture(String token, {var client}) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await client.get(
        Routes.currentUserPicture,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    },
    nom: "currentUserPicture",
  );
  if(reponse.getisSuccess){
    return "${Routes.url}${reponse.getdata['url']}";
  }
  return null;
}

Future searchOptionsWithToken(String token) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await http.get(
        Routes.searchOptions,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    },
    nom: "searchOptionsWithToken",
  );
  if(reponse.getisSuccess){
    saveSearchOptions(reponse.getdata["data"]);
    return reponse.getdata["data"];
  }
  return null;
}

Future searchOptions(String token, {var client}) async{
  final RequestType reponse = await RequestType.makeRequest(
    requete: () async {
      return await client.get(
        Routes.searchOptions,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
    },
    nom: "searchOptions",
  );
  if(reponse.getisSuccess){
    saveSearchOptions(reponse.getdata["data"]);
    return reponse.getdata["data"];
  }
  return null;
}

Future getCountries() async{
  if(!AllCountries.isLoaded){
    try {
      final fetchedFile = await DefaultCacheManager().getSingleFile(Routes.countries).timeout(Duration(seconds: 5));
      final response = await fetchedFile.readAsString();
      if(response == null) return AllCountries(null);
      print(response);
      var body = json.decode(response);
      if(body['success']){
        return AllCountries(body["data"]);
      }
      return ReponseType(false, data: body["message"]);
    } catch (e) {
      print(e);
      return AllCountries(null);
    }
  }
}

Future getCities() async{
  if(!AllCities.isLoaded){
    try {
      /*final RequestType reponse = await RequestType.makeRequest(
        requete: () async {
          return await http.get(
            Routes.cities,
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $currentToken",
            },
          );
        },
        nom: "getCities",
      );*/
      final fetchedFile = await DefaultCacheManager().getSingleFile(
        Routes.cities,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $currentToken",
        },
      );
      final response = await fetchedFile.readAsString();
      if(response == null) return AllCities(null);
      print(response);
      var body = json.decode(response);
      if(body['success']){
        return AllCities(body["data"]);
      }
      return AllCities(null);
    } catch (e) {
      print(e);
      return AllCities(null);
    }
  }
}


Future<RequestType> getExploreTeachers(bool isLatest) async{
  try {
    final fetchedFile = await DefaultCacheManager().getSingleFile(
      isLatest?Routes.exploreLatestTeachers:Routes.exploreMostRatedTeachers,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $currentToken",
      },
    ).timeout(Duration(seconds: 15));
    final response = await fetchedFile.readAsString();
    if(response == null) return RequestType.echec(ErreurType.undefined);
    print(response);
    var body = json.decode(response);
    if(body['success']){
      return RequestType.success(body["teachers"]);
    }
    return RequestType.echecWithCustomMessage(body["message"]);
  }  on SocketException catch (_) {
    print(_);
    return RequestType.echec(ErreurType.internet);
  } on TimeoutException catch (_) {
    print(_);
    return RequestType.echec(ErreurType.internet);
  } catch (e) {
    return RequestType.echec(ErreurType.undefined);
  }
}

Future<RequestType> teacherDetails(int teacherId) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.teacherDetails}$teacherId",
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "teacherDetails",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["teacher"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}

Future<RequestType> currentUserRate(int teacherId) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.currentUserRate}$teacherId",
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "currentUserRate",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["rate"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}

Future<RequestType> allFavorites() async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          Routes.allFavorites,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "allFavorites",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["favorites"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
  /*try {
    final fetchedFile = await DefaultCacheManager().getSingleFile(
      Routes.allFavorites,
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $currentToken",
      },
    ).timeout(Duration(seconds: 15));
    final response = await fetchedFile.readAsString();
    if(response == null) return RequestType.echec(ErreurType.undefined);
    print(response);
    var body = json.decode(response);
    if(body['success']){
      return RequestType.success(body["favorites"]);
    }
    return RequestType.echecWithCustomMessage(body["message"]);
  }  on SocketException catch (_) {
    print(_);
    return RequestType.echec(ErreurType.internet);
  } on TimeoutException catch (_) {
    print(_);
    return RequestType.echec(ErreurType.internet);
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }*/
}

Future<RequestType> addFavorite(int teacherId) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.addFavorite}$teacherId",
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "addFavorite",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["message"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}

Future<RequestType> deleteFavorite(int favoriteId) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.deleteFavorite}$favoriteId",
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "deleteFavorite",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["favorites"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future<RequestType> logout() async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          Routes.logout,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $currentToken",
          },
        );
      },
      nom: "logout",
      duration: 30,
    );
    client.close();
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["message"];
    }
    return reponse;
  } catch (e) {
    client.close();
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future<RequestType> rateTeacher(int rate, int teacherId) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.rateTeacher}?rate=$rate&teacherId=$teacherId",
          headers: { HttpHeaders.authorizationHeader: "Bearer $currentToken",},
        );
      },
      nom: "rateTeacher",
    );
    if(reponse.getisSuccess){
      reponse.setdata = reponse.getdata["rate"];
    }
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future<RequestType> searchTeacher(String subject, String level, String quarter) async{
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.get(
          "${Routes.searchTeacher}?subject=$subject&level=$level&quarter=$quarter",
          headers: { HttpHeaders.authorizationHeader: "Bearer $currentToken",},
        );
      },
      nom: "searchTeacher",
    );
    if(reponse.getisSuccess)
      reponse.setdata = reponse.getdata["data"];
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future<RequestType> register({bool isStudent, String firstName, String lastName, String email, String phoneNumber, String fullAdress, String password, String countryName}) async{
  print("isStudent: $isStudent | lastname: $lastName | firstname: $firstName | "
      "mail: $email | phoneNumber: $phoneNumber | adress: $fullAdress "
      "| country: $countryName | password: $password");
  try {
    final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        return await http.post(
          Routes.register,
          body: {
            'isStudent': isStudent.toString(), 
            'FirstName': firstName, 
            'LastName': lastName, 
            'email': email, 
            'PhoneNumber': phoneNumber, 
            'FullAdress': fullAdress, 
            'password' : password,
            'CountryName': countryName, 
          }
        );
      },
      nom: "register",
    );
    /*final RequestType reponse = await RequestType.makeRequest(
      requete: () async {
        Dio dio = new Dio();
        FormData formData = new FormData.from({
          'isStudent': isStudent, 
          'FirstName': firstName, 
          'LastName': lastName, 
          'email': email, 
          'PhoneNumber': phoneNumber, 
          'FullAdress': fullAdress, 
          'password' : password,
          'CountryName': countryName, 
        });
        print(formData.toString());
        return await dio.post(Routes.register,
          data: formData,
          options: Options(
            method: 'POST',
            responseType: ResponseType.json
            ));
      },
      nom: "register",
    );*/
    if(reponse.getisSuccess)
      reponse.setdata = reponse.getdata["Ok"];
    return reponse;
  } catch (e) {
    print(e);
    return RequestType.echec(ErreurType.undefined);
  }
}


Future<bool> checkConnection() async {
  bool reponse = false;
  try {
    final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 10));
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