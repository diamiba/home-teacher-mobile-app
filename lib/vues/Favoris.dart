import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/vues/Utile.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class FavorisPage extends StatefulWidget {
  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  List<Teacher> favoriteTeachers = List.from(teachers);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    return CustomBody(
      favorisCard(favoriteTeachers),
      pageName: "FAVORIS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
    );
  }




  Widget favorisCard(List<Teacher> tearchersFound){afficher(tearchersFound);
    List <Widget> liste = List();
    List <Widget> myTeachers = List();
    liste.add(
      Center(child: CustomText("Mes favoris", darkColor, 2, bold: true, padding: 0,),)
    );

    liste.add(SizedBox(height: 40,));

    if(tearchersFound!=null && tearchersFound.isNotEmpty){
      for(Teacher teacher in tearchersFound)
        myTeachers.add(TeacherCard(teacher, "Favoris${teacher.id}", isFavoriteCard: true, retirerFavoris: this._retirerFavoris,));
      liste.add(Wrap(
        spacing: 15,
        runSpacing: 10,
        children: myTeachers,
      ));
    }
    else
      liste.add(
        Center(child: CustomText("Vous n'avez ajouté aucun favoris pour le moment", greyColor, 4, textAlign: TextAlign.center, padding: 0,),)
      );
    return Container(
      width: MediaQuery.of(context).size.width,
      color: lightGreyColor,
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
      child: Column(
        children: liste
      )
    );
  }


  _retirerFavoris(Teacher teacher) async {
    bool reponse = await demandeConfirmation(context, "Voulez vous vraiment retirer ${teacher.firstname} de vos favoris?");
    
    if(!reponse) return;

    await Future.delayed(
      Duration(seconds: 1)
    );
    print("remove ${teacher.firstname} from favoris");
    int index = favoriteTeachers.indexWhere((t)=>t.id==teacher.id);
    //afficher(favoriteTeachers);
    if(index>=0)
      setState(
        (){
        var t = favoriteTeachers.removeAt(index);
        //favoriteTeachers = List.from(favoriteTeachers);
        }
      ); 
    //afficher(favoriteTeachers);
  }

  afficher(List<Teacher> lt){
    String s = "[ ";
    for(Teacher t in lt)
      s+="(${t.id}-${t.firstname}${t.lastname})";
    print(s);
  }
}