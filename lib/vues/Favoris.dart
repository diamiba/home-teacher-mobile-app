import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class FavorisPage extends StatefulWidget {
  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  List<Teacher> favoriteTeachers = List();
  bool isLoading = true, haveError = false, isHeaderShown = true;
  RequestType reponse;
  double phoneWidth, lastScrollControlerPosition;
  var _scaffoldState = GlobalKey<ScaffoldState>();
  ScrollController mainScrollController, myScrollController;

  void initState() {
    loadData();
    myScrollController = ScrollController();
    mainScrollController = ScrollController();
    myScrollController.addListener(_scrollListener);
    lastScrollControlerPosition = myScrollController.initialScrollOffset;
    super.initState();
  }
  _scrollListener() {
    //print("${myScrollController.offset} - $lastScrollControlerPosition  -  ${myScrollController.initialScrollOffset}");
    if(mainScrollController.offset != mainScrollController.position.maxScrollExtent) this.isHeaderShown = true;
    if(myScrollController.offset>lastScrollControlerPosition && this.isHeaderShown){ //move down
      mainScrollController.jumpTo(mainScrollController.position.maxScrollExtent);
      this.isHeaderShown = false;
    }
    else if(myScrollController.offset<lastScrollControlerPosition || lastScrollControlerPosition<0){ //move up
      if(myScrollController.offset == myScrollController.initialScrollOffset && !this.isHeaderShown){
        mainScrollController.animateTo(
          mainScrollController.position.minScrollExtent,
          curve: Curves.easeInOutCirc, duration: Duration(milliseconds: 150)
        );
        this.isHeaderShown = true;
      }
    }

    lastScrollControlerPosition = myScrollController.offset;
  }

  
  @override
  Widget build(BuildContext context) {
    phoneWidth = MediaQuery.of(context).size.width;
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    
    return CustomBody(
      children: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            //color: redColor,
            height: MediaQuery.of(context).size.height,
            child: Scrollbar(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: myScrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(child: Center(child: CustomText("Mes favoris", darkColor, 2, bold: true, padding: 30,),)),
                  favorisCard(),
                  SliverToBoxAdapter(
                    child: Visibility(
                      visible: this.haveError,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: (phoneWidth-250)/2),
                        child: FlatButton.icon(
                          icon: Icon(Icons.settings_backup_restore, color: mainColor,),
                          label: CustomText("Réessayer", mainColor, 4), 
                          onPressed: () => loadData(),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: mainColor)
                          ),
                          splashColor: mainHighlightColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
      pageName: "FAVORIS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      haveBackground: false,
      scaffoldState: _scaffoldState,
      myScrollController: mainScrollController,
    );
  }




  Widget favorisCard(){
    if(haveError) return SliverToBoxAdapter(child: errorWidget(reponse));
    if(favoriteTeachers!=null && favoriteTeachers.isNotEmpty){
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            print(index);
            if(favoriteTeachers.length==index && isLoading)
              return Container(
                width: 250,
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
                ),
              );
            return Container(
              padding: EdgeInsets.symmetric(horizontal: (phoneWidth-(phoneWidth<400?320:350))/2),
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width<400?320:350),
              child: TeacherCard(favoriteTeachers[index], "Favoris${_getFavoriId(favoriteTeachers[index].id)}", isFavoriteCard: true, retirerFavoris: this._retirerFavoris, favoriteId: _getFavoriId(favoriteTeachers[index].id),),
            );
          },
          childCount: favoriteTeachers.length+(isLoading?1:0),
        ),
      );
    }
    else if(isLoading)
    return SliverToBoxAdapter(
      child: Container(
        width: 200,
        height: 100,
        child: Center(
          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
        ),
      ),
    );
    return SliverToBoxAdapter(child: notFoundWidget("Aucun professeur trouvé dans votre liste de favoris", ""));
  }

  _retirerFavoris(Teacher teacher) async {
    bool reponse = await demandeConfirmation(context, "Voulez vous vraiment retirer ${teacher.firstname} de vos favoris?", icon: Icons.favorite_border);
    if(!reponse) return;
    
    RequestType delete = await deleteFavorite(_getFavoriId(teacher.id));
    if(delete.getisSuccess){
      int index = favoriteTeachers.indexWhere((t)=>t.id==teacher.id);
      if(index>=0)
        setState(
          (){
            favoriteTeachers.removeAt(index);
          }
        );  
    }
    else{
      showNotification(delete.geterrorMessage, _scaffoldState.currentState);
    }
  }

  loadData() async {
    if(!this.isLoading)
      setState(() {
        this.isLoading = true;
      });
    haveError = false;
    this.reponse = await allFavorites();
    if(reponse.getisSuccess){
      List<int> favoritesId = List();
      for(var el in this.reponse.getdata)
        favoritesId.add(el["targetId"]);
      if(favoritesId.isNotEmpty){
        for(int id in favoritesId){
          RequestType details = await teacherDetails(id);
          if(details.getisSuccess){
            Teacher nouveau = Teacher.withDetail(details.getdata);
            setState(() {
             this.favoriteTeachers.add(nouveau);
            });
          }
        }
      }
    }
    else
      haveError = true;
    setState(() {
      this.isLoading = false;
    });
  }

  int _getFavoriId(int id){
    for(var el in this.reponse.getdata)
      if(el["targetId"]==id) return el["id"];
    return 0;
  }
}