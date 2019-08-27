import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';


class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values); //Afficher la status bar
    return CustomBody(Container(),
      children : <Widget>[
        SliverToBoxAdapter(
          child: CustomCard(
            Column(
              children: <Widget>[
                BigLogo(),
                CustomText("Retrouvez votre mot de passe.", greyColor, 4),
                SizedBox(height: 30,),
                CustomTextField("Nouveau mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                CustomTextField("Retapez le nouveau mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                SizedBox(height: 15,),
                CustomButton("Changer mon mot de passe !", mainColor,
                  (){
                    print("Changer mon mot de passe !");
                  }
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
            ),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          ),
        ),
      ],
    );
  }
}

