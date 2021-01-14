import 'package:body_coach/screens/subscribetion_view/components/all_req_tabbar.dart';
import 'package:body_coach/screens/subscribetion_view/components/all_sub_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/tabs/gf_segment_tabs.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';

class CategoryDetail extends StatefulWidget {
  final String cId;
  final String title;
  final String cImg;

  CategoryDetail({
    this.title,
    this.cId,
    this.cImg,
  });

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        iconTheme: IconThemeData(
          color: GFColors.LIGHT,
        ),
        backgroundColor: GFColors.DARK,
        title: GFSegmentTabs(
          tabController: tabController,
          tabBarColor: GFColors.LIGHT,
          labelColor: GFColors.WHITE,
          unselectedLabelColor: GFColors.DARK,
          indicator: BoxDecoration(
            color: GFColors.DARK,
          ),
          indicatorPadding: EdgeInsets.all(8.0),
          indicatorWeight: 2.0,
          border: Border.all(color: Colors.white, width: 1.0),
          length: 3,
          tabs: <Widget>[
            Text(
              "All Subscribers",
            ),
            Text(
              "Requests",
            ),
          ],
        ),
      ),
      body: GFTabBarView(controller: tabController, children: <Widget>[
        AllSubTabBar(catId: widget.cId,),
        AllReqTabBar(catId: widget.cId,),
      ]),
    );
  }
}
