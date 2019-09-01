import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_teacher/Utile.dart';
import 'package:home_teacher/Modele.dart';
import 'package:home_teacher/Services.dart';
import 'package:home_teacher/vues/Explorer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:home_teacher/vues/CustomWidgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool searched = false, isSearching = false;
  String selectedQuarter, selectedSubject, selectedLevel;
  String lastSearchedQuarter, lastSearchedSubject, lastSearchedLevel;
  RequestType result;
  Widget resultWidget, suggestionsWidget;
  bool isHeaderShown = true;
  bool suggestionsShown = false;
  ScrollController mainScrollController = ScrollController();
  ScrollController myScrollController;
  double lastScrollControlerPosition, phoneWidth, height;

  _HomePageState(){
    selectedQuarter = (SearchOptions.quarterList != null && SearchOptions.quarterList.isNotEmpty) ? SearchOptions.quarterList[0] : "Aucun quartier disponible" ;
    selectedSubject = (SearchOptions.subjectList != null  && SearchOptions.subjectList.isNotEmpty) ? SearchOptions.subjectList[0] : "Aucune matière disponible" ;
    selectedLevel = (SearchOptions.levelList != null  && SearchOptions.levelList.isNotEmpty) ? SearchOptions.levelList[0] : "Aucune classe disponible" ;
    resultWidget = SliverToBoxAdapter(child: Center(child: CustomText("Recherche en cours ...", darkColor, 3, bold: true, textAlign: TextAlign.center,),));
    suggestionsWidget = SliverToBoxAdapter(child: Container());
  }

  void initState() {
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
    height = (MediaQuery.of(context).size.height-460);
    phoneWidth = MediaQuery.of(context).size.width;
    return CustomBody(
      Container(),
      children: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 90,),
              searched?Container():Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Container(
                    height: 45,
                    child: CustomText("Home-Teacher",whiteColor, 1, bold: true, padding: 0,),
                  ),
                  Container(
                    height: 20,
                    margin: const EdgeInsets.only(left: 6),
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
                  SizedBox(height: 50,),
                ],),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCirc,
                margin: EdgeInsets.symmetric(horizontal: searched?45.0:0),
                padding: const EdgeInsets.only(top: 10, bottom: 5, left: 30.0, right: 30.0),
                color: whiteColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    choiceElement(SearchOptions.quarterList, this.selectedQuarter, (String selection) {if (selection != this.selectedQuarter) setState((){this.selectedQuarter = selection;});}),
                    choiceElement(SearchOptions.subjectList, this.selectedSubject, (String selection) {if (selection != this.selectedSubject) setState((){this.selectedSubject = selection;});}),
                    choiceElement(SearchOptions.levelList, this.selectedLevel, (String selection) {if (selection != this.selectedLevel) setState((){this.selectedLevel = selection;});}, isLast: true),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCirc,
                margin: EdgeInsets.symmetric(horizontal: searched?45.0:0),
                color: mainColor,
                //color: SearchOptions.isEmpty ? greyColor : mainColor,
                child: CustomButton("CHERCHER !",
                  mainColor,
                  SearchOptions.isEmpty
                    ? null
                    : () async {
                        print('CHERCHER !');
                        await resultCard();
                      },
                  shadow: false,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOutCirc,
                margin: EdgeInsets.symmetric(horizontal: isSearching?45.0:100),
                color: mainColor,
                child: Visibility(visible: isSearching, child: LinearProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(mainColor)),),
              ),
              searched?SizedBox(height: 50,):SizedBox(height: height<60?60:height),
              searched?Container()
              :Center(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.arrow_drop_down, color: whiteColor, size: 30,),
                        CustomText("EXPLORER", whiteColor, 4, bold: true, padding: 0,),
                      ],
                    ),
                  ),
                  onTap: (){
                    print('Explorer');
                    Navigator.pushNamed(context,Vues.explorer);
                  },
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOutCirc,
            width: MediaQuery.of(context).size.width,
            height: this.searched?MediaQuery.of(context).size.height-kToolbarHeight:0,
            color: lightGreyColor,
            child: Scrollbar(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                controller: myScrollController,
                slivers: <Widget>[
                  SliverToBoxAdapter(child: SizedBox(height: 40,),),
                  resultWidget,
                  suggestionsWidget,
                  SliverToBoxAdapter(child: SizedBox(height: 40,),),
                ],
              ),
            ),
          ),
        ),
      ],
      pageName: "ENSEIGNANTS",
      isConnected: true,
      horizontalPadding: 0,
      bottomPadding: 0,
      myScrollController: mainScrollController,
    );
  }

  Widget choiceElement(List<String> liste, String value, Function fonction, {bool isLast = false}) {
    if(liste != null && liste.isNotEmpty){
      final List<DropdownMenuItem<String>> items = liste.map(
        (String val) =>
            DropdownMenuItem<String>(
              value: val, 
              child: CustomText(val, darkColor, 4, padding: 0,),
          )).toList();
      return Card(
        elevation: 0,
        child: DropdownButton<String>(
          style: TextStyle(fontSize: size4, color: darkColor),
          icon: Icon(
            Icons.arrow_drop_down,
            color: greyColor,
          ),
          iconSize: 30,
          isExpanded: true,
          isDense: true,
          value:value,
          items: items,
          onChanged: (String selection) {fonction(selection);},
          underline: !isLast?Divider(height: 0.2, color: greyColor,):Container(),
        ),
      );
    }
    else{
      return Card(
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(value, darkColor, 4, textAlign: TextAlign.start,),
            !isLast?Divider(height: 0.2, color: greyColor,):Container(),
          ],
        ),
      );
    }
  }

  Future resultCard({bool refresh = false}) async {
    RequestType reponse;
    if(refresh) reponse = this.result;
    else reponse = await loadTeachers();

    if(reponse.isSuccess){
      Widget result, suggestions;
      List<Teacher> tearchersFound = teachersFromList(reponse.data["results"]);
      List<Teacher> tearchersSuggestion = teachersFromList(reponse.data["suggestions"]);
      if(tearchersFound != null && tearchersFound.isNotEmpty){
        result = SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              print(index);
              if(index==0) return Center(child: CustomText("Résultats de la recherche.", darkColor, 2, bold: true, padding: 5,));
              if(index==1) return Center(child: CustomText("${tearchersFound.length} enseignant${tearchersFound.length>1?"s ont été trouvés":" a été trouvé"} !", greyColor, 4, padding: 5,overflow: false));
              if(index==2) return SizedBox(height: 40,);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: (phoneWidth-(phoneWidth<400?320:350))/2),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width<400?320:350),
                child: TeacherCard(tearchersFound[index-3], "Home${tearchersFound[index-3].id}"),
              );
            },
            childCount: tearchersFound.length+3,
          ),
        );
      }
      else
        result = SliverToBoxAdapter(child: notFoundWidget("Aucun résultat n'a été trouvé.", "Vérifiez vos critères de recherche, et reccommencez."));
      
      if(tearchersSuggestion!=null && tearchersSuggestion.isNotEmpty){
        suggestions = SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              print(index);
              if(index==0) return SizedBox(height: 40,);
              if(index==1 && !suggestionsShown)
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: (phoneWidth-250)/2),
                  child: FlatButton.icon(
                    icon: Icon(Icons.add, color: mainColor,),
                    label: CustomText("Voir les suggestions", mainColor, 4), 
                    onPressed: () => seeSuggestions(),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: mainColor)
                    ),
                    splashColor: mainHighlightColor,
                  ),
                );
              if(index==1 && suggestionsShown) return Center(child: CustomText("Suggestions", darkColor, 2, bold: true, padding: 5,));
              if(index==2 && suggestionsShown) return Center(child: CustomText("${tearchersSuggestion.length} enseignant${tearchersSuggestion.length>1?"s ont été suggérés":" a été suggéré"} !", greyColor, 4, padding: 5,overflow: false));
              if(index==3 && suggestionsShown) return SizedBox(height: 40,);
              if(suggestionsShown)
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: (phoneWidth-(phoneWidth<400?320:350))/2),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width<400?320:350),
                  child: TeacherCard(tearchersSuggestion[index-4], "HomeSuggestion${tearchersSuggestion[index-4].id}"),
                );
            },
            childCount: suggestionsShown?tearchersSuggestion.length+4:2,
          ),
        );
      }
      setState(() {
        resultWidget = result;
        if(suggestions != null) suggestionsWidget = suggestions;
        isSearching = false; 
      });
    }
    else
      setState(() {
        suggestionsWidget = SliverToBoxAdapter(child: Container());
        resultWidget = SliverToBoxAdapter(child: errorWidget(reponse));
        isSearching = false; 
      });          
  }

  seeSuggestions() {
    print("object");
    //setState(() => suggestionsShown = true);
    suggestionsShown = true;
    resultCard(refresh: true);
  }

  Future<RequestType> loadTeachers() async {
    if(!searched)
      setState(() {
        searched = true;
        isSearching = true; 
      });

    RequestType reponse;
    if(lastSearchedLevel==null || lastSearchedQuarter==null || lastSearchedSubject==null ||
    !(lastSearchedLevel==selectedLevel && lastSearchedQuarter==selectedQuarter && lastSearchedSubject==selectedSubject)){
      lastSearchedLevel = selectedLevel;
      lastSearchedQuarter = selectedQuarter;
      lastSearchedSubject = selectedSubject;
      setState(() => isSearching = true);
      reponse = await searchTeacher(selectedSubject, selectedLevel, selectedQuarter);
      suggestionsShown = false;
        if(reponse.isSuccess)
          this.result = reponse;
        return reponse;
    }
    else{
      if(this.result == null){
        setState(() => isSearching = true);
        reponse = await searchTeacher(selectedSubject, selectedLevel, selectedQuarter);
        suggestionsShown = false;
        if(reponse.isSuccess)
          this.result = reponse;
        return reponse;
      }
      else
        return this.result;
    }
  }
}