import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';
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
  Widget image;
  bool _isLoading = false;
  var _scaffoldState = GlobalKey<ScaffoldState>();
  var _formKeyUpdateInfos = GlobalKey<FormState>();
  var _formKeyUpdatePassword = GlobalKey<FormState>();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordNewController = TextEditingController();
  FocusNode firstnameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode phoneNumberFocusNode = new FocusNode();
  FocusNode adressFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode passwordNewFocusNode = new FocusNode();
  String _erreurTextInfos = "", _erreurTextPassword = "";

  _EditProfilePageState(this.user){
    selectedCountry = this.user.country;
    firstnameController = TextEditingController(text: this.user.firstname);
    lastnameController = TextEditingController(text: this.user.lastname);
    emailController = TextEditingController(text: this.user.mail);
    adressController = TextEditingController(text: this.user.adress);
    phoneNumberController = TextEditingController(text: this.user.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    indicatif = getIndicatif(selectedCountry);
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomModalProgressHUD(_isLoading,
    CustomBody(
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
                          child: CachedNetworkImage(
                            imageUrl: this.user.profilePicture,
                            imageBuilder: (context, imageProvider){
                              this.image = Image(image: imageProvider, fit: BoxFit.contain);
                              return ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Image(image: imageProvider),
                              );
                            },
                            placeholder: (context, url) => ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  padding: EdgeInsets.all(60),
                                  child: CircularProgressIndicator(
                                    backgroundColor: mainLightColor,
                                  ),
                                ),
                              ),
                            errorWidget: (context, url, error){
                              this.image = Image.asset("images/profil_picture.png", fit: BoxFit.contain);
                              print(error);
                              return ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                child: Image.asset("images/profil_picture.png", width: 150,),
                              );
                            } 
                          ),
                        /*ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image.asset("images/profil_picture.png", width: 150,),
                        ),*/
                          onTap: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context)=> ShowPhoto(image: this.image, id: this.user.id,))
                            );
                          }
                        ),
                      ),
                      CustomButton("CHANGER", mainColor, ()=>_changePhoto(),
                        margin: const EdgeInsets.only(top: 25.0,),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText("Modifier mon profil", darkColor, 3, bold: true),
                ),
                Form(
                  key: _formKeyUpdateInfos,
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
                    CustomDropDown("Pays :", "Exemple : Burkina Faso", selectedCountry, countryList, (String selection) {if (selection != this.selectedCountry) setState((){this.selectedCountry = selection;});}),
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
                      textInputAction: TextInputAction.done,
                      validator: (String value) {
                        if (value.isEmpty) return "Veuillez saisir votre adresse";
                      },
                      onFieldSubmited: (String value) {
                         _updateInfos();
                      },
                    ),
                  ],)
                ),
                _erreurTextInfos.isEmpty?Container():CustomText(_erreurTextInfos, redColor, 6, padding: 5, textAlign: TextAlign.center),
                CustomButton("ENREGISTER", mainColor, 
                  ()async=>_updateInfos(),
                  margin: const EdgeInsets.only(top: 25.0,),
                ),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomText("Modification de mon mot de passe", darkColor, 3, bold: true),
                ),
                Form(
                  key: _formKeyUpdatePassword,
                  child:Column(children: <Widget>[
                    CustomTextField("Mot de passe actuel :", "********** ( 8 caractères minimum )", TextInputType.text, passwordController,
                      focus: passwordFocusNode,
                      obscure: true,
                      validator: (String value) {
                        if (value.isEmpty) return "Veuillez saisir votre mot de passe actuel";
                        else if(value.length<8) return 'Votre mot de passe doit contenir 8 caractères minimum';
                      },
                      onFieldSubmited: (String value) {
                        setState(()=>FocusScope.of(context).requestFocus(passwordNewFocusNode));
                      },
                    ),
                    CustomTextField("Nouveau mot de passe :", "********** ( 8 caractères minimum )", TextInputType.text, passwordNewController,
                      focus: passwordNewFocusNode,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      validator: (String value) {
                        if (value.isEmpty) return "Veuillez saisir votre nouveau mot de passe";
                        else if(value.length<8) return 'Votre mot de passe doit contenir 8 caractères minimum';
                        else if(passwordNewController.text == passwordController.text) return "Votre nouveau mot de passe doit être différent\nde l'actuel";
                      },
                      onFieldSubmited: (String value) async {
                        _updatePassword();
                      },
                    ),
                  ],)
                ),
                _erreurTextPassword.isEmpty?Container():CustomText(_erreurTextPassword, redColor, 6, padding: 5, textAlign: TextAlign.center),
                CustomButton("ENREGISTER", mainColor, 
                   ()async=>_updatePassword(),
                  margin: const EdgeInsets.only(top: 25.0,),
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
      scaffoldState: _scaffoldState,
    ));
  }

  _changePhoto(){
    showNotification("Not implemented yet :p", _scaffoldState.currentState);
  }

  _updateInfos() async {
    print("update Infos");
    setState(()=>_erreurTextInfos = "");
    if (!_formKeyUpdateInfos.currentState.validate()) return;
    if (lastnameController.text==user.lastname && firstnameController.text==user.firstname && 
    emailController.text==user.mail && phoneNumberController.text==user.phoneNumber && 
    adressController.text==user.adress && selectedCountry==user.country)
      setState((){
        _erreurTextInfos = "Vous n'avez fait aucune modification";
      } 
      );
    else{
      setState((){
        _isLoading = true;
      } 
      );
      print("lastname: ${lastnameController.text} | firstname: ${firstnameController.text} | "
        "mail: ${emailController.text} | phoneNumber: ${phoneNumberController.text} | adress: ${adressController.text} "
        "| country: $selectedCountry ");
      await Future.delayed(
        Duration(seconds: 2)
      );
      setState((){
        _isLoading = false;
        showNotification("Changements enregistrés", _scaffoldState.currentState);
        //_erreurTextInfos = "email inexistant";
      } 
      );
    }
  }

  _updatePassword() async {
    print("_saveInfos");
    setState(()=>_erreurTextPassword = "");
    if (!_formKeyUpdatePassword.currentState.validate()) return;
    setState((){
      _isLoading = true;
    } 
    );
    print("actuel password: ${passwordController.text} | nouveau password: ${passwordNewController.text}");
    await Future.delayed(
      Duration(seconds: 2)
    );
    setState((){
      _isLoading = false;
      showNotification("Changements enregistrés", _scaffoldState.currentState);
      //_erreurTextPassword = "email inexistant";
    } 
    );
  }
}