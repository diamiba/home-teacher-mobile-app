import 'package:flutter/material.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/PasswordChange.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/TeacherDetails.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:home_teacher/vues/EditProfile.dart';
import 'package:home_teacher/vues/EditProfileTeacher.dart';
import 'package:home_teacher/vues/EditProfileStudent.dart';
import 'package:home_teacher/vues/Favoris.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Teacher',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: StartingPage(),
      //showPerformanceOverlay: true,
      onUnknownRoute: (settings)=>MaterialPageRoute(builder: (context)=> StartingPage()),
      routes: <String, WidgetBuilder>{
        Vues.login:(BuildContext context) => LoginPage(),
        Vues.register:(BuildContext context) => RegisterPage(),
        //Vues.teacherDetails:(BuildContext context) => TeacherDetailsPage(),
        //Vues.showPhoto:(BuildContext context) => HomePage(),
        Vues.passwordRecovery:(BuildContext context) => PasswordRecoveryPage(),
        Vues.passwordChange:(BuildContext context) => PasswordChangePage(),
        Vues.home:(BuildContext context) => HomePage(),
        Vues.favoris:(BuildContext context) => FavorisPage(),
        Vues.explorer:(BuildContext context) => ExplorerPage(),
        Vues.editTeacher:(BuildContext context) => EditProfileTeacherPage(),
        Vues.editStudent:(BuildContext context) => EditProfileStudentPage(),
        Vues.editCommon:(BuildContext context) => EditProfilePage(),
      },
    );
  }
}





class StartingPage extends StatefulWidget {
  @override
  _StartingPageState createState() => _StartingPageState();
}
class _StartingPageState extends State<StartingPage> {
  _StartingPageState(){
    checkForData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Teacher',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        backgroundColor: whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/logo.png"),
                ),
              ),
            ),
            //Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
            ),
            SizedBox(height: 60,)
          ],
        )
      ),
    );
  }

  checkForData() async {
    await getCountries();
    await readUserTokenInfo();
    if(currentToken == null)
      Navigator.pushReplacementNamed(context, Vues.login);
    else{
      if(currentUser == null){
        RequestType reponse = await loginWithToken(currentToken);
        if(reponse.getisSuccess){
          getCities();
          currentUser = reponse.getdata;
          if(SearchOptions.isLoaded)
            Navigator.pushReplacementNamed(context, Vues.home);
          else
            Navigator.pushReplacementNamed(context, Vues.login);
        }
        else{
          Navigator.pushReplacementNamed(context, Vues.login);
        }
      }
      else {
        getCities();
        if(!SearchOptions.isLoaded){
          var options = await searchOptionsWithToken(currentToken);
          if(options != null){
            SearchOptions(options);
            if(SearchOptions.isLoaded)
              Navigator.pushReplacementNamed(context, Vues.home);
            else
              Navigator.pushReplacementNamed(context, Vues.login);
          }
          else
            Navigator.pushReplacementNamed(context, Vues.login);
        }
        else
          Navigator.pushReplacementNamed(context, Vues.home);
      }
    }
  }
}