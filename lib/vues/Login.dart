import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:home_teacher/vues/Home.dart';
//import 'package:home_teacher/vues/Register.dart';
//import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart' as serv;
import 'package:home_teacher/vues/CustomWidgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class LoginPage extends StatefulWidget {
  bool isExpired;
  LoginPage({this.isExpired = false});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  var _formKeyLogin = GlobalKey<FormState>();
  var _scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocusNode = new FocusNode();
  String _erreurText = "";

  @override
  void initState() {
    super.initState();
    if(this.widget.isExpired){
        this.widget.isExpired = false;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => new AlertDialog(
                  title: Icon(Icons.lock_outline, color: mainColor, size: 40,),
                  content: CustomText("Votre session a expiré, veuillez vous identifier à nouveau", greyColor, 5, textAlign: TextAlign.center,),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      textColor: mainColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            );
          }
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //Afficher la status bar
    return CustomModalProgressHUD(_isLoading,
      CustomBody(
        children: [
          SliverToBoxAdapter(
            child: CustomCard(
              Column(
                children: <Widget>[
                  BigLogo(),
                  CustomText("Identifiez vous avant de continuer.", greyColor, 4),
                  CustomButton("Se connecter avec Facebook", blueColor,
                    () async {
                      print("connecter avec Facebook");
                      await _loginFacebook();
                    },
                    margin: EdgeInsets.only(top: 30),
                  ),
                  SizedBox(height: 30,),
                  Form(
                    key: _formKeyLogin,
                    child: Column(
                      children: <Widget>[
                        CustomTextField("Adresse mail :", "Exemple : mon@adresse.mail", TextInputType.emailAddress, emailController,
                          validator: (String value) {
                            if (value.isEmpty) return "Veuillez saisir votre adresse mail";
                            else{
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value))
                                return 'Veuillez saisir une adresse mail valide';
                            }
                            return null;
                          },
                          onFieldSubmited: (String value) {
                              setState(()=>FocusScope.of(context).requestFocus(passwordFocusNode));
                          },
                        ),
                        CustomTextField("Mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, passwordController, obscure: true,
                          focus: passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          validator: (String value) {
                            if (value.isEmpty) return "Veuillez saisir votre mot de passe";
                            else if(value.length<8) return 'Veuillez saisir 8 caractères minimum';
                            return null;
                          },
                          onFieldSubmited: (pass) async {
                              _login();
                          },
                        ),
                      ],
                    ),
                  ),
                  _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center),
                  CustomButton("SE CONNECTER", mainColor,
                    () async => _login(),
                    margin: EdgeInsets.only(top: 15, bottom: 30),
                  ),
                  GestureDetector(
                    child: CustomText("Mot de passe oublié ?", darkColor, 5, padding: 5,),
                    onTap: (){
                      print("mot de passe oublié");
                      Navigator.pushNamed(context,Vues.passwordRecovery);
                    },
                  ),
                  GestureDetector(
                    child: CustomText("Pas encore inscrit ? Inscrivez-vous ici.", darkColor, 5, padding: 5,),
                    onTap: (){
                      print("aller à inscription");
                      Navigator.pushNamed(context,Vues.register);
                    },
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
            ),
          ),
        ],
        pageName: "CONNEXION",
        scaffoldState: _scaffoldState,
      )
    );
  }

  _login() async {
    print("connecter");
    FocusScope.of(context).requestFocus(FocusNode());
    setState(()=>_erreurText = "");
    if (!_formKeyLogin.currentState.validate()) return;
    setState(()=> _isLoading = true);
    print("mail: ${emailController.text} | password: ${passwordController.text}");
    bool haveInternet = await serv.checkConnection();
    if(!haveInternet){
      setState((){
        _isLoading = false;
      });
      showNotification("Veuillez vérifier votre connection internet", this._scaffoldState.currentState);
      return;
    }
    var reponse = await serv.login(emailController.text, passwordController.text);
    //var reponse = await serv.login("vlord368@gmail.com", "11111111");
    if(reponse.getisSuccess && SearchOptions.isLoaded){
      currentUser = reponse.data;
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed(Vues.home);
    }
    else{
      setState(()=>_isLoading = false);
      showNotification(reponse.geterrorMessage, this._scaffoldState.currentState);
    }
  }

  _loginFacebook() async {
    bool haveInternet = await serv.checkConnection();
    if(!haveInternet){
      setState((){
        _isLoading = false;
      });
      showNotification("Veuillez vérifier votre connection internet", this._scaffoldState.currentState);
      return;
    }
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        showNotification('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''', 
         _scaffoldState.currentState);
        
        //_showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        showNotification("Identification annulée", _scaffoldState.currentState);
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        showNotification("Echec de l'identification par Facebook\n${result.errorMessage}", _scaffoldState.currentState);
        break;
    }
  }
}

