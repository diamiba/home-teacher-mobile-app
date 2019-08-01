import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Home.dart';
import 'package:home_teacher/vues/PasswordRecovery.dart';
import 'package:home_teacher/vues/Register.dart';
import 'package:home_teacher/vues/Utile.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //Afficher la status bar
    return CustomBody(
      CustomCard(
        Column(
          children: <Widget>[
            BigLogo(),
            CustomText("Identifiez vous avant de continuer.", greyColor, 4),
            SizedBox(height: 30,),
            CustomButton("Se connecter avec Facebook", blueColor,
              (){
                print("connecter avec Facebook");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> HomePage())
                );
              }
            ),
            SizedBox(height: 30,),
            CustomTextField("Adresse mail :", "Exemple : mon@adresse.mail", TextInputType.emailAddress, null),
            CustomTextField("Mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
            SizedBox(height: 15,),
            CustomButton("SE CONNECTER", mainColor,
              (){
                print("connecter");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> HomePage())
                );
              }
            ),
            SizedBox(height: 30,),
            GestureDetector(
              child: CustomText("Mot de passe oublié ?", darkColor, 5, padding: 5,),
              onTap: (){
                print("mot de passe oublié");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> PasswordRecoveryPage())
                );
              },
            ),
            GestureDetector(
              child: CustomText("Pas encore inscrit ? Inscrivez-vous ici.", darkColor, 5, padding: 5,),
              onTap: (){
                print("aller à inscription");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> RegisterPage())
                );
              },
            ),
          ],
        )
      ),
      pageName: "CONNEXION",
    );
  }
}

