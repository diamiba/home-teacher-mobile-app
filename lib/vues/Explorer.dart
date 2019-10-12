import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class ExplorerPage extends StatefulWidget {
  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> with SingleTickerProviderStateMixin {
  bool isMostRecent = true, isHeaderShown = true, isHeaderButtonShown = true;
  ScrollController mainScrollController, myScrollController;
  TabController tabController;
  double lastScrollControlerPosition, phoneWidth;
  var latestTearchers, mostRatedTeachers;

  void initState() {
    tabController = TabController(initialIndex: 1, length: 2, vsync: this);
    tabController.addListener(_tabController);
    mainScrollController = ScrollController();
    myScrollController = ScrollController();
    myScrollController.addListener(_scrollListener);
    lastScrollControlerPosition = myScrollController.initialScrollOffset;
    super.initState();
  }

  _scrollListener() {
    //print("${myScrollController.offset} - $lastScrollControlerPosition  -  ${myScrollController.initialScrollOffset}");
    if(mainScrollController.offset != mainScrollController.position.maxScrollExtent) this.isHeaderShown = true;
    if(myScrollController.offset>lastScrollControlerPosition){ //move down
      if(this.isHeaderShown){
        mainScrollController.jumpTo(mainScrollController.position.maxScrollExtent);
        this.isHeaderShown = false;
      }
      if(isHeaderButtonShown)
        setState(() => isHeaderButtonShown = false);
    }
    else if(myScrollController.offset<=lastScrollControlerPosition || lastScrollControlerPosition<0){ //move up
      if(myScrollController.offset == myScrollController.initialScrollOffset && !this.isHeaderShown){
        mainScrollController.animateTo(
          mainScrollController.position.minScrollExtent,
          curve: Curves.easeInOutCirc, duration: Duration(milliseconds: 150)
        );
        this.isHeaderShown = true;
      }
      if(!isHeaderButtonShown)
        setState(() => isHeaderButtonShown = true);
    }

    lastScrollControlerPosition = myScrollController.offset;
  }
  _tabController(){
    //print(tabController.indexIsChanging);
    //print("previousIndex: ${tabController.previousIndex}  index: ${tabController.index}");
    if(tabController.index!=(isMostRecent?1:0)){
      //print("must change color");
      setState(() {
        isMostRecent = !isMostRecent;
        if(!isHeaderButtonShown)
          isHeaderButtonShown = true;
      });
      if(!isHeaderShown){
        mainScrollController.animateTo(
          mainScrollController.position.minScrollExtent,
          curve: Curves.easeInOutCirc, duration: Duration(milliseconds: 150)
        );
        this.isHeaderShown = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays ([]); // cacher la status bar
    phoneWidth = MediaQuery.of(context).size.width;
    return CustomBody(
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
              Center(child: CustomText("Nos professeurs n'attendent que vous.", whiteColor, 4, padding: 5,)),
              /*Center(
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
              ),*/
              SizedBox(height: 50,),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-kToolbarHeight,
                color: lightGreyColor,
                child: Scrollbar(
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      explorerCard(false),
                      explorerCard(true),
                    ],
                  ),
                ),
              ),
              button()

            ],
          )
        ),
      ],
      pageName: "EXPLORER",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      myScrollController: mainScrollController,
    );
  }


  Widget button(){
    return AnimatedContainer(
      curve: Curves.easeInOutCirc,
      duration: Duration(milliseconds: 500),
      height: isHeaderButtonShown ? 100 : 0,
      child: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: 100,
          alignment: Alignment.center,
          child: Row(
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
                  if(this.isMostRecent){
                    setState(() => this.isMostRecent = false);
                    tabController.animateTo(0);
                    if(!isHeaderShown){
                      mainScrollController.animateTo(
                        mainScrollController.position.minScrollExtent,
                        curve: Curves.easeInOutCirc, duration: Duration(milliseconds: 150)
                      );
                      this.isHeaderShown = true;
                    }
                  }
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
                  if(!this.isMostRecent){
                    setState(() => this.isMostRecent = true);
                    tabController.animateTo(1);
                    if(!isHeaderShown){
                      mainScrollController.animateTo(
                        mainScrollController.position.minScrollExtent,
                        curve: Curves.easeInOutCirc, duration: Duration(milliseconds: 150)
                      );
                      this.isHeaderShown = true;
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
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
            if(reponse != null && reponse.getisSuccess){
              List<Teacher> tearchersFound = teachersFromList(reponse.getdata);
              if(tearchersFound!=null && tearchersFound.isNotEmpty)
                return ListView.builder(
                  controller: myScrollController,
                  itemCount: tearchersFound.length,
                  itemBuilder: (BuildContext context, int index) {//print(index);
                    return Container(
                      padding: EdgeInsets.only(left: (phoneWidth-(phoneWidth<400?320:350))/2, right: (phoneWidth-(phoneWidth<400?320:350))/2, top: (index==0 ? 90 : 0)),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width<400?320:350),
                      child: TeacherCard(tearchersFound[index], "Explorer$isLatest${tearchersFound[index].id}",),
                    );
                  },
                );
              return myErrorWidget(reponse, isLatest, isEmpty:true);
          }
          else return myErrorWidget(reponse, isLatest);
        }
          else
            return Center(
              child: Container(
                width: 250,
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),
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
    return Column(
      children: <Widget>[
        SizedBox(height: 150,),
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
    );
  }
}