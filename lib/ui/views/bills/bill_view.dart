import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:voting_app/core/enums/viewstate.dart';
import 'package:voting_app/core/models/bill.dart';
import 'package:voting_app/core/models/block_chain_data.dart';
import 'package:voting_app/core/viewmodels/bill_model.dart';
import 'package:voting_app/locator.dart';
import 'package:voting_app/ui/styles.dart';
import 'package:voting_app/ui/views/base_view.dart';
import 'package:voting_app/ui/widgets/house_icon_widget.dart';
import 'package:voting_app/ui/widgets/pie_chart.dart';
import 'package:voting_app/ui/widgets/voting_status_widget.dart';
import 'package:voting_app/ui/widgets/voting_widgets.dart';
import 'package:voting_app/ui/views/bills/pdf_viewer.dart';

class BillPage extends StatefulWidget {
  @override
  _BillPageState createState() => _BillPageState();

  final BlockChainData blockChainData;

  BillPage({Key key, this.blockChainData}) : super(key: key);
}

class _BillPageState extends State<BillPage> {
  BillModel billModel = locator<BillModel>();
  String _vote;
  Bill completeBillData;
  Box<Bill> billsBox = Hive.box<Bill>("bills");

  Future getVote() async {
    // Get all bill data from Box
    List<Bill> list = billsBox.values
        .where((bill) => bill.id == widget.blockChainData.id)
        .toList();
    completeBillData = list[0];

    var vote = await billModel.hasVoted(widget.blockChainData.id);
    setState(() {
      _vote = vote;
    });
  }

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    getVote();
  }

  @override
  Widget build(BuildContext context) {
    double dynamicMediumHeight = MediaQuery.of(context).size.height * 0.25;
    double dynamicLargeWidth = MediaQuery.of(context).size.width * 1;
    if (dynamicLargeWidth > appSizes.largeWidth) {
      dynamicLargeWidth = appSizes.largeWidth;
    }
    return BaseView<BillModel>(
      onModelReady: (model) => model.getBill(completeBillData.id),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: appColors.text),
          elevation: 0,
          title: Text('Vote on Bill', style: appTextStyles.standard),
        ),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                  width: dynamicLargeWidth,
                  child: ListView(
                    children: <Widget>[
                      PieWidget(
                        yes: model.billVoteResult.yes,
                        showValues: true,
                        no: model.billVoteResult.no,
                        radius: dynamicMediumHeight,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 3.0, top: 3.0, left: 20.0),
                        child: Text("Yes: " + completeBillData.yes.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 3.0, top: 3.0, left: 20.0),
                        child: Text("No: " + completeBillData.no.toString(),
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, top: 10.0, left: 20.0),
                        child:
                            HouseIconsWidget(bill: completeBillData, size: 25),
                      ),
                      Container(
                        width: dynamicLargeWidth,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0))),
                        padding: EdgeInsets.all(appSizes.standardPadding),
                        child: Column(
                          children: <Widget>[
                            Align(
                              child: VotingStatusWidget(
                                  bill: completeBillData,
                                  voted: false,
                                  size: 20),
                              alignment: Alignment.centerLeft,
                            ),
                            Align(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 20.0, top: 10.0),
                                child: Text(completeBillData.shortTitle,
                                    style:
                                        Theme.of(context).textTheme.headline5),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                completeBillData.summary,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            Divider(),
                            RaisedButton(
                              padding: EdgeInsets.all(20.0),
                              child: Text("View Bill Text"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfPage(
                                          pdfUrl:
                                              completeBillData.textLinkPdf)),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Text of the bill as introduced into the Parliament",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            RaisedButton(
                              child: Text("View Explanatory Memoranda"),
                              padding: EdgeInsets.all(20.0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PdfPage(
                                          pdfUrl: completeBillData.emLinkPdf)),
                                );
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "Accompanies and provides an explanation of the content of the introduced version (first reading) of the bill.",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VoteWidget(
                        data: widget.blockChainData,
                        vote: model.getVote,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
