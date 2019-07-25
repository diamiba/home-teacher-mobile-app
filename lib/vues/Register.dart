import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isTeacher = false;
  bool _isDone = false;
  String selectedCountry;

  void _changeUserType(bool value){
    setState(() => _isTeacher = value);
  } 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //Afficher la status bar
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          CustomBody(
            CustomCard(
              Column(
                children: <Widget>[
                  BigLogo(),
                  CustomText("Inscription à Home Teacher.", greyColor, 1),
                  SizedBox(height: 30,),
                  !_isDone?Column(
                    children: <Widget>[
                      CustomButton("S'inscrire avec Facebook", blueColor,
                        (){
                          print("Inscrire avec Facebook");
                        }
                      ),
                      SizedBox(height: 30,),
                      Row(
                        children: <Widget>[
                          CustomText("Vous êtes :", darkColor, 3, padding: 0,),
                          Spacer(flex: 1),
                          CustomText("Elève", _isTeacher?darkColor:mainColor, 3, padding: 0, bold: true,),
                          Switch(
                            value: _isTeacher,
                            onChanged: _changeUserType,
                            inactiveThumbColor: mainColor,
                            inactiveTrackColor: lightGreyColor,
                            activeColor: mainColor,
                            activeTrackColor: lightGreyColor,
                          ),
                          CustomText("Enseignant",  _isTeacher?mainColor:darkColor, 3, padding: 0, bold: true,),
                          Spacer(flex: 1),
                        ],
                      ),
                      CustomTextField("Nom :", "Exemple : Dubois", TextInputType.text, null),
                      CustomTextField("Prénom :", "Exemple : François Serges", TextInputType.text, null),
                      CustomTextField("Adresse mail :", "Exemple : dubois.serges@mail.com", TextInputType.emailAddress, null),
                      CustomDropDown("Pays :", "Exemple : Burkina Faso", selectedCountry, ["Burkina Faso", "Maroc", "Mali"], (String selection) {if (selection != this.selectedCountry) setState((){this.selectedCountry = selection;});}),
                      CustomTextField("Numéro de téléphone :", "Exemple : +226 72 69 33 24", TextInputType.text, null),
                      CustomTextField("Adresse :", "Exemple : Pissy, derrière le chateau d'eau", TextInputType.text, null),
                      CustomTextField("Mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                      CustomTextField("Confirmation du mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                      SizedBox(height: 15,),
                      CustomButton("INSCRIPTION", greenColor,
                        (){
                          print("Inscription");
                          setState(() {
                            _isDone = true; 
                          });
                        }
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        child: CustomText("Je suis déjà inscrit. Me connecter.", darkColor, 3, padding: 8, bold: true, underline: true,),
                        onTap: (){
                          print("Me connecter");
                        },
                      ),
                      CustomText("En vous inscrivant, vous accepter la politique de confidentialité et d'utilisation des données par Home Teacher.", darkColor, 3, padding: 8, textAlign: TextAlign.center,),
                    ],
                  ):Container(),
                  _isDone?Column(
                    children: <Widget>[
                      Card(
                        color: mainColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 32),
                          child: CustomText("Un lien de confirmation à été envoyé à votre adresse mail. Veuillez y cliquer pour activer votre compte.",
                          whiteColor, 3, textAlign: TextAlign.center, padding: 0,),
                        ),
                      ),
                      SizedBox(height: 30,),
                      GestureDetector(
                        child: CustomText("Retour à la page de connexion", darkColor, 3, padding: 8, bold: true, underline: true,),
                        onTap: (){
                          print("Retour à la page de connexion");
                          setState(() {
                          _isDone = !_isDone; 
                          });
                        },
                      ),
                    ],
                  ):Container()
                ],
              )
            ),
          )
        ],
      ),
    );
  }
}

