import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:home_teacher/vues/ShowPhoto.dart';

class EditProfilePage extends StatefulWidget {
  User user;
  EditProfilePage(this.user);
  @override
  _EditProfilePageState createState() => _EditProfilePageState(user);
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user;
  int mark, maxMark=5;
  String selectedCountry, indicatif;
  TextEditingController firstname, lastname, mail, country, phoneNumber, adress;

  _EditProfilePageState(this.user){
    selectedCountry = this.user.country;
    firstname = TextEditingController(text: this.user.firstname);
    lastname = TextEditingController(text: this.user.lastname);
    mail = TextEditingController(text: this.user.mail);
    country = TextEditingController(text: this.user.country);
    adress = TextEditingController(text: this.user.adress);
    phoneNumber = TextEditingController(text: this.user.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    indicatif = getIndicatif(selectedCountry);
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: CustomCard(
            Column(
              children: <Widget>[
                Container(
                  color: mainLightColor,
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: this.widget.user.id,
                        transitionOnUserGestures: true,
                        child: GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image.asset("images/profil_picture.png", width: 130,),
                          ),
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> ShowPhoto(image: Image.asset("images/profil_picture.png", fit: BoxFit.contain,), id: this.widget.user.id,))
                            );
                          }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0,),
                        child: CustomButton("CHANGER", mainColor, ()=>print("Changer photo de profil")),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText("Modifier mon profil", darkColor, 3, bold: true),
                ),
                CustomTextField("Nom :", "Exemple : Dubois", TextInputType.text, lastname),
                CustomTextField("Prénom :", "Exemple : François Serges", TextInputType.text, firstname),
                CustomTextField("Adresse mail :", "Exemple : dubois.serges@mail.com", TextInputType.emailAddress, mail),
                CustomDropDown("Pays :", "Exemple : Burkina Faso", selectedCountry, countryList, (String selection) {if (selection != this.selectedCountry) setState((){this.selectedCountry = selection;});}),
                CustomTextField("Numéro de téléphone :", "Exemple : +226 72 69 33 24", TextInputType.phone, phoneNumber, prefixe: indicatif),
                CustomTextField("Adresse :", "Exemple : Pissy, derrière le chateau d'eau", TextInputType.text, adress),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0,),
                  child: CustomButton("ENREGISTER", mainColor, ()=>print("ENREGISTER")),
                ),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText("Modification de mon mot de passe", darkColor, 3, bold: true),
                ),
                CustomTextField("Mot de passe actuel :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                CustomTextField("Nouveau mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, null, obscure: true,),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0,),
                  child: CustomButton("ENREGISTER", mainColor, ()=>print("ENREGISTER")),
                ),
              ],
              ),
            ),
          ),
      ),
      pageName: "MODIFIER MES INFORMATIONS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
    );
  }
}