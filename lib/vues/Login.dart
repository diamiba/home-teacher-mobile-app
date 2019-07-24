import 'package:flutter/material.dart';
import 'package:home_teacher/vues/Utile.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/backgrown.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      margin: EdgeInsets.only(right: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        side: BorderSide(width: 0.5),
                      ),
                      elevation: 2,
                      color: mainColor,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.menu, color: whiteColor, size: 30,),
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  CustomCard(
                    Column(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("images/logo.png"),
                            ),
                          ),
                        ),
                        CustomText("Identifiez vous avant de continuer.", darkColor, 1),
                        SizedBox(height: 30,),
                        CustomButton("Se connecter avec Facebook", blueColor),
                        SizedBox(height: 30,),
                        CustomTextField("Adresse mail :", "Exemple : mon@adresse.mail", TextInputType.text, null),
                        CustomTextField("Mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                        SizedBox(height: 15,),
                        CustomButton("SE CONNECTER", mainColor),
                        SizedBox(height: 30,),
                        CustomText("Mot de passe oublié ?", darkColor, 3, padding: 5,),
                        CustomText("Pas encore inscrit ? Inscrivez-vous ici.", darkColor, 3, padding: 5,),
                        
                      ],
                    )
                  ),
              ],),
            ),
          )
        ],
      ),
    );
  }
}