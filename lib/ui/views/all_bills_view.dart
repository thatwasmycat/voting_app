import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voting_app/core/enums/viewstate.dart';
import 'package:voting_app/core/models/bill.dart';
import 'package:voting_app/core/models/block_chain_data.dart';
import 'package:voting_app/core/viewmodels/all_bills_model.dart';
import 'package:voting_app/ui/views/base_view.dart';
import 'package:voting_app/ui/styles.dart';
import 'package:voting_app/ui/widgets/bill_list_item.dart';

class AllBillsPage extends StatefulWidget {
  @override
  _AllBillsPageState createState() => _AllBillsPageState();
}

TextEditingController _textController = TextEditingController();

class _AllBillsPageState extends State<AllBillsPage> {
  @override
  Widget build(BuildContext context) {
    return BaseView<BillsModel>(
        onModelReady: (model) => model.getBills(),
        builder: (context, model, child) => SafeArea(
              child: Scaffold(
                body: model.state == ViewState.Busy
                    ? Center(child: CircularProgressIndicator())
                    : CustomScrollView(
                        slivers: <Widget>[
                          SliverSafeArea(
                            top: false,
                            sliver: SliverAppBar(
                              automaticallyImplyLeading: false,
                              actions: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.filter_list),
                                  tooltip: 'Open filters',
                                  onPressed: () {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FiltersWidget(),
                                      ),
                                    );
                                  },
                                )
                              ],
                              floating: true,
                              pinned: false,
                              stretch: true,
                              snap: true,
                              title: TextField(
                                controller: _textController,
                                onChanged: (value) {
                                  model.searchBills(value);
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.search),
                                    hintText: "Search Bills",
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                          SliverList(
                            key: ObjectKey(model.filteredbills),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return BillListItem(
                                    blockChainData: model.filteredbills[index]);
                              },
                              childCount: model.filteredbills.length,
                            ),
                          )
                        ],
                      ),
              ),
            ));
  }
}

class FiltersWidget extends StatefulWidget {
  @override
  _FiltersWidgetState createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends State<FiltersWidget> {
  bool _lights = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Text("Search Preferences"),
            SwitchListTile(
              title: Text('Exclude voted bills'),
              value: _lights,
              onChanged: (bool value) {
                setState(() {
                  _lights = value;
                });
              },
              secondary: Icon(Icons.videogame_asset),
            )
          ],
        ),
      ),
    );
  }
}

class BillsMessageWidget extends StatelessWidget {
  /// Card for showing a message at the top of the bills list
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appSizes.cardCornerRadius),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: 0, vertical: appSizes.standardMargin),
        elevation: appSizes.cardElevation,
        color: appColors.card,
        child: Container(
          padding: EdgeInsets.all(appSizes.standardPadding),
          width: appSizes.smallWidth,
          child: Column(
            children: <Widget>[
              Text(
                "A list of all Federal Bills",
                style: appTextStyles.smallBold,
              ),
              Container(
                height: 100,
                width: 100,
                child: Image(image: AssetImage('assets/graphics/point.png')),
              ),
              Text(
                "Vote on the Bills by scrolling and tapping on the Bills that matter most to you",
                style: appTextStyles.smallBold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
