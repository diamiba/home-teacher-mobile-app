import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
//import 'package:home_teacher/Modele.dart';
//import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';


class PasswordRecoveryPage extends StatefulWidget {
  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  var _formKeyRecovery = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String _erreurText = "";
  bool _isDone = false, _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return CustomModalProgressHUD(_isLoading,
    CustomBody(
      children : <Widget>[
         SliverToBoxAdapter(
          child: CustomCard(
            Column(
              children: <Widget>[
                BigLogo(),
                CustomText("Retrouvez votre mot de passe.", greyColor, 4),
                SizedBox(height: 30,),
                _isDone?Container():
                Form(
                    key: _formKeyRecovery,
                  child:CustomTextField("Adresse mail :", "Exemple : mon@adresse.mail", TextInputType.emailAddress, emailController,
                      textInputAction: TextInputAction.done,
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
                      onFieldSubmited: (pass) async {
                          _recover();
                      },
                    ),
                ),
                _erreurText.isEmpty?Container():CustomText(_erreurText, redColor, 6, padding: 5, textAlign: TextAlign.center),
                !_isDone?CustomButton("Retrouver mon mot de passe", mainColor,
                  ()async=>_recover(),
                  margin: EdgeInsets.only(top: 15),
                ):Container(),
                _isDone?Card(
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
      pageName: "MOT DE PASSE OUBLIÉ",
    )
    );
  }

  _recover() async {
    print("password recovery");
    setState(()=>_erreurText = "");
    if (!_formKeyRecovery.currentState.validate()) return;
    setState((){
      _isLoading = true;
    } 
    );
    print("mail: ${emailController.text}");
    await Future.delayed(
      Duration(seconds: 2)
    );
    setState((){
      _isLoading = false;
      //_erreurText = "email inexistant";
      _isDone = true;
    } 
    );
  }
}