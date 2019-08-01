import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Login.dart';
import 'package:home_teacher/vues/Utile.dart';


class PasswordRecoveryPage extends StatefulWidget {
  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return CustomBody(
      CustomCard(
        Column(
          children: <Widget>[
            BigLogo(),
            CustomText("Retrouvez votre mot de passe.", greyColor, 4),
            SizedBox(height: 30,),
            !isDone?CustomTextField("Adresse mail :", "Exemple : mon@adresse.mail", TextInputType.emailAddress, null):Container(),
            !isDone?SizedBox(height: 15,):Container(),
            !isDone?CustomButton("Retrouver mon mot de passe", mainColor,
              (){
                print("Retrouver mon mot de passe");
                setState(() {
                  isDone = true; 
                });
              }
            ):Container(),
            isDone?Card(
              color: mainColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 32),
                child: CustomText("Un lien de confirmation à été envoyé à votre adresse mail. Veuillez y cliquer pour pouvoir réinitialiser votre mot de passe.",
                whiteColor, 5, textAlign: TextAlign.center, padding: 0,),
              ),
            ):Container(),
            SizedBox(height: 30,),
            GestureDetector(
              child: CustomText("Retour à la page de connexion", darkColor, 5, padding: 8, bold: true, underline: true,),
              onTap: (){
                print("Retour à la page de connexion");
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> LoginPage())
                );
              },
            ),
          ],
        )
      ),
      pageName: "MOT DE PASSE OUBLIÉ",
    );
  }
}