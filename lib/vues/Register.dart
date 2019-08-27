import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart' as serv;
import 'package:home_teacher/vues/CustomWidgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isTeacher = false;
  bool _isDone = false;
  String selectedCountry = AllCountries.countriesNames[0];
  String indicatif;
  bool _isLoading = false;
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyRegister = GlobalKey<FormState>();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  FocusNode firstnameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNode = new FocusNode();
  FocusNode adressFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode passwordConfirmationFocusNode = new FocusNode();
  String _erreurText = "";

  void _changeUserType(bool value){
    setState(() => _isTeacher = value);
  } 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //Afficher la status bar
    indicatif = AllCountries.getCountryPhonePrefix(selectedCountry);
    return CustomModalProgressHUD(_isLoading,
     CustomBody(
       Container(),
     children : <Widget> [
       SliverToBoxAdapter(
        child: CustomCard(
          Column(
            children: <Widget>[
              BigLogo(),
              CustomText("Inscription à Home Teacher.", greyColor, 4),
              !_isDone?Column(
                children: <Widget>[
                  CustomButton("S'inscrire avec Facebook", blueColor,
                    (){
                      print("Inscrire avec Facebook");
                      _registerFacebook();
                    },
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                  ),
                  Row(
                    children: <Widget>[
                      CustomText("Vous êtes :", darkColor, 5, padding: 0,),
                      Spacer(flex: 1),
                      CustomText("Elève", _isTeacher?darkColor:mainColor, 5, padding: 0, bold: true,),
                      Switch(
                        value: _isTeacher,
                        onChanged: _changeUserType,
                        inactiveThumbColor: mainColor,
                        inactiveTrackColor: lightGreyColor,
                        activeColor: mainColor,
                        activeTrackColor: lightGreyColor,
                      ),
                      CustomText("Enseignant",  _isTeacher?mainColor:darkColor, 5, padding: 0, bold: true,),
                      Spacer(flex: 1),
                    ],
                  ),
                  Form(
                    key: _formKeyRegister,
                    child:Column(children: <Widget>[
                      CustomTextField("Nom :", "Exemple : Dubois", TextInputType.text, lastnameController,
                        textCapitalization: TextCapitalization.characters,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre nom";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(firstnameFocusNode));
                        },
                      ),
                      CustomTextField("Prénom :", "Exemple : François Serges", TextInputType.text, firstnameController,
                        textCapitalization: TextCapitalization.words,
                        focus: firstnameFocusNode,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre prénom";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(emailFocusNode));
                        },
                      ),
                      CustomTextField("Adresse mail :", "Exemple : dubois.serges@mail.com", TextInputType.emailAddress, emailController,
                        focus: emailFocusNode,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre adresse mail";
                          else{
                            Pattern pattern =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value))
                              return 'Veuillez saisir une adresse mail valide';
                          }
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(phoneNumberFocusNode));
                        },
                      ),
                      CustomDropDown("Pays :", "Exemple : Burkina Faso", selectedCountry, AllCountries.countriesNames, (String selection) {if (selection != this.selectedCountry) setState((){this.selectedCountry = selection;});}),
                      CustomTextField("Numéro de téléphone :", "Exemple : +226 72 69 33 24", TextInputType.phone, phoneNumberController,
                        focus: phoneNumberFocusNode,
                        prefixe: indicatif,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre numéro de téléphone";
                          int t = int.tryParse(value);
                          if (t==null) return "votre numéro doit contenir uniquement des chiffres";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(adressFocusNode));
                        },
                      ),
                      CustomTextField("Adresse :", "Exemple : Pissy, derrière le chateau d'eau", TextInputType.text, adressController,
                        focus: adressFocusNode,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre adresse";
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(passwordFocusNode));
                        },
                      ),
                      CustomTextField("Mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, passwordController,
                        focus: passwordFocusNode,
                        obscure: true,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir votre mot de passe";
                          else if(value.length<8) return 'Veuillez saisir 8 caractères minimum';
                        },
                        onFieldSubmited: (String value) {
                          setState(()=>FocusScope.of(context).requestFocus(passwordConfirmationFocusNode));
                        },
                      ),
                      CustomTextField("Confirmation du mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, passwordConfirmationController,
                        focus: passwordConfirmationFocusNode,
                        obscure: true,
                        textInputAction: TextInputAction.done,
                        validator: (String value) {
                          if (value.isEmpty) return "Veuillez saisir à nouveau votre mot de passe";
                          if (passwordController.text != passwordConfirmationController.text) return "Les mots de passe ne correspondent pas";
                        },
                        onFieldSubmited: (String value) async {
                            _register();
                        },
                      ),
                    ],)
                  ),
                  _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center),
                  CustomButton("INSCRIPTION", greenColor,
                    ()async=>_register(),
                    margin: EdgeInsets.only(top: 15, bottom: 30),
                  ),
                  GestureDetector(
                    child: CustomText("Je suis déjà inscrit. Me connecter.", darkColor, 5, padding: 8, bold: true, underline: true,),
                    onTap: (){
                      print("Me connecter");
                      while(Navigator.of(context).canPop())
                        Navigator.of(context).pop();
                    },
                  ),
                  GestureDetector(
                    child: CustomText("En vous inscrivant, vous accepter la politique de confidentialité et d'utilisation des données par Home Teacher.", darkColor, 5, padding: 8, textAlign: TextAlign.center, underline: true,),
                    onTap: () => seePrivacyPolitic(),
                  ),
                ],
              ):Container(),
              _isDone?Column(
                children: <Widget>[
                  Card(
                    color: mainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 32),
                      child: CustomText("Un lien de confirmation à été envoyé à votre adresse mail. Veuillez y cliquer pour activer votre compte.",
                      whiteColor, 5, textAlign: TextAlign.center, padding: 0,),
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    child: CustomText("Retour à la page de connexion", darkColor, 5, padding: 8, bold: true, underline: true,),
                    onTap: (){
                      print("Retour à la page de connexion");
                      while(Navigator.of(context).canPop())
                        Navigator.of(context).pop();
                    },
                  ),
                ],
              ):Container()
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
        ),
      ),],
      pageName: "INSCRIPTION",
      scaffoldState: _scaffoldState,
    ));
  }

  _register() async {
    print("inscrire");
    setState(() => _erreurText = "");
    //if (!_formKeyRegister.currentState.validate()) return;
    setState(() => _isLoading = true);
    bool haveInternet = await serv.checkConnection();
    if(!haveInternet){
      setState(() => _isLoading = false);
      showNotification("Veuillez vérifier votre connection internet", this._scaffoldState.currentState);
      return;
    }
    /*print("isTeacher: $_isTeacher | lastname: ${lastnameController.text} | firstname: ${firstnameController.text} | "
      "mail: ${emailController.text} | phoneNumber: ${phoneNumberController.text} | adress: ${adressController.text} "
      "| country: $selectedCountry | password: ${passwordController.text}");*/

    /*var reponse = await serv.register(
      isStudent: !_isTeacher,
      lastName: lastnameController.text,
      firstName: firstnameController.text,
      email: emailController.text,
      phoneNumber: phoneNumberController.text,
      fullAdress: adressController.text,
      countryName: AllCountries.getCountryCode(selectedCountry),
      password: passwordController.text,
    );*/

    var reponse = await serv.register(isStudent:false, firstName:"daren", lastName:"tullet",email:"rasilodo@smart-mail.top", phoneNumber:"12121212", fullAdress:"pissy", password:"11111111", countryName:"BF");
    if(reponse.getisSuccess)
      setState((){
        _isLoading = false;
        _isDone = true;
      });
    else{
      setState(() => _isLoading = false);
      showNotification(reponse.geterrorMessage, this._scaffoldState.currentState);
    }

  }


  _registerFacebook() async {
    bool haveInternet = await serv.checkConnection();
    if(!haveInternet){
      setState(() => _isLoading = false);
      showNotification("Veuillez vérifier votre connection internet", this._scaffoldState.currentState);
      return;
    }
    final facebookSignIn = FacebookLogin();
    final result = await facebookSignIn.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final String token = result.accessToken.token;
        final graphResponse = await http.get(
                    'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = json.decode(graphResponse.body);
        print(profile.toString());
        showNotification(profile.toString(), _scaffoldState.currentState);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Inscription annulée");
        showNotification("Inscription annulée", _scaffoldState.currentState);
        return;
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        showNotification("Echec de l'inscription par Facebook", _scaffoldState.currentState);
        return;
        break;
    }
    setState(() {
      _isDone = true; 
    });
  }


  seePrivacyPolitic() async {
    String url = 'https://home-teacher.africa/politique-de-confidentialite/';
    if (await canLaunch(url)) {
      print("seePrivacyPolitic");
      await launch(url);
    } else {
      print("erreur seePrivacyPolitic");
    }
  }
}

