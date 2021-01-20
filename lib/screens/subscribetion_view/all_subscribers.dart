import 'package:body_coach/models/category_model.dart';
import 'package:body_coach/models/user.dart';
import 'package:body_coach/screens/subscribetion_view/components/subscriber_card.dart';
import 'package:body_coach/services/category_service.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class SubscribersScreen extends StatefulWidget {
  @override
  _SubscribersScreenState createState() => _SubscribersScreenState();
}

class _SubscribersScreenState extends State<SubscribersScreen>
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
    var user = Provider.of<User>(context);
    return Scaffold(
      appBar: GFAppBar(
        title: Text(
          "All Subscribers",
        ),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<List<CategoryModel>>(
            stream: CategoryService(uId: user.uId).categoriesStream(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                var subs = snapshot.data;
                return Container(
                  child: ListView.builder(
                    itemCount: subs.length,
                    itemBuilder: (ctx, index) {
                      return SubCard(
                        model: subs[index],
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: purpleShad,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
