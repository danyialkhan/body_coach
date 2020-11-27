import 'package:body_coach/screens/admin/all_categories/categories_list.dart';
import 'package:body_coach/screens/admin/create_categories/add_category.dart';
import 'package:body_coach/screens/home/components/category_card/category_list.dart';
import 'package:body_coach/shared/constants.dart';
import 'package:flutter/material.dart';

import 'create_categories/components/options_button.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OptionButton(
              title: kAddCategory,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddCategory(),
                ),
              ),
            ),
            OptionButton(
              title: kAllCategories,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AllCategories(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
