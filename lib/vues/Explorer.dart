import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class ExplorerPage extends StatefulWidget {
  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> with SingleTickerProviderStateMixin {
  bool isMostRecent = true, isHeaderShown = true, isHeaderButtonShown = true;
  ScrollController mainScrollController;
  ScrollController myScrollController;
  TabController tabController;
  double lastScrollControlerPosition, phoneWidth;
  var latestTearchers, mostRatedTeachers;

  void initState() {
    tabController = TabController(length: 2, vsync: this);
    mainScrollController = ScrollController();
    myScrollController = ScrollController();
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
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    phoneWidth = MediaQuery.of(context).size.width;
    return CustomBody(
      Container(),
      children: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 80,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomText("Explorer",whiteColor, 1, bold: true, padding: 0,),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 20,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TyperAnimatedTextKit(
                      isRepeatingAnimation: false,
                      duration: Duration(milliseconds: 1500),
                      text: ["Nos professeurs n'attendent que vous."],
                      textStyle: TextStyle(
                          fontSize: size4,
                          color: whiteColor
                      ),
                      textAlign: TextAlign.start,
                      alignment: AlignmentDirectional.topStart // or Alignment.topLeft
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50,),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-kToolbarHeight,
            color: lightGreyColor,
            child: Scrollbar(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: myScrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(child: SizedBox(height: 40,),),
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    actions: <Widget>[Container()],
                    floating: true,
                    snap: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: (this.isMostRecent?whiteColor:mainColor),
                              boxShadow: [BoxShadow(blurRadius: 3, color: greyColor.withOpacity(0.5), spreadRadius: 0)],
                            ),
                            child: CustomText("Les plus aimés", (this.isMostRecent?greyColor:whiteColor), 4, bold: true, padding: 0,),
                          ),
                          onTap: (){
                            print("les plus aimés");
                            if(this.isMostRecent)
                              setState(() {
                              this.isMostRecent = !this.isMostRecent; 
                              });
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                              color: (this.isMostRecent?mainColor:whiteColor),
                              boxShadow: [BoxShadow(blurRadius: 3, color: greyColor.withOpacity(0.5), spreadRadius: 0)],
                            ),
                            child: CustomText("Derniers ajouts", (this.isMostRecent?whiteColor:greyColor), 4, bold: true, padding: 0,),
                          ),
                          onTap: (){
                            print("Derniers ajouts");
                            if(!this.isMostRecent)
                              setState(() {
                              this.isMostRecent = !this.isMostRecent; 
                              });
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 40,),),
                  explorerCard(this.isMostRecent),
                ],
              ),
            ),
          ),
        ),
      ],
      pageName: "EXPLORER",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      myScrollController: mainScrollController,
    );
  }


  Widget explorerCard(bool isLatest){
    try {
      return FutureBuilder<RequestType>(
        future: loadExploreTeachers(isLatest),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.hasError) return myErrorWidget(RequestType.echecWithCustomMessage("Désolé, un problème s'est produit durant la recherche"), isLatest);
            var reponse = snapshot.data;
            if(reponse.getisSuccess){
              List<Teacher> tearchersFound = teachersFromList(reponse.getdata);
              if(tearchersFound!=null && tearchersFound.isNotEmpty)
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {print(index);
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: (phoneWidth-(phoneWidth<400?320:350))/2),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width<400?320:350),
                        child: TeacherCard(tearchersFound[index], "Explorer$isLatest${tearchersFound[index].id}",),
                      );
                    },
                    childCount: tearchersFound.length,
                  ),
                );
              return myErrorWidget(reponse, isLatest, isEmpty:true);
          }
          else return myErrorWidget(reponse, isLatest);
        }
          else
            return SliverToBoxAdapter(
              child: Center(
                child: Container(
                  width: 250,
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
                  ),
                ),
              ),
            );
        }
      );
    } catch (e) {
      print(e);
      return myErrorWidget(RequestType.echec(ErreurType.undefined), isLatest);
    }
  }

  Future<RequestType> loadExploreTeachers(bool isLatest) async {
    RequestType reponse;
    if((isLatest?this.latestTearchers:this.mostRatedTeachers) == null){
      reponse = await getExploreTeachers(isLatest);
      if(reponse.getisSuccess){
        if(isLatest) this.latestTearchers = reponse.getdata;
        else this.mostRatedTeachers = reponse.getdata;
      }
    }
    else
      reponse = RequestType.success((isLatest?this.latestTearchers:this.mostRatedTeachers));
    return reponse;
  }

  /*Widget animateContent(Widget child, bool isLatest){
    double phoneWidth = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      margin:  (!isLatest)?EdgeInsets.only(left:5):EdgeInsets.only(right:5),
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOutCirc,
      //color: !isLatest?redColor:greenColor,
      //height: (MediaQuery.of(context).size.height)-((index==0)? (isMostRecent ? 200 : 290):(!isMostRecent ? 200 : 290)),
      width: (!isLatest)? (isMostRecent ? (phoneWidth-30) : 0):(!isMostRecent ? (phoneWidth-30) : 0),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        reverse: (!isLatest)?false:true,
        scrollDirection: Axis.horizontal,
        child: Container(child: child, width: phoneWidth-30, alignment: Alignment.topCenter,)
      ),
    );
  }*/

  Widget myErrorWidget(RequestType reponse, bool isLatest, {bool isEmpty = false}){
    /*return isEmpty
        ? SliverToBoxAdapter(child: notFoundWidget("Aucun professeur n'a été trouvé", ""))
        : SliverToBoxAdapter(child: errorWidget(reponse));*/
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          isEmpty ? notFoundWidget("Aucun professeur n'a été trouvé", "") : errorWidget(reponse),
          Container(
            padding: EdgeInsets.symmetric(horizontal: (phoneWidth-250)/2),
            child: FlatButton.icon(
              icon: Icon(Icons.settings_backup_restore, color: mainColor,),
              label: CustomText("Réessayer", mainColor, 4), 
              onPressed: () { Navigator.of(context).pushReplacementNamed(Vues.explorer);},
              shape: RoundedRectangleBorder(
                side: BorderSide(color: mainColor)
              ),
              splashColor: mainHighlightColor,
            ),
          ),
        ],
      ),
    );
  }
}