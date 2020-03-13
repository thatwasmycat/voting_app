import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_app/route_generator.dart';
import 'package:voting_app/api/aus_bills.dart';
import 'dart:math';
import 'package:voting_app/styles.dart';
import 'package:voting_app/api/aus_issues.dart';
import 'package:voting_app/cutom_widgets.dart';

class AllIssuesPage extends StatefulWidget {
  @override
  _AllIssuesPageState createState() => _AllIssuesPageState();
}

class _AllIssuesPageState extends State<AllIssuesPage> {
  /// Where all the bills are shown (using ListView)
  var issuesList = [];
  List<Widget> issueWidgetList;
  @override
  Widget build(BuildContext context) {


    int issueNum = issuesList.length;
    issueWidgetList = [];
    issueWidgetList.add(CountUpWidget(number: issueNum,text: "TOTAL ISSUES",));
    for (var i in issuesList) {
      issueWidgetList.add(IssueWidget(i));
    }

    Future<void> getJsonData() async {
//      var b = await fetchIssues();
      var b = await fetchIssuesDev();    // Change to non dev when using api
      setState(() {
        issuesList = b;
      }
      );
    }


    loadedNotLoaded(){
      if (issueNum == 0){
        getJsonData();
        return Center();
      }else{
        return Center(
          child: ListView(
            controller: ScrollController(),
            children: issueWidgetList,
          ),
        );
      }
    }
    return loadedNotLoaded();
  }
}
class IssueWidget extends StatelessWidget {
  dynamic issuesMap;
  final Map billColorsDark = {
    "House": appColors.house,
    "Senate": appColors.senate
  };
  final Random random = new Random();
  IssueWidget(Map m) {
    this.issuesMap = m;
  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            elevation: 5.0,
            color: appColors.card,
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  // Pushing a named route
                  Navigator.of(context).pushNamed(
                    '/item',
                    arguments: issuesMap,
                  );
                },
                child: Container(
                    width: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
//                              VotingStatusWidget(
//                                  issuesMap, random.nextInt(5) == 0),
                              Text("Open",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Text(issuesMap["Short Title"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appColors.text)),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.contacts,
                                    color: appColors.text,
                                  ),
                                  Text(
                                    (issuesMap["Yes"]+issuesMap["No"]).toString(),
                                    style: TextStyle(
                                        color: appColors.text, fontSize: 10),
                                  )
                                ],
                              ),
                              PieWidget(
                                // Delete Random when vote status is obtained
                                yes: issuesMap["Yes"],
                                no: issuesMap["No"],
                                radius: 55,
                              )
                            ],
                          ),
                        ),
                      ],
                    )))));
  }
}

class VotingStatusWidget extends StatelessWidget {
  Map billsMap;
  bool voted;
  VotingStatusWidget(Map m, bool v) {
    this.billsMap = m;
    this.voted = v;
  }

  statusMessage() {
    String s = "Closed";
    Color c = Colors.red;
    var i = Icons.adjust;
    if (voted) {
      s = "Voted";
      c = Colors.blue;
      i = Icons.check_circle_outline;
    } else {
      if (billsMap["Chamber"] == "House") {
        if (billsMap["Passed Senate"] == "") {
          s = "Open";
          c = Colors.green;
          i = Icons.add_circle_outline;
        }
      } else {
        if (billsMap["Passed House"] == "") {
          s = "Open";
          c = Colors.green;
          i = Icons.add_circle_outline;
        }
      }
    }

    return [c, s, i];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Icon(
          statusMessage()[2],
          color: statusMessage()[0],
          size: 20,
        ),
        Text(
          statusMessage()[1],
          style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: statusMessage()[0]),
        ),
      ],
    ));
  }
}
